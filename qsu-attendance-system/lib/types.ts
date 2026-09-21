export type Role='admin'|'user'
export type Profile={id:string;full_name:string;email:string;role:Role;organization?:string|null;created_at:string}
export type Session={id:string;title:string;description?:string|null;practice_date:string;start_time:string;end_time:string;venue?:string|null;qr_token:string;created_by:string;created_at:string}
