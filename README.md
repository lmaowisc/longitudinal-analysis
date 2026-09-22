# Applied Longitudinal Analysis

Instructor: **Lu Mao, PhD, University of Wisconsin-Madison**.

Course materials are adapted from *Applied Longitudinal Analysis* by Garrett M. Fitzmaurice, Nan M. Laird, and James H. Ware (Wiley). Additional references retain their original authorship.

Source for the approved course website. The [live website](https://phs651-spring-2019.lmaowisc.chatgpt.site/) remains on its existing hosting, including its public comments service. The [GitHub repository](https://github.com/lmaowisc/longitudinal-analysis) holds the source and approved course materials; it is not a GitHub Pages deployment.

This clean copy excludes previous Git history, hosting credentials, the student evaluation source PDF, removed student work, temporary files, installed dependencies, and comments databases. Original teaching materials remain untouched.

## Contents

- `public/`: the website and its approved downloads. Edit website content here.
- `public/materials/`: 24 PowerPoints (607 slides), 19 SAS programs, 20 datasets, six PDF reference/course documents, the materials guide, and the matching bulk slide ZIP.
- `server.js`: the existing server-backed comments implementation, preserved for migration.
- `preview.mjs`: loopback-only local preview with a new local SQLite database.
- `db/` and `drizzle/`: comments schema and migrations; no visitor records.
- `build.mjs`: builds `dist/client/` and `dist/server/` without linking this copy to the existing hosted site.
- `test-comments.mjs`: comments tests using an in-memory database.
- `FILE_MANIFEST.json`: checksums of all 77 approved public assets at preparation time. This is a snapshot, not an automatically updated manifest.

## Run locally

Use Node.js 24 (the version used to verify this copy). Open a terminal in this folder:

```sh
node build.mjs
node preview.mjs
```

Open `http://localhost:4174/`. Stop the preview with Ctrl+C. The preview binds only to your own computer. If port 4174 is already occupied, stop the other course-preview process first.

This preview uses Node's built-in modules and does not require installing dependencies. It creates a fresh database under `.wrangler/`, which is excluded from Git. Test comments entered here stay local and do not appear on the existing website.

To run the comments checks without creating a database file:

```sh
node test-comments.mjs
```

For optional schema/Workers tooling, install the existing locked dependencies with `pnpm install --frozen-lockfile`. The supplied `wrangler.json` contains local-development placeholders, not a configured production deployment.

The generated `dist/` folder is excluded from Git. Build from a fresh checkout for a clean release, so old generated assets cannot survive a source-file deletion.

## Hosting and reuse

1. Use only this clean source tree for the public repository; never copy the previous site's `.git` directory.
2. The live website retains its existing comments backend. The preserved `/api/comments` service requires a server and database and will not work on GitHub Pages alone. A separate deployment needs its own configured backend.
3. Replace the existing platform-specific moderator authentication before independently deploying `server.js`. It currently expects trusted hosting-platform authentication headers. Those headers must not be trusted from arbitrary internet clients. The local preview strips them and does not provide instructor moderation.
4. Review redistribution permissions for the course/book-derived and third-party materials. No blanket license is granted by this folder. See `THIRD_PARTY_NOTICES.md`.
5. Review remaining historical limitations in `public/materials/README.md`. Lectures 2 and 19 still lack exact historical example inputs, and the SAS results have not been rerun. Optional datasets and the historical schedule remain intentionally included.

The original site's hosting identifiers and configuration are deliberately excluded. There is no deployment workflow, GitHub token, or automatic publishing action in this folder.
