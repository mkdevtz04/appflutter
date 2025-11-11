# 🚀 Quick Start Guide - Tanzania Booking App

## 5-Minute Setup

### Step 1: Setup Database (2 minutes)
```
1. Go to https://supabase.com and open your project
2. Click SQL Editor
3. Copy all content from: database_setup.sql
4. Paste it into the SQL editor
5. Click "Run"
6. Done! Tables and sample data created
```

### Step 2: Create Admin Account (1 minute)
```
1. Run the app: flutter run
2. Click "Sign up"
3. Email: admin@ticketbooking.tz
4. Password: (any password)
5. Confirm password
6. Click "Register"
```

### Step 3: Verify Setup (2 minutes)
```
1. Login as admin
2. Go to Profile screen
3. You should see "Admin Panel" section
4. Click "Add Bus" - form should open
5. Click "Add Event" - form should open
```

## 🧪 Quick Test

### Test Booking Flow:
```
1. Logout from admin
2. Create new account (different email)
3. Login as regular user
4. Home screen shows buses/events
5. Click "View all" → "Bus List"
6. Click a bus → "Book Now"
7. Select seats
8. Click "Confirm Booking"
9. Bottom nav → Bookings
10. See your booking!
```

## 📱 App Structure

```
HOME SCREEN
├── Buses preview + "View All"
├── Events preview + "View All"
└── Bottom Nav

BOTTOM NAVIGATION
├── Home
├── Search
├── My Bookings
└── Profile (Admin Panel here)
```

## 🎯 3 Key Flows

### 1️⃣ Book a Bus
```
Home → View all Buses → Click Bus → Book Now 
→ Select Seats → Confirm → See in My Bookings
```

### 2️⃣ Book an Event
```
Home → View all Events → Click Event → Book Now
→ Select Tickets → Confirm → See in My Bookings
```

### 3️⃣ Add Content (Admin)
```
Profile → Admin Panel → Add Bus/Event 
→ Fill Form → Submit → Data appears in lists
```

## 🆘 Common Issues

| Issue | Solution |
|-------|----------|
| "Admin Panel not showing" | Check you're using admin@ticketbooking.tz email |
| "No buses/events showing" | Run database_setup.sql in Supabase |
| "App won't run" | Run `flutter pub get` first |
| "Booking failed" | Check Supabase credentials in .env file |
| "Login fails" | Verify Supabase auth is enabled |

## 📝 Add First Bus/Event

### Via App (Easy):
```
1. Login as admin
2. Profile → Add Bus
3. Fill form (use assets/images/im2.jpg for image)
4. Click "Add Bus"
5. Go to Bus List - should appear!
```

### Via Supabase (Alternative):
```
1. Open Supabase Dashboard
2. Tables → buses
3. Click Insert
4. Fill form
5. Save
```

## 🔑 Default Credentials

**Admin Emails:**
- admin@ticketbooking.tz
- admin@example.com

**Sample Data (Already in DB):**
- 5 buses (Dar → various cities)
- 5 events (Cinema, concerts, clubs in Dar)

## ⚡ What Works Right Now

✅ Sign up / Login
✅ Browse buses with route info
✅ Browse events by type
✅ Book buses (seat selection)
✅ Book events (ticket selection)
✅ View my bookings
✅ Cancel bookings
✅ Admin add bus/event
✅ Logout

## 🚫 Not Yet Implemented

- Payment processing
- Email notifications
- QR code tickets
- Reviews/ratings
- Search filters
- Map view
- Multiple languages

## 📖 Full Docs

For more details, read:
- **Setup**: ADMIN_SETUP.md
- **Features**: IMPLEMENTATION_SUMMARY.md
- **Screens**: USER_FLOW.md
- **All Steps**: SETUP_CHECKLIST.md

## 🎯 Next Steps

1. ✅ Run database_setup.sql
2. ✅ Create admin account
3. ✅ Test booking flow
4. ✅ Add your own buses/events
5. ✅ Customize colors/text
6. ✅ Build for production

## 💡 Pro Tips

- Use `assets/images/im2.jpg` for bus images
- Use `assets/images/im3.jpg` for event images
- Dates format: YYYY-MM-DD
- Times format: HH:MM AM/PM
- Price in Tanzanian Shillings (TZS)

## 🎉 You're Ready!

Run the app now:
```bash
flutter run
```

Then follow the 3 flows above to test everything!

---

**Need help?** Check ADMIN_SETUP.md or USER_FLOW.md
