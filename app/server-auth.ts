import {env} from 'cloudflare:workers';
import {getChatGPTUser} from './chatgpt-auth';
import type {NextRequest} from 'next/server';

// A recipient-operated deployment can set TEACHER_ACCESS_KEY. Sites deployments
// without it continue to use ChatGPT sign-in for teachers.
export async function teacherIdentity(req:NextRequest):Promise<string|null>{
  const secret=(env as unknown as Record<string,string|undefined>).TEACHER_ACCESS_KEY;
  if(secret){
    const supplied=req.headers.get('x-teacher-code')||'';
    if(!supplied||supplied.length>256)return null;
    const digest=async(s:string)=>new Uint8Array(await crypto.subtle.digest('SHA-256',new TextEncoder().encode(s)));
    const [a,b]=await Promise.all([digest(secret),digest(supplied)]);
    let diff=0;for(let i=0;i<a.length;i++)diff|=a[i]^b[i];
    return diff===0?'portable-teacher':null;
  }
  return (await getChatGPTUser())?.userId??null;
}
