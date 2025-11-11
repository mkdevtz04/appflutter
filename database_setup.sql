-- Create buses table
CREATE TABLE IF NOT EXISTS buses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  bus_name VARCHAR(255) NOT NULL,
  bus_company VARCHAR(255) NOT NULL,
  departure VARCHAR(255) NOT NULL,
  arrival VARCHAR(255) NOT NULL,
  departure_time VARCHAR(20) NOT NULL,
  arrival_time VARCHAR(20) NOT NULL,
  route VARCHAR(255) NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  available_seats INT NOT NULL,
  image TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Create events table
CREATE TABLE IF NOT EXISTS events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  event_name VARCHAR(255) NOT NULL,
  event_type VARCHAR(50) NOT NULL,
  location VARCHAR(255) NOT NULL,
  venue VARCHAR(255) NOT NULL,
  date VARCHAR(20) NOT NULL,
  time VARCHAR(20) NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL,
  available_tickets INT NOT NULL,
  image TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Create user_roles table for admin management
CREATE TABLE IF NOT EXISTS user_roles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  role VARCHAR NOT NULL DEFAULT 'user', -- 'user', 'admin', 'moderator'
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Create bookings table
CREATE TABLE IF NOT EXISTS bookings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  booking_type VARCHAR(50) NOT NULL,
  bus_id UUID REFERENCES buses(id),
  event_id UUID REFERENCES events(id),
  quantity INT NOT NULL,
  total_price DECIMAL(10, 2) NOT NULL,
  status VARCHAR(50) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Create indexes for better query performance
CREATE INDEX idx_buses_departure_arrival ON buses(departure, arrival);
CREATE INDEX idx_events_type ON events(event_type);
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_bus_id ON bookings(bus_id);
CREATE INDEX idx_bookings_event_id ON bookings(event_id);

-- Insert sample buses for testing
INSERT INTO buses (bus_name, bus_company, departure, arrival, departure_time, arrival_time, route, price, available_seats, image)
VALUES
  ('Dar Express 1', 'Dar Express Transport', 'Dar es Salaam', 'Dodoma', '08:00 AM', '02:00 PM', 'DAR-DDM', 25000, 45, 'assets/images/im2.jpg'),
  ('Coast Tours 1', 'Coast Tours', 'Dar es Salaam', 'Mbeya', '10:00 AM', '06:00 PM', 'DAR-MBY', 35000, 52, 'assets/images/im2.jpg'),
  ('Premium Coach 1', 'Premium Coach Lines', 'Dodoma', 'Dar es Salaam', '07:00 AM', '01:00 PM', 'DDM-DAR', 28000, 40, 'assets/images/im2.jpg'),
  ('Northern Routes 1', 'Northern Routes Ltd', 'Arusha', 'Dar es Salaam', '06:00 AM', '12:00 PM', 'ARU-DAR', 30000, 48, 'assets/images/im2.jpg'),
  ('Safari Bus 1', 'Safari Bus Company', 'Mbeya', 'Dar es Salaam', '09:00 AM', '05:00 PM', 'MBY-DAR', 35000, 50, 'assets/images/im2.jpg');

-- Insert sample events for testing
INSERT INTO events (event_name, event_type, location, venue, date, time, description, price, available_tickets, image)
VALUES
  ('Avatar 3D', 'Cinema', 'Dar es Salaam', 'Cinemax Downtown', '2025-11-15', '07:00 PM', 'Experience the latest Avatar movie in stunning 3D format', 15000, 150, 'assets/images/im3.jpg'),
  ('Local Jazz Night', 'Club', 'Dar es Salaam', 'Blue Roof Lounge', '2025-11-16', '09:00 PM', 'Live jazz performance with local artists', 25000, 100, 'assets/images/im3.jpg'),
  ('Rayvanny Concert', 'Concert', 'Dar es Salaam', 'National Stadium', '2025-11-20', '06:00 PM', 'Live concert featuring Rayvanny and special guests', 50000, 5000, 'assets/images/im3.jpg'),
  ('Comedy Night', 'Club', 'Dar es Salaam', 'The Comedy Club', '2025-11-18', '08:00 PM', 'Stand-up comedy night with top Tanzanian comedians', 20000, 80, 'assets/images/im3.jpg'),
  ('Oppenheimer Movie', 'Cinema', 'Dar es Salaam', 'Cinemax Downtown', '2025-11-17', '06:00 PM', 'The acclaimed Oppenheimer film - now showing', 12000, 120, 'assets/images/im3.jpg');
