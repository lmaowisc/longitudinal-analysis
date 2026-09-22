const lectures = window.courseLectures;
const support = window.lectureSupport;
const files = window.courseFiles;
document.querySelector('#sas-count').textContent = files.filter(file => file.group === 'sas').length;
document.querySelector('#data-count').textContent = files.filter(file => file.group === 'data').length;
const enc = value => value.split('/').map(encodeURIComponent).join('/');
const esc = value => String(value).replace(/[&<>"']/g, char => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[char]));
const fileLink = (folder, name) => `<a class="support-link" href="${enc('materials/'+folder+'/'+name)}" download>${esc(name)} ↓</a>`;
const lectureList = document.querySelector('#lecture-list');

lectures.forEach(deck => {
 const number = String(deck.n).padStart(2,'0');
 const materials = support[deck.n];
 const groups = materials ? [['SAS','code',materials.code||[]],['Data','data',materials.data||[]]] : [];
 const referenceGroups = materials ? [['References','lectures',materials.references||[]],['Assignment','assignments',materials.assignments||[]]] : [];
 const count = groups.reduce((sum,group) => sum + group[2].length,0);
 const referenceFiles = referenceGroups.filter(group=>group[2].length).map(([label,folder,names])=>`<p><strong>${label}</strong> ${names.map(name=>fileLink(folder,name)).join(' ')}</p>`).join('');
 const supportingFiles = `<details class="lecture-support"><summary>Code and data${count ? ` (${count} ${count === 1 ? 'file' : 'files'})` : ''}</summary><div class="support-files">${count ? groups.filter(group=>group[2].length).map(([label,folder,names])=>`<p><strong>${label}</strong> ${names.map(name=>fileLink(folder,name)).join(' ')}</p>`).join('') : '<p>No additional code or data files.</p>'}</div></details>${referenceFiles ? `<div class="support-files lecture-references">${referenceFiles}</div>` : ''}`;
 lectureList.insertAdjacentHTML('beforeend', `<article class="lecture" id="lecture-${number}" data-lecture="${deck.n}" data-name="${esc(('lecture '+number+' '+deck.n+' '+deck.topic+' '+deck.filename).toLowerCase())}"><span class="lecture-number" aria-hidden="true">${number}</span><div class="lecture-body"><h3><span class="sr-only">Lecture ${number}: </span>${esc(deck.topic)}</h3><p class="lecture-meta">${deck.slides} slides · PowerPoint</p>${supportingFiles}</div><a class="lecture-deck" href="${enc('materials/lectures/'+deck.filename)}" aria-label="Download Lecture ${number}: ${esc(deck.topic)} PowerPoint" download>PowerPoint ↓</a></article>`);
});

const lectureSearch = document.querySelector('#lecture-search');
lectureSearch.addEventListener('input', () => {
 const query = lectureSearch.value.trim().toLowerCase();
 let count = 0;
 document.querySelectorAll('.lecture').forEach(item => {
  item.hidden = !item.dataset.name.includes(query);
  if (!item.hidden) count++;
 });
 document.querySelector('#lecture-empty').hidden = count > 0;
});

const fileList = document.querySelector('#file-list');
files.forEach(({group,folder,name,title: displayTitle,context}) => {
 const extension = name.split('.').pop();
 const title = displayTitle || name.replace(/\.[^.]+$/,'');
 fileList.insertAdjacentHTML('beforeend', `<a class="download-row" data-group="${group}" data-name="${esc((name+' '+title+' '+context).toLowerCase())}" href="${enc('materials/'+folder+'/'+name)}" download><span class="file-icon">${esc(extension)}</span><span><strong>${esc(title)}</strong><small>${esc(context)}</small></span><span class="arrow">↓</span></a>`);
});

let fileFilter = 'all';
const search = document.querySelector('#file-search');
function applyFiles() {
 const query = search.value.trim().toLowerCase();
 let count = 0;
 document.querySelectorAll('.download-row').forEach(item => {
  item.hidden = (fileFilter !== 'all' && item.dataset.group !== fileFilter) || !item.dataset.name.includes(query);
  if (!item.hidden) count++;
 });
 document.querySelector('#file-empty').hidden = count > 0;
}
function setFileFilter(value) {
 fileFilter = value;
 document.querySelectorAll('.tab').forEach(button => {
  const active = button.dataset.fileFilter === fileFilter;
  button.classList.toggle('active', active);
  button.setAttribute('aria-pressed', String(active));
 });
 applyFiles();
}
search.addEventListener('input', applyFiles);
document.querySelectorAll('.tab').forEach(button => button.addEventListener('click', () => setFileFilter(button.dataset.fileFilter)));
document.querySelectorAll('[data-jump-filter]').forEach(link => link.addEventListener('click', () => {
 search.value = '';
 setFileFilter(link.dataset.jumpFilter);
}));
