-- SmartLib AI - Complete Database Schema
-- Run this in your Supabase SQL editor

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- USERS TABLE
-- ============================================
CREATE TABLE users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL UNIQUE,
    full_name TEXT,
    usn TEXT UNIQUE,
    department TEXT,
    semester INTEGER,
    profile_image TEXT,
    role TEXT DEFAULT 'student' CHECK (role IN ('student', 'librarian', 'admin')),
    is_email_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- CATEGORIES TABLE
-- ============================================
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    icon TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- BOOKS TABLE
-- ============================================
CREATE TABLE books (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    isbn TEXT UNIQUE,
    description TEXT,
    cover_image TEXT,
    category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    total_copies INTEGER DEFAULT 1 CHECK (total_copies >= 0),
    available_copies INTEGER DEFAULT 1 CHECK (available_copies >= 0),
    rack_location TEXT,
    publisher TEXT,
    publish_year INTEGER,
    tags TEXT[],
    digital_book_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- BOOK COPIES TABLE
-- ============================================
CREATE TABLE book_copies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    book_id UUID REFERENCES books(id) ON DELETE CASCADE,
    copy_number INTEGER NOT NULL,
    status TEXT DEFAULT 'available' CHECK (status IN ('available', 'borrowed', 'maintenance', 'lost')),
    qr_code TEXT UNIQUE,
    barcode TEXT UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(book_id, copy_number)
);

-- ============================================
-- BORROW RECORDS TABLE
-- ============================================
CREATE TABLE borrow_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    book_id UUID REFERENCES books(id) ON DELETE CASCADE,
    copy_id UUID REFERENCES book_copies(id) ON DELETE SET NULL,
    borrow_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    due_date TIMESTAMP WITH TIME ZONE NOT NULL,
    return_date TIMESTAMP WITH TIME ZONE,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'returned', 'overdue', 'lost')),
    fine_amount DECIMAL(10, 2) DEFAULT 0,
    fine_paid BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- RESERVATIONS TABLE
-- ============================================
CREATE TABLE reservations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    book_id UUID REFERENCES books(id) ON DELETE CASCADE,
    reservation_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expiry_date TIMESTAMP WITH TIME ZONE NOT NULL,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'fulfilled', 'expired', 'cancelled')),
    queue_position INTEGER,
    notified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- FINES TABLE
-- ============================================
CREATE TABLE fines (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    borrow_record_id UUID REFERENCES borrow_records(id) ON DELETE CASCADE,
    amount DECIMAL(10, 2) NOT NULL,
    reason TEXT,
    paid BOOLEAN DEFAULT FALSE,
    paid_at TIMESTAMP WITH TIME ZONE,
    payment_method TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- NOTIFICATIONS TABLE
-- ============================================
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    type TEXT CHECK (type IN ('due_reminder', 'reservation', 'fine', 'announcement', 'general')),
    is_read BOOLEAN DEFAULT FALSE,
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- READING HISTORY TABLE
-- ============================================
CREATE TABLE reading_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    book_id UUID REFERENCES books(id) ON DELETE CASCADE,
    pages_read INTEGER DEFAULT 0,
    total_pages INTEGER,
    last_page_read INTEGER,
    reading_time_minutes INTEGER DEFAULT 0,
    completed BOOLEAN DEFAULT FALSE,
    last_read_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- SEATS TABLE
-- ============================================
CREATE TABLE seats (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    seat_number TEXT NOT NULL UNIQUE,
    section TEXT,
    floor INTEGER,
    status TEXT DEFAULT 'available' CHECK (status IN ('available', 'occupied', 'maintenance')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- SEAT BOOKINGS TABLE
-- ============================================
CREATE TABLE seat_bookings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    seat_id UUID REFERENCES seats(id) ON DELETE CASCADE,
    booking_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'completed', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- WISHLIST TABLE
-- ============================================
CREATE TABLE wishlist (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    book_id UUID REFERENCES books(id) ON DELETE CASCADE,
    added_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, book_id)
);

-- ============================================
-- ANNOUNCEMENTS TABLE
-- ============================================
CREATE TABLE announcements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    priority TEXT DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
    is_active BOOLEAN DEFAULT TRUE,
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE
);

-- ============================================
-- ANALYTICS LOGS TABLE
-- ============================================
CREATE TABLE analytics_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_type TEXT NOT NULL,
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- INDEXES
-- ============================================
CREATE INDEX idx_books_category ON books(category_id);
CREATE INDEX idx_books_title ON books(title);
CREATE INDEX idx_books_author ON books(author);
CREATE INDEX idx_borrow_records_user ON borrow_records(user_id);
CREATE INDEX idx_borrow_records_book ON borrow_records(book_id);
CREATE INDEX idx_borrow_records_status ON borrow_records(status);
CREATE INDEX idx_reservations_user ON reservations(user_id);
CREATE INDEX idx_reservations_book ON reservations(book_id);
CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_seat_bookings_user ON seat_bookings(user_id);
CREATE INDEX idx_seat_bookings_date ON seat_bookings(booking_date);

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE books ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE book_copies ENABLE ROW LEVEL SECURITY;
ALTER TABLE borrow_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservations ENABLE ROW LEVEL SECURITY;
ALTER TABLE fines ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE reading_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE seats ENABLE ROW LEVEL SECURITY;
ALTER TABLE seat_bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE wishlist ENABLE ROW LEVEL SECURITY;
ALTER TABLE announcements ENABLE ROW LEVEL SECURITY;
ALTER TABLE analytics_logs ENABLE ROW LEVEL SECURITY;

-- Users policies
CREATE POLICY "Users can view their own profile"
    ON users FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile"
    ON users FOR UPDATE
    USING (auth.uid() = id);

-- Books policies (public read)
CREATE POLICY "Anyone can view books"
    ON books FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Only admins can insert books"
    ON books FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM users
            WHERE users.id = auth.uid()
            AND users.role IN ('admin', 'librarian')
        )
    );

