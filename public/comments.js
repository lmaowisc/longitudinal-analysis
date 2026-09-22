(() => {
  const $=id=>document.getElementById(id),form=$('comment-form'),list=$('comment-list');
  let nextOffset=null,isModerator=false,busy=false;
  const tokens={};try{Object.assign(tokens,JSON.parse(localStorage.getItem('phs651-comment-removal')||'{}'));}catch{}
  for(let n=1;n<=24;n++){const option=document.createElement('option');option.value=n;option.textContent=`Lecture ${n}`;$('comment-lecture').append(option);}
  async function api(url,options){const response=await fetch(url,options);let data;try{data=await response.json();}catch{throw Error('Comments are temporarily unavailable. Please try again.');}if(!response.ok)throw Error(data.error||'Please try again.');return data;}
  function render(comment){
    const article=document.createElement('article');article.className='visitor-comment';
    const name=document.createElement('h3');name.textContent=comment.name;
    const meta=document.createElement('p');meta.className='comment-meta';meta.textContent=`${comment.lecture?`Lecture ${comment.lecture}`:'General'} · ${new Date(comment.created_at).toLocaleString()}`;
    const body=document.createElement('p');body.className='comment-body';body.textContent=comment.body;
    article.append(name,meta,body);
    if(isModerator||tokens[comment.id]){const remove=document.createElement('button');remove.type='button';remove.className='remove-comment';remove.textContent=isModerator?'Remove comment':'Remove my comment';remove.addEventListener('click',async()=>{if(!confirm('Remove this comment from the website?'))return;remove.disabled=true;try{await api(`/api/comments/${comment.id}`,{method:'DELETE',headers:{'X-Delete-Token':tokens[comment.id]||''}});delete tokens[comment.id];try{localStorage.setItem('phs651-comment-removal',JSON.stringify(tokens));}catch{}await load();}catch(error){$('comments-status').textContent=error.message;remove.disabled=false;}});article.append(remove);}
    return article;
  }
  async function load(append=false){
    if(busy)return;busy=true;$('refresh-comments').disabled=true;$('more-comments').disabled=true;
    $('comments-status').textContent='Loading comments…';
    try{const data=await api(`/api/comments?offset=${append?nextOffset:0}`);isModerator=data.moderator;if(!append)list.replaceChildren();for(const comment of data.comments)list.append(render(comment));nextOffset=data.nextOffset;$('more-comments').hidden=nextOffset===null;$('comments-status').textContent=list.children.length?'Newest comments first.':'No comments yet. Start the conversation.';}
    catch(error){$('comments-status').textContent=error.message;}
    finally{busy=false;$('refresh-comments').disabled=false;$('more-comments').disabled=false;}
  }
  form.addEventListener('submit',async event=>{
    event.preventDefault();$('post-comment').disabled=true;$('post-status').textContent='Posting…';
    try{const data=await api('/api/comments',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({name:$('comment-name').value,body:$('comment-body').value,lecture:$('comment-lecture').value?Number($('comment-lecture').value):null,website:$('comment-website').value})});tokens[data.comment.id]=data.deleteToken;let saved=true;try{localStorage.setItem('phs651-comment-removal',JSON.stringify(tokens));}catch{saved=false;}$('comment-body').value='';$('post-status').textContent=saved?'Your comment is posted and visible to other visitors.':'Your comment is posted. Browser storage is unavailable, so you can remove it only while this page remains open.';await load();}
    catch(error){$('post-status').textContent=error.message;}
    finally{$('post-comment').disabled=false;}
  });
  $('refresh-comments').addEventListener('click',()=>load());$('more-comments').addEventListener('click',()=>load(true));load();
})();
