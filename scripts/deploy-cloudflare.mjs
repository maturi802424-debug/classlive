import {readFileSync,writeFileSync,readdirSync} from 'node:fs';
import {spawnSync} from 'node:child_process';
import {resolve} from 'node:path';

const databaseId=process.env.CLOUDFLARE_D1_DATABASE_ID;
const databaseName=process.env.CLOUDFLARE_D1_DATABASE_NAME||'classlive';
const workerName=process.env.CLOUDFLARE_WORKER_NAME||'classlive';
if(!databaseId||!/^[a-f0-9-]{36}$/i.test(databaseId)){
  console.error('CLOUDFLARE_D1_DATABASE_ID に D1 の database_id を設定してください。');
  process.exit(1);
}
if(!/^[a-z0-9-]+$/.test(databaseName)||!/^[a-z0-9-]+$/.test(workerName)){
  console.error('D1 と Worker の名前には小文字、数字、ハイフンを使用してください。');
  process.exit(1);
}
function run(...args){
  const result=spawnSync(process.execPath,[resolve('node_modules/wrangler/bin/wrangler.js'),...args],{stdio:'inherit'});
  if(result.status!==0)process.exit(result.status||1);
}
const file=resolve('dist/server/wrangler.json');
const config=JSON.parse(readFileSync(file,'utf8'));
config.name=workerName;
config.d1_databases=[{binding:'DB',database_name:databaseName,database_id:databaseId}];
writeFileSync(file,JSON.stringify(config,null,2)+'\n');
for(const migration of readdirSync('drizzle').filter(x=>/^\d+.*\.sql$/.test(x)).sort()){
  run('d1','execute',databaseName,'--remote','--file',resolve('drizzle',migration),'--config',file);
}
run('deploy','--config',file);