-- Categories policies
CREATE POLICY "Anyone can view categories"
    ON categories FOR SELECT
    TO authenticated
    USING (true);

-- Borrow records policies
CREATE POLICY "Users can view their own borrow records"
    ON borrow_records FOR SELECT
    TO authenticated
    USING (user_id = auth.uid() OR 
           EXISTS (SELECT 1 FROM users WHERE users.id = auth.uid() AND users.role IN ('admin', 'librarian')));

-- Reservations policies
CREATE POLICY "Users can view their own reservations"
    ON reservations FOR SELECT
    TO authenticated
    USING (user_id = auth.uid() OR 
           EXISTS (SELECT 1 FROM users WHERE users.id = auth.uid() AND users.role IN ('admin', 'librarian')));

CREATE POLICY "Users can create reservations"
    ON reservations FOR INSERT
    TO authenticated
    WITH CHECK (user_id = auth.uid());

-- Notifications policies
CREATE POLICY "Users can view their own notifications"
    ON notifications FOR SELECT
    TO authenticated
    USING (user_id = auth.uid());

CREATE POLICY "Users can update their own notifications"
    ON notifications FOR UPDATE
    TO authenticated
    USING (user_id = auth.uid());

-- Wishlist policies
CREATE POLICY "Users can manage their wishlist"
    ON wishlist FOR ALL
    TO authenticated
    USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

-- Announcements policies
CREATE POLICY "Anyone can view active announcements"
    ON announcements FOR SELECT
    TO authenticated
    USING (is_active = true);

-- Seat bookings policies
CREATE POLICY "Users can view their own seat bookings"
    ON seat_bookings FOR SELECT
    TO authenticated
    USING (user_id = auth.uid() OR 
           EXISTS (SELECT 1 FROM users WHERE users.id = auth.uid() AND users.role IN ('admin', 'librarian')));

CREATE POLICY "Users can create seat bookings"
    ON seat_bookings FOR INSERT
    TO authenticated
    WITH CHECK (user_id = auth.uid());

-- ============================================
-- FUNCTIONS
-- ============================================

-- Function to update book availability
CREATE OR REPLACE FUNCTION update_book_availability()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' AND NEW.status = 'borrowed' THEN
        UPDATE books 
        SET available_copies = available_copies - 1
        WHERE id = NEW.book_id AND available_copies > 0;
    ELSIF TG_OP = 'UPDATE' AND OLD.status = 'borrowed' AND NEW.status = 'available' THEN
        UPDATE books 
        SET available_copies = available_copies + 1
        WHERE id = NEW.book_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for book availability
CREATE TRIGGER trigger_update_book_availability
AFTER INSERT OR UPDATE ON book_copies
FOR EACH ROW
EXECUTE FUNCTION update_book_availability();

-- Function to calculate fines
CREATE OR REPLACE FUNCTION calculate_fine(borrow_record_id UUID)
RETURNS DECIMAL AS $$
DECLARE
    overdue_days INTEGER;
    daily_fine DECIMAL := 5.00;
    total_fine DECIMAL := 0;
BEGIN
    SELECT GREATEST(0, EXTRACT(DAY FROM (CURRENT_DATE - due_date))::INTEGER)
    INTO overdue_days
    FROM borrow_records
    WHERE id = borrow_record_id AND return_date IS NULL;
    
    total_fine := overdue_days * daily_fine;
    RETURN total_fine;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- STORAGE BUCKETS (Run in Supabase Dashboard)
-- ============================================
-- Create storage buckets from Supabase dashboard:
-- 1. book-covers (public)
-- 2. profile-images (public)
-- 3. digital-books (private)

-- ============================================
-- SEED DATA
-- ============================================

-- Insert sample categories
INSERT INTO categories (name, description) VALUES
('Fiction', 'Fictional literature and novels'),
('Non-Fiction', 'Factual books and biographies'),
('Science', 'Scientific books and research'),
('Technology', 'Technology and programming books'),
('Mathematics', 'Mathematics and statistics'),
('History', 'Historical books and references'),
('Literature', 'Classic and modern literature'),
('Engineering', 'Engineering textbooks and references');

-- Insert sample seats
INSERT INTO seats (seat_number, section, floor) VALUES
('A-001', 'Section A', 1),
('A-002', 'Section A', 1),
('A-003', 'Section A', 1),
('B-001', 'Section B', 1),
('B-002', 'Section B', 1),
('C-001', 'Section C', 2),
('C-002', 'Section C', 2);

-- Sample announcement
INSERT INTO announcements (title, message, priority) VALUES
('Welcome to SmartLib AI', 'Your smart library management system is now live!', 'high');
