# Tanzania Booking App - Admin Setup Guide

## Setup Instructions

### 1. **Create Admin Account**

Sign up with one of these emails to enable admin features:
- `admin@ticketbooking.tz`
- `admin@example.com`

Or update `lib/services/admin_service.dart` to add your email:

```dart
final adminEmails = ['your-email@example.com'];
```

### 2. **Setup Supabase Database**

#### Option A: Using Supabase Dashboard

1. Go to your Supabase project dashboard
2. Open the SQL Editor
3. Copy the entire content from `database_setup.sql` file
4. Paste it into the SQL Editor
5. Click "Run" to create tables and insert sample data

#### Option B: Manual Setup

1. Create three tables in Supabase:
   - `buses` - for bus routes
   - `events` - for events (cinema, clubs, concerts)
   - `bookings` - for user bookings

2. Add sample data or use the admin panel to add data

### 3. **Features Overview**

#### For Regular Users:
- ✅ Sign up and login with email/password
- ✅ Browse available buses
- ✅ Browse events (Cinema, Club, Concert)
- ✅ Book buses or events
- ✅ View my bookings
- ✅ Cancel pending bookings

#### For Admin Users:
- ✅ All regular user features
- ✅ Add new buses
- ✅ Add new events
- ✅ Admin Panel visible in Profile screen

### 4. **Adding Buses**

**Via Admin Panel:**
1. Log in with admin account
2. Go to Profile → Admin Panel
3. Click "Add Bus"
4. Fill in bus details:
   - Bus Name, Company
   - Departure/Arrival Cities
   - Times (e.g., "08:00 AM")
   - Price, Available Seats
   - Image URL (use: `assets/images/im2.jpg`)

**Via Supabase Dashboard:**
1. Go to Supabase Dashboard
2. Open `buses` table
3. Click "Insert row"
4. Fill in details and save

### 5. **Adding Events**

**Via Admin Panel:**
1. Log in with admin account
2. Go to Profile → Admin Panel
3. Click "Add Event"
4. Fill in event details:
   - Event Name, Type (Cinema/Club/Concert/Sports/Theater)
   - Location (City), Venue
   - Date (YYYY-MM-DD), Time (e.g., "07:00 PM")
   - Description
   - Price, Available Tickets
   - Image URL (use: `assets/images/im3.jpg`)

**Via Supabase Dashboard:**
1. Go to Supabase Dashboard
2. Open `events` table
3. Click "Insert row"
4. Fill in details and save

### 6. **Database Schema**

#### buses table
```
- id (UUID) - Primary key
- bus_name - Name of the bus
- bus_company - Company name
- departure - Departure city
- arrival - Arrival city
- departure_time - Time (e.g., "08:00 AM")
- arrival_time - Time (e.g., "02:00 PM")
- route - Route code
- price - Price in TZS
- available_seats - Number of seats
- image - Image URL
- created_at, updated_at - Timestamps
```

#### events table
```
- id (UUID) - Primary key
- event_name - Name of event
- event_type - Type: Cinema, Club, Concert, Sports, Theater
- location - City location
- venue - Venue name
- date - Date (YYYY-MM-DD)
- time - Time (e.g., "07:00 PM")
- description - Event description
- price - Ticket price in TZS
- available_tickets - Number of tickets
- image - Image URL
- created_at, updated_at - Timestamps
```

#### bookings table
```
- id (UUID) - Primary key
- user_id (UUID) - FK to auth.users
- booking_type - "bus" or "event"
- bus_id (UUID) - FK to buses table
- event_id (UUID) - FK to events table
- quantity - Number of seats/tickets
- total_price - Total price
- status - "pending", "confirmed", "cancelled"
- created_at, updated_at - Timestamps
```

### 7. **Troubleshooting**

**"Admin Panel not showing?"**
- Make sure you're logged in with an admin email
- Check that email is in the admin list in `admin_service.dart`

**"Buses/Events not showing?"**
- Make sure tables are created in Supabase
- Insert sample data using `database_setup.sql`
- Check that RLS (Row Level Security) is not blocking queries

**"Booking failed?"**
- Ensure `bookings` table is created
- Check user is logged in
- Verify foreign keys reference valid bus_id or event_id

### 8. **Sample Data**

The `database_setup.sql` file includes:
- 5 sample buses with different routes in Tanzania
- 5 sample events (movies, concerts, clubs)

Feel free to delete these and add your own data!

### 9. **Next Steps**

- Customize admin emails in `lib/services/admin_service.dart`
- Add more event types in `lib/screens/add_event_screen.dart`
- Implement payment integration
- Add user profile editing
- Add booking history export
- Implement email notifications

---

**Questions?** Check the main README.md or review the code structure in `lib/screens/` and `lib/services/`
