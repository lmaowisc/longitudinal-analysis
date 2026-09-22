// Content-reviewed associations, not calendar-session or filename-only matches.
window.lectureSupport = {
  1: {data:['tlc-data.txt','fev1.sas7bdat','fat-data.txt','toenail-data.txt','epilepsy-data.txt'],note:'Data for the introductory study examples; analyses follow in later lectures.'},
  2: {code:['lecture2.sas'],data:['fev1_baseline.txt'],references:['Appendix. Matrix operations.pdf'],note:'The supplied SAS program uses the FEV1 baseline data. The historical slides also name topeka.txt and tox.txt, which were not found in the course folder; the guinea-pig ANOVA example cannot be reproduced from the supplied files.'},
  3: {code:['lecture3.sas'],data:['tlc-data.txt']},
  4: {code:['lecture4.sas'],data:['tlc-data.txt'],references:['Appendix. Matrix operations.pdf']},
  5: {data:['tlc-data.txt'],note:'Theory and TLC illustrations; no separate Lecture 5 SAS program was supplied.'},
  6: {code:['lecture6.sas','HW1.sas'],data:['tlc-data.txt','cholesterol-data.txt'],assignments:['HW1 Solution.pdf'],note:'Homework 1 is assigned on slide 24. HW1.sas and the cholesterol data support its textbook exercise; the solution also covers the TLC question.'},
  7: {code:['lecture7.sas'],data:['tlc-data.txt']},
  8: {code:['lecture8.sas'],data:['smoking-data.txt','tlc-data.txt']},
  9: {code:['lecture9.sas'],data:['exercise-data.txt']},
  10: {code:['lecture10.sas'],data:['exercise-data.txt']},
  11: {code:['lecture11.sas'],data:['exercise-data.txt','fat-data.txt']},
  12: {data:['exercise-data.txt'],note:'Design calculations reuse the Exercise Therapy estimates from Lecture 10. No separate Lecture 12 SAS program was supplied.'},
  13: {code:['lecture13.sas'],data:['fat-data.txt'],references:['Model Diagnostics.pdf'],note:'Model Diagnostics is an additional PDF-only reference, not a second version of this lecture.'},
  14: {code:['lecture14.sas'],data:['toenail-data.txt','epilepsy-data.txt']},
  15: {code:['lecture15.sas'],data:['toenail-data.txt']},
  16: {code:['lecture16.sas'],data:['arthritis-data.txt','leprosy-data.txt']},
  17: {data:['toenail-data.txt'],note:'No separate Lecture 17 SAS program was supplied. Related GLMM implementations are in Lecture 18, using different datasets.'},
  18: {code:['lecture18.sas'],data:['leprosy-data.txt','ecg-data.txt']},
  19: {data:['tlc-data.txt','fev1.sas7bdat'],note:'The TLC file is the original complete dataset. Slides 23–32 use a modified version with artificial missing values that was not supplied, so these data do not exactly reproduce the imputation example. No separate Lecture 19 SAS program was found.'},
  20: {code:['lecture20.sas'],data:['contracep-data.txt']},
  21: {code:['lecture21.sas'],data:['progesterone-data.txt']},
  22: {code:['lecture22.sas'],data:['tvsfp-data.txt']},
  23: {code:['lecture23.sas'],data:['headache-data.txt']},
  24: {references:['timevarying_Hernan.pdf'],note:'Optional further reading on time-varying treatments, as discussed on slide 12. No additional dataset is required for the review.'}
};

// One catalog drives the file library and counts; each stored file appears once.
const codeNumbers = [2,3,4,6,7,8,9,10,11,13,14,15,16,18,20,21,22,23];
const dataContexts = {
  'arthritis-data.txt':'Lecture 16 · arthritis ordinal-response trial',
  'cholesterol-data.txt':'Homework 1 (Lecture 6) · National Cooperative Gallstone Study',
  'contracep-data.txt':'Lecture 20 · contraceptive trial, dropout indicators and lagged responses',
  'dental-data.txt':'Optional dataset · dental growth; no verified numbered-lecture assignment',
  'ecg-data.txt':'Lecture 18 · abnormal-ECG crossover trial',
  'epilepsy-data.txt':'Lectures 1 and 14 · anti-epileptic drug trial',
  'exercise-data.txt':'Lectures 9–12 · Exercise Therapy Trial',
  'fat-data.txt':'Lectures 1, 11 and 13 · MIT Growth and Development Study',
  'fev1_baseline.txt':'Lecture 2 · Six Cities baseline lung-function data',
  'fev1.sas7bdat':'Lectures 1 and 19 · full longitudinal Six Cities data (SAS format)',
  'headache-data.txt':'Lecture 23 · headache crossover trial',
  'HEALTH.txt':'Final project · educational intervention and self-rated health',
  'leprosy-data.txt':'Lectures 16 and 18 · antibiotics trial',
  'progesterone-data.txt':'Lecture 21 · early pregnancy study',
  'rat-data.txt':'Optional dataset · rat growth; no verified numbered-lecture assignment',
  'skin-data.txt':'Optional dataset · skin study; no verified numbered-lecture assignment',
  'smoking-data.txt':'Lecture 8 · smoking and lung function',
  'tlc-data.txt':'Lectures 1, 3–8 and 19 · original complete TLC trial data',
  'toenail-data.txt':'Lectures 1, 14, 15 and 17 · toenail infection trial',
  'tvsfp-data.txt':'Lecture 22 · school and television smoking-prevention study'
};
window.courseFiles = [
  ...codeNumbers.map(n=>({group:'sas',folder:'code',name:`lecture${n}.sas`,title:`Lecture ${String(n).padStart(2,'0')} · SAS examples`,context:window.courseLectures.find(deck=>deck.n===n).topic})),
  {group:'sas',folder:'code',name:'HW1.sas',title:'Homework 1 · SAS examples',context:'Lecture 6 · cholesterol response profiles'},
  ...Object.entries(dataContexts).map(([name,context])=>({group:'data',folder:'data',name,context})),
  {group:'reference',folder:'lectures',name:'Appendix. Matrix operations.pdf',title:'Matrix operations',context:'Lectures 2 and 4 · PDF-only background notes'},
  {group:'reference',folder:'lectures',name:'Model Diagnostics.pdf',title:'Mixed model diagnostics',context:'Lecture 13 · additional PDF-only reference'},
  {group:'reference',folder:'lectures',name:'timevarying_Hernan.pdf',title:'Time-varying treatments · Miguel Hernán',context:'Lecture 24 · optional PDF-only reading'},
  {group:'reference',folder:'assignments',name:'HW1 Solution.pdf',title:'Homework 1 · solution',context:'Prompt on Lecture 6, slide 24 · use with HW1.sas and cholesterol-data.txt'},
  {group:'reference',folder:'assignments',name:'Final project - PHS651 Spring 2019.pdf',title:'Final project · assignment prompt',context:'Use with HEALTH.txt · historical 2019 deadline'},
  {group:'reference',folder:'lectures',name:'DraftSchedule651_Spring2019.pdf',title:'Original 2019 schedule',context:'Historical calendar, including former lab sessions; not the current 24-deck index'}
];
