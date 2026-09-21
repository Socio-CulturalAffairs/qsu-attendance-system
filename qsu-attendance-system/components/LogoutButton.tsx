'use client'
import { useRouter } from 'next/navigation'
import { supabase } from '@/lib/supabase'
export function LogoutButton(){const router=useRouter();return <button className="btn secondary" onClick={async()=>{await supabase.auth.signOut();router.push('/login')}}>Logout</button>}
