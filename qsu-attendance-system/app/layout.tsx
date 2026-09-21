import './globals.css'
import Link from 'next/link'
import { ReactNode } from 'react'
import { LogoutButton } from '@/components/LogoutButton'
export default function RootLayout({children}:{children:ReactNode}){return <><header className="topbar"><Link href="/" className="brand">QSU Practice Attendance</Link><nav className="nav"><Link href="/dashboard">Dashboard</Link><Link href="/attendance">Attendance</Link><Link href="/schedule">Practice Schedule</Link><Link href="/reports">Reports</Link><LogoutButton/></nav></header>{children}<footer className="footer">Practice Attendance Monitoring System • QSU Socio-Cultural Services</footer></>}
