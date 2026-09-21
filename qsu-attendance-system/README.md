# QSU Practice Attendance Monitoring System

A deployable attendance web app for practice sessions, with Supabase authentication/database, admin/user roles, QR check-in, scheduling, dashboard, and CSV reports.

## Stack
- Next.js + React + TypeScript
- Supabase Auth + PostgreSQL + Row Level Security
- QR generation (`qrcode`) and browser scanning (`html5-qrcode`)
- Vercel deployment

## 1. Create the Supabase project
1. Create a project at Supabase.
2. In **SQL Editor**, run `supabase/schema.sql`.
3. In **Authentication > Providers**, keep Email enabled.
4. Create the first admin account under **Authentication > Users** or register through a temporary sign-up flow.
5. Add its profile row using `supabase/seed.sql`, or run the admin SQL comment in `schema.sql` after replacing `YOUR_ADMIN_EMAIL`.

Important: Supabase Auth creates the login identity; `public.profiles` stores the role and performer details.

## 2. Configure locally
Copy `.env.example` to `.env.local` and set:
- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`

Then:

```bash
npm install
npm run dev
```

Open `http://localhost:3000`.

## 3. User accounts
For security, user creation is intentionally controlled through Supabase Authentication. After creating a user, add a matching profile row:

```sql
insert into public.profiles (id, full_name, email, role, organization)
values ('USER_UUID','Performer Name','performer@example.com','user','Mannayow Dance Company');
```

Use `role='admin'` only for authorized administrators.

## 4. QR workflow
1. Admin signs in.
2. Open **Practice Schedule**.
3. Create a practice session.
4. Click **Show QR** and display/print it.
5. A logged-in performer scans the QR with their phone, or opens **QR Attendance > Open QR scanner**.
6. The app validates the session ID + QR token and creates one attendance record per user/session.

## 5. Deploy to Vercel
1. Push this project to GitHub.
2. Import the repository into Vercel.
3. Add the two `NEXT_PUBLIC_*` environment variables.
4. Deploy.
5. In Supabase Authentication > URL Configuration, set **Site URL** to your Vercel URL and add it to allowed redirect URLs if you later add email recovery/OAuth.

No private Supabase service-role key is used in the browser.

## Production notes
- Enable email confirmation if required by your organization.
- Keep the Supabase anon key public; never expose the service-role key in frontend code.
- For attendance integrity, consider adding an admin-only correction screen, device/time rules, and an audit log before production use.
- Camera scanning requires HTTPS in production (Vercel provides this).
