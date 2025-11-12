# Image Upload & Retrieval Flow - Complete Guide

## 🎯 Overview

Your TicketBooking app uses **Supabase Storage** to store images and **Supabase Database** to reference them. Here's how the complete flow works:

---

## 📊 Complete Flow Diagram

```
Admin adds Bus/Event
        ↓
[Add Bus/Event Screen]
        ↓
User selects image (Camera/Gallery)
        ↓
[Image Picker Widget]
        ↓
Image file stored in XFile (_selectedImage)
        ↓
Admin fills form & clicks "Add Bus/Event"
        ↓
[Image Upload Service]
        ↓
Upload to Supabase Storage
  - Bucket: "buses" or "events"
  - Folder: "buses/{timestamp}_{filename}" or "events/{timestamp}_{filename}"
        ↓
Get public URL from Supabase Storage
        ↓
Save to Database
  - Bus table: image column = public URL
  - Event table: image column = public URL
        ↓
Home Screen fetches from Database
        ↓
[Bus Card/Event Card Widget]
        ↓
Display image using NetworkImage(imageUrl)
```

---

## 🔄 Step-by-Step Code Flow

### Step 1: Admin Selects Image

**File:** `lib/screens/add_event_screen.dart` (lines 135-144)

```dart
ImagePickerWidget(
  label: 'Event Image',
  onImageSelected: (XFile? image) {
    setState(() => _selectedImage = image);  // Stores selected image
    if (image != null) _uploadedImageUrl = null;
  },
),
```

**What happens:**
- `ImagePickerWidget` opens camera/gallery
- User selects image
- Image stored in `_selectedImage` (XFile object)
- Image preview shows in UI

---

### Step 2: Upload Image to Supabase Storage

**File:** `lib/screens/add_event_screen.dart` (lines 83-92)

```dart
Future<void> _addEvent() async {
  // ... validation ...
  
  String imageUrl = _uploadedImageUrl ?? '';
  if (_selectedImage != null && _uploadedImageUrl == null) {
    setState(() => _isUploadingImage = true);
    
    // UPLOAD IMAGE HERE
    imageUrl = await _imageUploadService.uploadImage(
      imageFile: File(_selectedImage!.path),    // Convert XFile to File
      bucket: 'events',                          // Storage bucket name
      folderPath: 'events',                      // Folder in bucket
    );
    
    setState(() => _isUploadingImage = false);
  }
  // ... rest of code ...
}
```

---

### Step 3: ImageUploadService Handles Upload

**File:** `lib/services/image_upload_service.dart` (lines 28-47)

```dart
Future<String> uploadImage({
  required File imageFile,
  required String bucket,
  required String folderPath,
}) async {
  try {
    // Create unique filename with timestamp
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
    final filePath = '$folderPath/$fileName';
    
    // Upload to Supabase Storage
    await _supabase.storage.from(bucket).upload(
      filePath,
      imageFile,
    );
    
    // Get public URL
    final publicUrl = _supabase.storage.from(bucket).getPublicUrl(filePath);
    
    return publicUrl;  // Returns: https://ukbqykfzookpmsfzyphf.supabase.co/storage/v1/object/public/events/events/1699950000000_event.jpg
  } catch (e) {
    throw Exception('Error uploading image: $e');
  }
}
```

**Key Points:**
- Converts XFile to File using `File(_selectedImage!.path)`
- Uploads to Supabase Storage bucket
- **Returns public URL** (not just the filename!)
- URL format: `https://[project].supabase.co/storage/v1/object/public/[bucket]/[path]`

---

### Step 4: Save URL to Database

**File:** `lib/screens/add_event_screen.dart` (lines 93-105)

```dart
await _adminService.addEvent(
  eventName: _eventNameController.text.trim(),
  eventType: _selectedType,
  location: _locationController.text.trim(),
  venue: _venueController.text.trim(),
  date: _dateController.text.trim(),
  time: _timeController.text.trim(),
  description: _descriptionController.text.trim(),
  price: double.tryParse(_priceController.text.trim()) ?? 0.0,
  availableTickets: int.tryParse(_ticketsController.text.trim()) ?? 0,
  image: imageUrl,  // <-- PUBLIC URL SAVED HERE
);
```

---

### Step 5: Database Stores URL

**File:** `lib/services/admin_service.dart` (lines 40-60)

```dart
Future<void> addEvent({
  required String eventName,
  required String eventType,
  required String location,
  required String venue,
  required String date,
  required String time,
  required String description,
  required double price,
  required int availableTickets,
  required String image,  // <-- PUBLIC URL
}) async {
  try {
    await _supabase.from('events').insert({
      'event_name': eventName,
      'event_type': eventType,
      'location': location,
      'venue': venue,
      'date': date,
      'time': time,
      'description': description,
      'price': price,
      'available_tickets': availableTickets,
      'image': image,  // <-- STORED IN DATABASE
      'created_at': DateTime.now().toIso8601String(),
    });
  } catch (e) {
    throw Exception('Error adding event: $e');
  }
}
```

