-- =====================================================================
-- iDRONE PLATFORM - POSTGRESQL SCHEMA & ROW LEVEL SECURITY (RLS) POLICIES
-- =====================================================================

-- 1. ENUMS
CREATE TYPE user_role AS ENUM ('cliente', 'operador', 'admin_operaciones', 'super_admin');
CREATE TYPE booking_status AS ENUM ('draft', 'pending_payment', 'confirmed', 'scheduled', 'in_progress', 'completed', 'cancelled', 'rescheduled');
CREATE TYPE drone_status AS ENUM ('disponible', 'en_servicio', 'mantenimiento', 'fuera_de_servicio');

-- 2. PROFILES TABLE
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    phone TEXT,
    role user_role NOT NULL DEFAULT 'cliente',
    avatar_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 3. PARCELS TABLE
CREATE TABLE IF NOT EXISTS public.parcels (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    crop_type TEXT NOT NULL,
    area_hectares NUMERIC(10,2) NOT NULL,
    perimeter_meters NUMERIC(10,2) DEFAULT 0.0,
    location_name TEXT NOT NULL,
    points JSONB NOT NULL DEFAULT '[]'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 4. SERVICES TABLE
CREATE TABLE IF NOT EXISTS public.services (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    base_price_per_hectare NUMERIC(10,2) NOT NULL,
    icon_name TEXT DEFAULT 'agriculture',
    image_url TEXT,
    estimated_duration TEXT DEFAULT '2.5 hrs/100ha',
    is_available BOOLEAN DEFAULT TRUE
);

-- 5. DRONES TABLE
CREATE TABLE IF NOT EXISTS public.drones (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    identifier TEXT NOT NULL UNIQUE,
    model TEXT NOT NULL,
    status drone_status DEFAULT 'disponible',
    flight_hours NUMERIC(10,1) DEFAULT 0.0,
    current_operator_id UUID REFERENCES public.profiles(id)
);

-- 6. BOOKINGS TABLE
CREATE TABLE IF NOT EXISTS public.bookings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    service_id UUID NOT NULL REFERENCES public.services(id),
    parcel_id UUID NOT NULL REFERENCES public.parcels(id) ON DELETE CASCADE,
    crop_type TEXT NOT NULL,
    area_hectares NUMERIC(10,2) NOT NULL,
    scheduled_date TIMESTAMPTZ NOT NULL,
    subtotal NUMERIC(10,2) NOT NULL,
    discount NUMERIC(10,2) DEFAULT 0.0,
    total NUMERIC(10,2) NOT NULL,
    paid_amount NUMERIC(10,2) DEFAULT 0.0,
    status booking_status NOT NULL DEFAULT 'draft',
    operator_id UUID REFERENCES public.profiles(id),
    drone_id UUID REFERENCES public.drones(id),
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 7. NOTIFICATIONS TABLE
CREATE TABLE IF NOT EXISTS public.notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 8. AUDIT LOGS TABLE
CREATE TABLE IF NOT EXISTS public.audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_name TEXT NOT NULL,
    action TEXT NOT NULL,
    entity TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =====================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =====================================================================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.parcels ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.services ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.drones ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;

-- CLIENTS: Access own profiles, parcels, bookings, notifications
CREATE POLICY "Clientes view own profile" ON public.profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Clientes manage own parcels" ON public.parcels FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Clientes manage own bookings" ON public.bookings FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Clientes view own notifications" ON public.notifications FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Anyone view active services" ON public.services FOR SELECT USING (is_available = TRUE);

-- OPERATORS: View assigned bookings & update assigned telemetry/status
CREATE POLICY "Operators view assigned bookings" ON public.bookings FOR SELECT USING (auth.uid() = operator_id OR user_id = auth.uid());
CREATE POLICY "Operators update assigned bookings" ON public.bookings FOR UPDATE USING (auth.uid() = operator_id);

-- ADMINS: Access and manage all entities
CREATE POLICY "Admins full access profiles" ON public.profiles FOR ALL USING (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('admin_operaciones', 'super_admin')));
CREATE POLICY "Admins full access parcels" ON public.parcels FOR ALL USING (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('admin_operaciones', 'super_admin')));
CREATE POLICY "Admins full access bookings" ON public.bookings FOR ALL USING (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('admin_operaciones', 'super_admin')));
CREATE POLICY "Admins full access drones" ON public.drones FOR ALL USING (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('admin_operaciones', 'super_admin')));
CREATE POLICY "Admins full access audit" ON public.audit_logs FOR ALL USING (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('admin_operaciones', 'super_admin')));
