# Applied Longitudinal Analysis — materials guide

Instructor: Lu Mao, PhD, University of Wisconsin-Madison.

Course materials are adapted from *Applied Longitudinal Analysis* by Garrett M. Fitzmaurice, Nan M. Laird, and James H. Ware (Wiley). [Publisher information](https://onlinelibrary.wiley.com/doi/book/10.1002/9781119513469). Additional references retain their original authorship.

## Organization and use

- The current index has 24 lectures and exactly one numbered PowerPoint per lecture (607 slides). The original schedule is historical and includes former lab sessions; it is not the current lecture numbering.
- Each lecture lists its matched code, data, and references. Data shared by several lectures are stored once.
- There are 19 SAS programs: 18 lecture programs and Homework 1. Download the data listed beside a program and set your SAS working directory to the folder containing those files. Some graphics examples require SAS/GRAPH. These legacy programs have been checked statically, not executed in SAS.
- Of 20 datasets, three are optional: dental-data.txt, rat-data.txt, and skin-data.txt. They are retained at the instructor's request, without an asserted lecture association.
- Homework 1's prompt is on Lecture 6, slide 24. Its solution, HW1.sas, and cholesterol-data.txt belong together. The final-project prompt belongs with HEALTH.txt; no student solution is included.

## Corrections to website copies

- Removed obsolete machine-specific data paths and unused library declarations from the early SAS programs.
- Lecture 8 now explicitly loads and reshapes tlc-data.txt before its piecewise-linear example.
- Lecture 11's exercise model now uses the random intercept and slope shown on slide 15; the extra random time-by-group term was removed. The duplicate legacy lecture101.sas is no longer distributed.
- Corrected stale topic/number comments in the SAS programs for Lectures 8, 10, 11, 15, and 20.
- Corrected copied outlines in Lectures 6 and 14 and completed the example names in Lectures 13 and 15. Corrected the NMAR definition in Lecture 19 and the after-day-7 interpretation in Lecture 21.
- Lecture 18's ECG GLMM now explicitly models abnormal ECG (`event='1'`), consistent with the GEE model and slides. Numerical results still require verification in SAS.
- Corrected TLC time units and toenail plot labels in the SAS programs, stale leprosy/contrast comments, and a missing plus sign in the Homework 1 solution.

## Known limitations of the historical materials

- **Lecture 2:** the slides refer to topeka.txt and tox.txt. Neither was found in the source course folder. The supplied program uses fev1_baseline.txt and different ANOVA illustrations; it does not reproduce the guinea-pig example.
- **Lecture 19:** slide 23 explains that missing TLC observations were created artificially. The supplied tlc-data.txt is complete; the altered dataset and a standalone Lecture 19 SAS program were not found. It cannot reproduce the illustrated imputation analysis exactly.
- No standalone SAS programs were supplied for Lectures 1, 5, 12, 17, 19, or 24. This does not imply a missing PowerPoint: all 24 decks are present.
- The numbered decks retain their original historical course wording internally. The website uses the updated course title.
- All redundant numbered-lecture PDFs are excluded. Three PDF-only references remain: matrix operations, mixed model diagnostics, and Miguel Hernán's time-varying treatments. Matching PowerPoint sources were not found. The schedule, final-project prompt, and Homework 1 solution are documents, not duplicate lecture decks.

Original Dropbox materials have not been changed.