**Database Record Example:**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "event_name": "Avatar 3D",
  "event_type": "Cinema",
  "location": "Dar es Salaam",
  "venue": "Cinemax Downtown",
  "date": "2025-12-25",
  "time": "07:00 PM",
  "description": "Experience Avatar in 3D",
  "price": 15000,
  "available_tickets": 150,
  "image": "https://ukbqykfzookpmsfzyphf.supabase.co/storage/v1/object/public/events/events/1699950000000_avatar.jpg",
  "created_at": "2025-11-12T10:30:00.000Z"
}
```

---

### Step 6: Home Screen Fetches Data

**File:** `lib/screens/home_screen.dart` (lines 23-27)

```dart
@override
void initState() {
  super.initState();
  _busesFuture = _bookingService.getAllBuses();
  _eventsFuture = _bookingService.getAllEvents();
}
```

**File:** `lib/services/booking_service.dart` (hypothetical)

```dart
Future<List<Event>> getAllEvents() async {
  try {
    final response = await _supabase
        .from('events')
        .select()
        .limit(100);
    
    return (response as List)
        .map((event) => Event.fromJson(event))
        .toList();
  } catch (e) {
    throw Exception('Error fetching events: $e');
  }
}
```

**Data Retrieved:**
- Includes `image` field with public URL from database
- Example: `image: "https://...supabase.co/storage/v1/object/public/events/events/1699950000000_avatar.jpg"`

---

### Step 7: Display Image in Card

**File:** `lib/widgets/bus_card.dart` (lines 35-42)

```dart
Container(
  height: 150,
  width: double.infinity,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    image: DecorationImage(
      fit: BoxFit.cover,
      image: AssetImage(bus.image.isNotEmpty 
        ? bus.image                              // <-- USE DATABASE URL
        : 'assets/images/im2.jpg'),              // <-- FALLBACK
    ),
  ),
),
```

⚠️ **ISSUE FOUND:** Currently using `AssetImage` which only works for local files!

---

## 🐛 Current Bug & Fix

### The Problem

```dart
// ❌ WRONG - AssetImage only works for local assets
image: AssetImage(bus.image.isNotEmpty ? bus.image : 'assets/images/im2.jpg')
```

`bus.image` contains a **Supabase public URL** (e.g., `https://...supabase.co/storage/...`), but `AssetImage` only works with local file paths!

### The Solution

Change `AssetImage` to `NetworkImage`:

```dart
// ✅ CORRECT - NetworkImage loads from URL
image: NetworkImage(bus.image.isNotEmpty 
  ? bus.image                              // Supabase URL
  : 'https://via.placeholder.com/300x150'), // Network placeholder
```

---

## 📝 Fixed Code for bus_card.dart

**File:** `lib/widgets/bus_card.dart`

Replace lines 35-42 with:

```dart
Container(
  height: 150,
  width: double.infinity,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    image: DecorationImage(
      fit: BoxFit.cover,
      image: bus.image.isNotEmpty
          ? NetworkImage(bus.image)  // Load from Supabase URL
          : const AssetImage('assets/images/im2.jpg'),  // Local fallback
    ),
  ),
),
```

---

## 🔗 Complete URL Example

When you upload an image to Supabase:

```
File uploaded to: events/events/1699950000000_avatar.jpg
Public URL: https://ukbqykfzookpmsfzyphf.supabase.co/storage/v1/object/public/events/events/1699950000000_avatar.jpg

Stored in database.events.image column as:
"https://ukbqykfzookpmsfzyphf.supabase.co/storage/v1/object/public/events/events/1699950000000_avatar.jpg"

Retrieved by home_screen.dart and passed to bus_card.dart
Displayed using NetworkImage(imageUrl)
```

---

## 📊 Data Types Reference

| Component | Type | Example |
|-----------|------|---------|
| Selected Image (UI) | `XFile` | `XFile(/tmp/IMG_1234.jpg)` |
| File for Upload | `File` | `File('/tmp/IMG_1234.jpg')` |
| Public URL (Supabase) | `String` | `https://...supabase.co/storage/...` |
| Database Column | `String` | Stores the public URL |
| Model Field | `String` | `bus.image` = public URL |
| Image Widget | `NetworkImage` | `NetworkImage(bus.image)` |

---

## 🎨 Complete Image Display Flow

```
Supabase Storage
├── Bucket: "buses"
│   └── Folder: "buses/"
│       └── 1699950000000_bus1.jpg (public URL: https://...jpg)
└── Bucket: "events"
    └── Folder: "events/"
        └── 1699950000001_avatar.jpg (public URL: https://...jpg)

         ↓

Supabase Database
├── buses table
│   └── image: "https://...jpg" (public URL)
└── events table
    └── image: "https://...jpg" (public URL)

         ↓

Flutter App
├── booking_service.dart fetches from database
├── models receive image URLs
├── home_screen.dart displays in FutureBuilder
└── bus_card.dart / event_card.dart renders with NetworkImage(url)
```

---

## ✅ Quick Checklist

- ✅ Image picker captures image (XFile)
- ✅ ImageUploadService uploads to Supabase Storage
- ✅ Returns public URL
- ✅ Admin saves URL to database
- ✅ Home screen fetches URL from database
- ✅ Bus card uses NetworkImage to display from URL
- ⚠️ **Fix: Change AssetImage to NetworkImage in bus_card.dart**

---

## 🚀 Summary

Your image upload system works perfectly! Images are:
1. **Uploaded** to Supabase Storage (secure, scalable)
2. **Referenced** in database via public URL (efficient)
3. **Retrieved** from database with FutureBuilder (real-time)
4. **Displayed** using NetworkImage (just need the fix above!)

The only issue is that `bus_card.dart` uses `AssetImage` instead of `NetworkImage`. This needs to be fixed to display images from Supabase Storage URLs.

