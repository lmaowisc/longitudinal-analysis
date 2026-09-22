const json = (data,status=200) => Response.json(data,{status,headers:{'Cache-Control':'no-store','X-Content-Type-Options':'nosniff'}});
const hash = async value => Array.from(new Uint8Array(await crypto.subtle.digest('SHA-256',new TextEncoder().encode(value))),b=>b.toString(16).padStart(2,'0')).join('');
const pagesOrigin = 'https://lmaowisc.github.io';
const moderator = request => request.headers.get('Origin') !== pagesOrigin && request.headers.get('oai-authenticated-user-email')?.toLowerCase() === 'lmaowisc@gmail.com';
async function readJson(request) {
  const reader=request.body?.getReader(); if(!reader)throw Error('empty');
  let size=0; const chunks=[];
  while(true){const {done,value}=await reader.read();if(done)break;size+=value.length;if(size>12000){await reader.cancel();throw Error('large');}chunks.push(value);}
  const bytes=new Uint8Array(size);let at=0;for(const chunk of chunks){bytes.set(chunk,at);at+=chunk.length;}
  return JSON.parse(new TextDecoder().decode(bytes));
}
export default {
  async fetch(request,env) {
    const origin=request.headers.get('Origin');
    const url=new URL(request.url);
    if(!url.pathname.startsWith('/api/')){
      if(url.hostname==='phs651-spring-2019.lmaowisc.chatgpt.site'){
        // Retain an instructor-only moderation view, not a second public course.
        const moderationPage=['/','/index.html'].includes(url.pathname) && url.searchParams.get('moderate')==='1';
        const moderationAsset=['/styles.css','/app.js','/comments.js','/lectures.js','/lecture-support.js'].includes(url.pathname);
        if(moderator(request) && (moderationPage || moderationAsset)){
          const assetURL=new URL(request.url);assetURL.search='';
          const response=await env.ASSETS.fetch(new Request(assetURL,request));
          const headers=new Headers(response.headers);
          headers.set('Cache-Control','private, no-store');headers.set('X-Robots-Tag','noindex, nofollow');
          return new Response(response.body,{status:response.status,headers});
        }
        const path=url.pathname==='/index.html'?'':url.pathname.replace(/^\//,'');
        return new Response(null,{status:302,headers:{Location:'https://lmaowisc.github.io/longitudinal-analysis/'+path,'Cache-Control':'no-store'}});
      }
      return env.ASSETS.fetch(request);
    }
    const allowed=origin===url.origin || origin===pagesOrigin;
    if(request.method==='OPTIONS'){
      if(!allowed)return json({error:'Origin not allowed.'},403);
      const headers=new Headers({'Access-Control-Allow-Origin':origin,'Access-Control-Allow-Methods':'GET, POST, DELETE, OPTIONS','Access-Control-Allow-Headers':'Content-Type, X-Delete-Token','Access-Control-Max-Age':'600','Vary':'Origin'});
      return new Response(null,{status:204,headers});
    }
    const response=await handleComments(request,env);
    const headers=new Headers(response.headers);
    headers.set('Vary','Origin');
    if(allowed)headers.set('Access-Control-Allow-Origin',origin);
    return new Response(response.body,{status:response.status,headers});
  }
};
async function handleComments(request,env) {
    const url=new URL(request.url);
    if(!url.pathname.startsWith('/api/')) return env.ASSETS.fetch(request);
    if(url.pathname!=='/api/comments' && !/^\/api\/comments\/[a-f0-9-]{36}$/.test(url.pathname))return json({error:'Not found.'},404);
    try {
      if(request.method==='GET' && url.pathname==='/api/comments'){
        const offset=Math.max(0,Math.min(100000,Number.parseInt(url.searchParams.get('offset')||'0',10)||0));
        const {results}=await env.DB.prepare('SELECT id,name,body,lecture,created_at FROM comments ORDER BY created_at DESC,id DESC LIMIT 51 OFFSET ?').bind(offset).all();
        return json({comments:results.slice(0,50),nextOffset:results.length>50?offset+50:null,moderator:moderator(request)});
      }
      if(!['POST','DELETE'].includes(request.method))return json({error:'Method not allowed.'},405);
      const origin=request.headers.get('Origin');
      if(origin!==url.origin && origin!==pagesOrigin)return json({error:'Please post from this website.'},403);
      if(request.method==='DELETE'){
        const id=url.pathname.split('/')[3];if(!id)return json({error:'Missing comment.'},400);
        const token=request.headers.get('X-Delete-Token')||'';
        if(!moderator(request) && !/^[a-f0-9-]{36}$/.test(token))return json({error:'You can only remove your own comments.'},403);
        const result=moderator(request)?await env.DB.prepare('DELETE FROM comments WHERE id = ?').bind(id).run():await env.DB.prepare('DELETE FROM comments WHERE id = ? AND delete_hash = ?').bind(id,await hash(token)).run();
        return result.meta.changes?json({deleted:true}):json({error:'Comment not found or removal not authorized.'},403);
      }
      if(url.pathname!=='/api/comments')return json({error:'Not found.'},404);
      if(!request.headers.get('Content-Type')?.startsWith('application/json'))return json({error:'Please use the comment form.'},415);
      let input;try{input=await readJson(request);}catch{return json({error:'Invalid or oversized comment.'},400);}
      if(!input || typeof input!=='object')return json({error:'Invalid comment.'},400);
      const name=typeof input.name==='string'?input.name.trim():'';
      const body=typeof input.body==='string'?input.body.trim():'';
      const lecture=input.lecture===null?null:input.lecture;
      if(!name || name.length>80 || !body || body.length>2000 || (lecture!==null && (!Number.isInteger(lecture)||lecture<1||lecture>24)) || input.website)return json({error:'Enter a name (up to 80 characters), a comment (up to 2,000 characters), and a valid lecture.'},400);
      const identity=request.headers.get('oai-authenticated-user-id')||request.headers.get('CF-Connecting-IP');
      if(!identity)return json({error:'Unable to verify this visit. Please reload and try again.'},503);
      const now=Date.now(), id=crypto.randomUUID(), token=crypto.randomUUID();
      // Daily rotating hash avoids retaining raw IP addresses or account identifiers.
      const visitor=await hash(`${url.host}:${new Date(now).toISOString().slice(0,10)}:${identity}`);
      const result=await env.DB.prepare('INSERT INTO comments (id,name,body,lecture,created_at,delete_hash,visitor_hash) SELECT ?,?,?,?,?,?,? WHERE NOT EXISTS (SELECT 1 FROM comments WHERE visitor_hash = ? AND created_at > ?)').bind(id,name,body,lecture,now,await hash(token),visitor,visitor,now-30000).run();
      if(!result.meta.changes)return json({error:'Please wait 30 seconds before posting another comment.'},429);
      return json({comment:{id,name,body,lecture,created_at:now},deleteToken:token},201);
    } catch {return json({error:'Comments are temporarily unavailable. Please try again; your draft has not been cleared.'},503);}
}
