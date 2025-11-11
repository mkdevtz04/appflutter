# Tanzania Booking App - User Flow & Quick Reference

## 🎯 User Journey Maps

### Regular User Flow
```
START
  ↓
[Welcome] → No account? → [Register] → Create account
  ↓
[Login] → Enter email/password
  ↓
[Home Screen]
  ├─→ "View all buses" → [Bus List] → Select bus → [Bus Details] → Book → [Confirmation]
  ├─→ "View all events" → [Event List] → Filter type → Select event → [Event Details] → Book
  ├─→ Bottom Nav: Search
  ├─→ Bottom Nav: My Bookings → [Booking History] → View/Cancel
  └─→ Bottom Nav: Profile → View user info → Logout
```

### Admin User Flow
```
[Regular User Flow] +
  ↓
[Profile Screen] → [Admin Panel]
  ├─→ "Add Bus" → [Bus Form] → Fill details → Submit → [Confirmation]
  └─→ "Add Event" → [Event Form] → Fill details → Submit → [Confirmation]
```

## 📱 Screen Navigation

```
                    [Auth Wrapper]
                          ↓
                    ┌─────┴─────┐
                    ↓           ↓
            [Login]         [Register]
                ↓               ↓
                └───────┬───────┘
                        ↓
                  [Bottom Bar]
                 /      |       \      \
                /       |        \      \
            [Home]  [Search] [Bookings] [Profile]
             / \
            /   \
      [Bus List] [Event List]
       /    \        /    \
   [Bus]  [Cancel]  [Event] [Cancel]
  Details            Details
    |                 |
    └─────┬───────────┘
          ↓
    [Confirm Booking]
```

## 🔑 Key Screens

### 1. Home Screen
- Welcome message
- Search bar
- "Available Buses" section with preview
- "Events Near You" section with preview
- Quick links to full listings

### 2. Bus List Screen
- Shows all available buses
- Display: Company, route, times, price, seats
- Search/filter buses
- Click bus card → Bus Details Screen

### 3. Bus Details Screen
- Full bus information
- Seat quantity selector (+/- buttons)
- Real-time price calculation
- "Confirm Booking" button
- Success/error messages

### 4. Event List Screen
- Filter by type (All/Cinema/Club/Concert/Sports/Theater)
- Show: Event name, venue, date/time, price, tickets left
- Click event card → Event Details Screen

### 5. Event Details Screen
- Event image and details
- Venue and location info
- Event description
- Ticket quantity selector
- Real-time price calculation
- "Confirm Booking" button

### 6. My Bookings Screen (Ticket Screen)
- List all user bookings
- Booking ID, type, quantity, total price
- Status badge (Pending/Confirmed/Cancelled)
- Cancel button for pending bookings
- Empty state if no bookings

### 7. Profile Screen
- User email
- User ID
- Join date
- **[ADMIN ONLY]** Admin Panel section
- Edit Profile button
- Notifications button
- Help & Support button
- Logout button

### 8. Add Bus Screen (Admin Only)
- Form fields:
  - Bus Name, Company
  - Departure/Arrival cities
  - Times (departure & arrival)
  - Route
  - Price (TZS)
  - Available seats
  - Image URL
- Submit button

### 9. Add Event Screen (Admin Only)
- Form fields:
  - Event Name
  - Event Type dropdown
  - Location (city)
  - Venue Name
  - Date (YYYY-MM-DD)
  - Time
  - Description (multi-line)
  - Price (TZS)
  - Available tickets
  - Image URL
- Submit button

## 💾 Data Flow

### Booking Creation Flow
```
User Input (Bus/Event Details)
         ↓
[Booking Screen] 
    - Select quantity
    - Calculate total
         ↓
User clicks "Confirm Booking"
         ↓
BookingService.createBusBooking() or createEventBooking()
         ↓
INSERT into Supabase.bookings table
         ↓
UPDATE available_seats or available_tickets
         ↓
Show success message
         ↓
Navigate back to list
```

### Fetching Data Flow
```
Screen Loads
    ↓
Call BookingService method
(getAllBuses, getAllEvents, etc.)
    ↓
FutureBuilder shows loading spinner
    ↓
Supabase returns data
    ↓
Parse JSON to Dart models
    ↓
Display in ListView/GridView
```

## 🔐 Authentication Flow

```
New User:
  [Register Screen]
    ↓
  Enter email + password
    ↓
  AuthService.signUp()
    ↓
  Supabase creates user
    ↓
  Auto-login + navigate to Home

Existing User:
  [Login Screen]
    ↓
  Enter email + password
    ↓
  AuthService.signIn()
    ↓
  Supabase authenticates
    ↓
  Navigate to Home

Logout:
  [Profile Screen]
    ↓
  Click "Logout"
    ↓
  AuthService.signOut()
    ↓
  Clear session
    ↓
  Navigate to Login
```

## 📊 Database Operations

### Creating Booking
```sql
INSERT INTO bookings (
  user_id,
  booking_type,
  bus_id,    -- OR event_id
  quantity,
  total_price,
  status
) VALUES (...)
```

### Fetching Buses
```sql
SELECT * FROM buses
WHERE departure = ? AND arrival = ?
ORDER BY departure_time
```

### Adding Bus (Admin)
```sql
INSERT INTO buses (
  bus_name, bus_company, departure, arrival,
  departure_time, arrival_time, route,
  price, available_seats, image
) VALUES (...)
```

## 🎨 UI Elements

### Common Components
- **Buttons**: Primary (blue), Secondary (outlined), Danger (red)
- **Forms**: TextFormField with validation
- **Lists**: ListView with BusCard/EventCard
- **Status Badges**: Color-coded (green/orange/red)
- **Quantity Selector**: +/- buttons with count display

### Colors (from AppStyles)
- Primary Color: Blue (bookings/buttons)
- Background: Light gray
- Text: Dark gray
- Accents: Green (success), Red (danger), Orange (warning)

## 🚨 Error Handling

All screens show:
- ✅ Loading spinner while fetching
- ✅ Error message if query fails
- ✅ Empty state if no data
- ✅ SnackBar for user notifications

## ⚡ Key Actions

| Action | Triggered By | Result |
|--------|-------------|--------|
| Browse | User click | Show listings |
| Book | "Confirm" button | Save to DB |
| Cancel | "Cancel" button | Update status |
| Add Bus | Admin form | Insert to DB |
| Add Event | Admin form | Insert to DB |
| Logout | Logout button | Clear session |

---

## 📋 Testing Checklist

- [ ] Sign up new account
- [ ] Login with credentials
- [ ] Browse buses on home
- [ ] Search and filter buses
- [ ] Book a bus
- [ ] View booking in My Bookings
- [ ] Cancel a booking
- [ ] Browse events
- [ ] Filter events by type
- [ ] Book an event
- [ ] View booking in My Bookings
- [ ] Logout
- [ ] Login as admin
- [ ] Add new bus
- [ ] Add new event
- [ ] Verify data appears in listings

---

**Ready to go!** Start with database_setup.sql, then test the app flows above.
