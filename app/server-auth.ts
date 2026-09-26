import {env} from 'cloudflare:workers';
import type {NextRequest} from 'next/server';

// Teacher access requires the server-side code in every deployment.
export async function teacherIdentity(req:NextRequest):Promise<string|null>{
  const config=env as unknown as Record<string,string|undefined>;
  const secret=config.TEACHER_ACCESS_KEY;
  if(secret){
    const supplied=req.headers.get('x-teacher-code')||'';
    if(!supplied||supplied.length>256)return null;
    const digest=async(s:string)=>new Uint8Array(await crypto.subtle.digest('SHA-256',new TextEncoder().encode(s)));
    const [a,b]=await Promise.all([digest(secret),digest(supplied)]);
    let diff=0;for(let i=0;i<a.length;i++)diff|=a[i]^b[i];
    return diff===0?'portable-teacher':null;
  }
  return null;
}
