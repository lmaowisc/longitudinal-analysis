import {DatabaseSync} from 'node:sqlite';
import {readFileSync,readdirSync} from 'node:fs';
import assert from 'node:assert/strict';
import worker from './server.js';
const db=new DatabaseSync(':memory:');
for(const file of readdirSync('drizzle').filter(n=>n.endsWith('.sql')))db.exec(readFileSync(`drizzle/${file}`,'utf8'));
const env={DB:{prepare(sql){return{bind(...params){return{async all(){return{results:db.prepare(sql).all(...params)};},async run(){return{meta:db.prepare(sql).run(...params)};}};}};}},ASSETS:{fetch:()=>new Response('asset')}};
async function call(method='GET',data,extra={},path='/api/comments'){
 const response=await worker.fetch(new Request(`https://course.test${path}`,{method,headers:{Origin:'https://course.test','Content-Type':'application/json','CF-Connecting-IP':'192.0.2.1',...extra},body:data===undefined?undefined:JSON.stringify(data)}),env);
 return {status:response.status,data:await response.json()};
}
assert.deepEqual((await call()).data.comments,[]);
const input={name:'Test visitor',body:'A question about correlated outcomes. <script>alert(1)</script>',lecture:3,website:''};
const created=await call('POST',input);assert.equal(created.status,201);
const secondVisitor=await call('GET',undefined,{'CF-Connecting-IP':'192.0.2.2'});
assert.equal(secondVisitor.data.comments[0].body,input.body);assert.equal(secondVisitor.data.comments[0].delete_hash,undefined);assert.equal(secondVisitor.data.comments[0].visitor_hash,undefined);
assert.equal((await call('POST',input)).status,429);
assert.equal((await call('POST',input,{Origin:'https://evil.test'})).status,403);
assert.equal((await call('POST',{...input,body:'x'.repeat(2001)})).status,400);
assert.equal((await call('POST',{...input,lecture:25})).status,400);
assert.equal((await call('POST',{...input,website:'spam'})).status,400);
assert.equal((await call('DELETE',undefined,{},`/api/comments/${created.data.comment.id}`)).status,403);
assert.equal((await call('DELETE',undefined,{'X-Delete-Token':created.data.deleteToken},`/api/comments/${created.data.comment.id}`)).status,200);
assert.equal((await call()).data.comments.length,0);
const again=await call('POST',input);assert.equal(again.status,201);
assert.equal((await call('DELETE',undefined,{'oai-authenticated-user-email':'lmaowisc@gmail.com'},`/api/comments/${again.data.comment.id}`)).status,200);
assert.equal((await worker.fetch(new Request('https://course.test/styles.css'),env)).status,200);
console.log('PASS: shared comments, validated input, rate limit, CSRF, data privacy, author removal, instructor moderation, static assets.');
