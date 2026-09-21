'use client'
import { useEffect,useState } from 'react'
import { useRouter } from 'next/navigation'
import { supabase } from '@/lib/supabase'
import { Profile } from '@/lib/types'
export function AuthGuard({children,adminOnly=false}:{children:React.ReactNode;adminOnly?:boolean}){const router=useRouter();const [ok,setOk]=useState(false);useEffect(()=>{(async()=>{const {data:{user}}=await supabase.auth.getUser();if(!user){router.replace('/login');return}const {data:p}=await supabase.from('profiles').select('*').eq('id',user.id).single();if(adminOnly&&p?.role!=='admin'){router.replace('/dashboard');return}setOk(true)})()},[router,adminOnly]);return ok?<>{children}</>:<main className="container"><div className="card">Checking access…</div></main>}
export async function getProfile():Promise<Profile|null>{const {data:{user}}=await supabase.auth.getUser();if(!user)return null;const {data}=await supabase.from('profiles').select('*').eq('id',user.id).single();return data}
