# Admin Login Setup Guide

## Changes Made ✅

### 1. **Updated Auth Service** (`lib/services/auth_service.dart`)
- Added `isUserAdmin()` - Checks if user has admin role in `user_roles` table
- Added `getUserRole()` - Returns user's role
- Added `isCurrentUserAdmin()` - Stream to monitor admin status

### 2. **Updated Login Screen** (`lib/screens/login_screen.dart`)
- Same login page for both users and admins
- Automatic role detection after login
- Proper error handling and loading states
- Password visibility toggle

### 3. **Updated Auth Wrapper** (`lib/screens/auth_wrapper.dart`)
- Simplified to use single login screen
- Automatically detects auth state and routes accordingly

### 4. **Updated Bottom Navigation** (`lib/bottom_bar.dart`)
- Checks if user is admin
- Shows admin icon (red badge) instead of profile icon for admins
- Admin status persists across navigation

### 5. **Updated Profile Screen** (`lib/screens/profile_screen.dart`)
- Shows admin badge for admin users
- Admin panel buttons appear only for admins
- "Add Bus" and "Add Event" buttons for admin management
- Logout functionality

### 6. **Updated Admin Service** (`lib/services/admin_service.dart`)
- Now checks `user_roles` table instead of hardcoded emails
- Uses database for role management

### 7. **Updated Database Schema** (`database_setup.sql`)
- Added `user_roles` table with columns:
  - `id` - Unique identifier
  - `user_id` - Reference to auth user
  - `role` - Can be 'user', 'admin', or 'moderator'
  - `created_at`, `updated_at` - Timestamps

---

## How to Setup Admin Access 🔐

### Step 1: Run SQL in Supabase Dashboard

Go to your Supabase project → SQL Editor and run:

```sql
-- Create user_roles table
CREATE TABLE IF NOT EXISTS user_roles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  role VARCHAR NOT NULL DEFAULT 'user',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Create index for faster lookups
CREATE INDEX idx_user_roles_user_id ON user_roles(user_id);
CREATE INDEX idx_user_roles_role ON user_roles(role);
```

### Step 2: Create User Account

1. Open the app
2. Go to **Register** and create a new account
3. Save the email you used

### Step 3: Make User Admin

1. Go to Supabase Dashboard → **SQL Editor**
2. Find the user's ID from `auth.users` table (copy the UUID)
3. Run this query:

```sql
INSERT INTO user_roles (user_id, role) 
VALUES ('PASTE_USER_ID_HERE', 'admin')
ON CONFLICT (user_id) DO UPDATE SET role = 'admin';
```

Replace `PASTE_USER_ID_HERE` with the actual user ID from auth.users table.

### Step 4: Login as Admin

1. Close and reopen the app
2. Go to **Login**
3. Enter the email and password you created
4. After login, you'll see:
   - Red admin icon in bottom navigation
   - Admin badge in profile
   - Admin panel with "Add Bus" and "Add Event" buttons

---

## Admin Features 🎯

Once logged in as admin, you can:

✅ **Add Buses** - Create new bus listings with details
✅ **Add Events** - Create new event listings 
✅ **Manage Content** - Add pricing, availability, details
✅ **View All** - Same access as regular users to bookings

---

## User Flow Diagram

```
User Registration
      ↓
User Logs In (Same Login Page)
      ↓
System Checks user_roles Table
      ↓
    ┌─────────────────────┐
    │                     │
  Admin?              Regular User?
    │                     │
    ↓                     ↓
Admin Panel          Regular Home
- Add Bus            - Browse Buses
- Add Events         - Book Tickets
- Admin Icon         - View Bookings
```

---

## Database Schema

### user_roles table:
```
id          UUID (PK)
user_id     UUID (FK to auth.users)
role        VARCHAR ('user', 'admin', 'moderator')
created_at  TIMESTAMP
updated_at  TIMESTAMP
```

---

## Testing Checklist ✓

- [ ] Run SQL to create `user_roles` table
- [ ] Register a new user account
- [ ] Get their user ID from Supabase
- [ ] Make them admin via SQL
- [ ] Login with their credentials
- [ ] Verify admin icon appears in bottom nav
- [ ] Verify admin panel shows on profile screen
- [ ] Click "Add Bus" button
- [ ] Click "Add Event" button
- [ ] Logout and verify regular user can still login

---

## Troubleshooting

### "You do not have admin privileges" error
- Check if `user_roles` table exists in Supabase
- Verify you inserted the correct user_id
- Check that role is set to 'admin'

### Admin features not showing
- Restart the app completely
- Check Supabase connection in `.env`
- Verify user_roles table has correct user_id

### Can't login
- Check email/password are correct
- Ensure auth.users table has the user
- Check `.env` has correct Supabase credentials

---

## Next Steps

1. ✅ Setup `user_roles` table (run SQL)
2. ✅ Create admin user (register + set role)
3. ✅ Test admin login (should see admin features)
4. ✅ Add sample buses (use Admin → Add Bus)
5. ✅ Add sample events (use Admin → Add Event)
6. ✅ Test booking as regular user

All changes are complete and ready to deploy! 🚀
