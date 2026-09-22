// Local-only adapter for environments where the Workers emulator is unavailable.
// Production uses the same fetch handler with the hosting service's D1 database.
import http from 'node:http';
import {DatabaseSync} from 'node:sqlite';
import {readFileSync,readdirSync,mkdirSync,statSync} from 'node:fs';
import path from 'node:path';
import worker from './server.js';
mkdirSync('.wrangler',{recursive:true});
const db=new DatabaseSync('.wrangler/comments-preview.sqlite');
db.exec('CREATE TABLE IF NOT EXISTS local_migrations (name TEXT PRIMARY KEY)');
for(const name of readdirSync('drizzle').filter(n=>n.endsWith('.sql'))){if(!db.prepare('SELECT name FROM local_migrations WHERE name=?').get(name)){db.exec(readFileSync(`drizzle/${name}`,'utf8'));db.prepare('INSERT INTO local_migrations VALUES (?)').run(name);}}
const root=path.resolve('dist/client');
const env={DB:{prepare(sql){return{bind(...params){return{async all(){return{results:db.prepare(sql).all(...params)};},async run(){return{meta:db.prepare(sql).run(...params)};}};}};}},ASSETS:{async fetch(req){let file;try{file=path.resolve(root,'.'+decodeURIComponent(new URL(req.url).pathname));if(file===root)file=path.join(root,'index.html');if(!file.startsWith(root+path.sep)||!statSync(file).isFile())return new Response('Not found',{status:404});return new Response(readFileSync(file),{headers:{'Content-Type':({'.html':'text/html','.css':'text/css','.js':'text/javascript','.svg':'image/svg+xml'}[path.extname(file)]||'application/octet-stream')}});}catch{return new Response('Not found',{status:404});}}}};
http.createServer(async(req,res)=>{try{const headers=new Headers();for(const [key,value]of Object.entries(req.headers)){if(!key.startsWith('oai-authenticated-user-')&&value!==undefined)headers.set(key,String(value));}headers.set('CF-Connecting-IP',req.socket.remoteAddress||'local');const data=[];for await(const chunk of req){data.push(chunk);if(data.reduce((n,b)=>n+b.length,0)>15000){res.writeHead(413);res.end();return;}}const response=await worker.fetch(new Request(`http://localhost:4174${req.url}`,{method:req.method,headers,body:['GET','HEAD'].includes(req.method)?undefined:Buffer.concat(data)}),env);res.writeHead(response.status,Object.fromEntries(response.headers));res.end(Buffer.from(await response.arrayBuffer()));}catch{res.writeHead(500);res.end('Preview error');}}).listen(4174,'127.0.0.1',()=>console.log('Comments preview: http://localhost:4174/#comments'));
