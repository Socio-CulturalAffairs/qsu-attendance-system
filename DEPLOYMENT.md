# Deployment Checklist

## Supabase
- [ ] Create project
- [ ] Run `supabase/schema.sql`
- [ ] Confirm Email provider is enabled
- [ ] Create one administrator account
- [ ] Run the admin promotion SQL in `schema.sql` with the administrator email
- [ ] Confirm `profiles.role` is `admin`

## Vercel
- [ ] Push repository to GitHub
- [ ] Import into Vercel
- [ ] Add `NEXT_PUBLIC_SUPABASE_URL`
- [ ] Add `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- [ ] Deploy
- [ ] Copy Vercel URL

## Supabase Auth URL configuration
Set the Vercel URL as the Site URL. Add the Vercel URL to Redirect URLs when using confirmation/recovery flows.

## First test
1. Register a user.
2. Confirm the user appears in `profiles` with role `user`.
3. Sign in as admin.
4. Create a practice.
5. Show the QR.
6. Scan with the user phone.
7. Verify the attendance row.
8. Open Reports and export CSV.
