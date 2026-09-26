import {env} from 'cloudflare:workers';
import {getChatGPTUser} from './chatgpt-auth';
import type {NextRequest} from 'next/server';

// Standalone deployments require a teacher secret. Only a Sites deployment
// explicitly configured for trusted ChatGPT auth may use injected identity.
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
  if(config.SITES_CHATGPT_AUTH==='enabled')return (await getChatGPTUser())?.userId??null;
  return null;
}
