# Guide for AI assistants (Claude, Codex and others)

A teammate has asked you for help with our course project. Read this whole file first, then follow **What to do first**.

## The project
- **Course:** 95-815 Data Engineering, Carnegie Mellon (Fall 2026, Mini 2). The project is 30% of the grade.
- **Team:** Section C2, Group 5.
- **Goal:** build an end-to-end data pipeline that answers a real-world problem: acquire, store, clean, integrate, serve and analyze data.

### Team

| GitHub | Name | Role |
| --- | --- | --- |
| @MehulPardeshi | Mehul Pardeshi | Project manager. Assembles and submits deliverables. |
| @JoshuaKalakoti | Joshua Kalakoti | Owns the team's Google Doc of meeting notes |
| @Sowmya-Rajesh | Sowmya Rajesh | |
| @yanglin4ni | Yang Lin | |

## Current status
_Updated Nov 6, 2026. The project manager keeps this section current._

- **Now:** Milestone 1, the proposal, due **Mon Nov 9, 11:59 pm**. Late work is not accepted.
- **Topic:** being voted on in WhatsApp. The options are flight delays, food labels and the tech job market, all in [proposal/ideas](proposal/ideas). Until the vote closes, treat the topic as undecided.
- **Proposal sections:** claimed in WhatsApp, first come, first served. Joshua, Sowmya and Yang each take one of these:
  - Context and problem statement
  - Specific questions
  - Why it matters and who benefits
- **Already done:** Mehul wrote the Team section.
- **Everyone:** writes one line under "Our motivation".
- **Where to write:** [proposal/milestone1.md](proposal/milestone1.md) in [PR #37](https://github.com/MehulPardeshi/de-group5-project/pull/37). Drafts are due **Sun Nov 8, 9 pm**.
- **Meeting:** short and online. The time is in WhatsApp. It's only for confirming who does what, because decisions are made in chat beforehand.

## What to do first
1. **Ask the teammate for their GitHub username** if you don't know it, and tell them which name it matches.
2. **List their open work.** If you can run commands:
   ```bash
   gh issue list --repo MehulPardeshi/de-group5-project --assignee <username>
   gh pr list --repo MehulPardeshi/de-group5-project
   ```
   If you can't, read the [issues](https://github.com/MehulPardeshi/de-group5-project/issues) and [pull requests](https://github.com/MehulPardeshi/de-group5-project/pulls) pages.
3. **Combine that with Current status above,** because some tasks are claimed in WhatsApp and aren't assigned on GitHub yet.
4. **Tell them in a short list:**
   - their tasks, with due dates
   - the next step for each one
   - anything they still need to choose or reply to in WhatsApp
5. **Walk them through each step.** Many of the team are new to GitHub, so give click-by-click steps on the GitHub website unless they're comfortable with git.

## How we work
- **Every task is a GitHub issue,** and the [project board](https://github.com/users/MehulPardeshi/projects/2) shows them with due dates.
- **All work goes through pull requests.** Never push to `main`.
  - **To edit a file in an existing PR on the website:** open the PR, go to **Files changed**, choose **⋯ → Edit file**, make the edit, then **Commit changes** to the PR's branch.
  - **To add a new file:** use **Add file → Create new file**, choose **Create a new branch**, then **Propose changes**.
  - **In the PR description:** write `Part of #<issue>`, or `Closes #<issue>` when the task is finished.
- **Decisions happen in WhatsApp,** and the project manager records them here.
- **Meeting notes go in the team's Google Doc,** not in this repo. The course grades that doc.

## Course rules you must respect
- **Real data only.** Fabricated or synthetic data means the project fails automatically.
- **Data requirements:**
  - at least 3 distinct datasets that complement each other
  - at least 1 semi-structured dataset, such as JSON
  - structured data goes into PostgreSQL
  - raw data is kept separate from cleaned data
- **Never commit secrets or data.** Passwords, API keys, `.env` files and datasets stay out of git. **This repo is public.**
- **AI use follows the syllabus, "Policy on Collaboration and Cheating":**
  - Using unauthorized material, including generative AI tools, to prepare an assignment is cheating, unless the teaching team indicates otherwise.
  - Any help received has to be acknowledged in the submission, naming the sources it came from.
  - If unsure what's acceptable, ask the instructor.

## Key dates

| Date | Deliverable |
| --- | --- |
| Mon Nov 9, 11:59 pm | Milestone 1: proposal PDF, 1-2 pages |
| Mon Nov 23, 11:59 pm | Milestone 2: PDF, 3-4 pages, plus a 5-minute video |
| Wed Dec 9, 5:30-8:30 pm | Final presentation, in person, everyone attends, plus the final report |

## Where things are
- **[README.md](README.md):** team overview and ground rules
- **[proposal/ideas](proposal/ideas):** each person's topic ideas
- **[proposal/milestone1.md](proposal/milestone1.md):** the proposal being written, in PR #37
- **[Issues](https://github.com/MehulPardeshi/de-group5-project/issues) and [milestones](https://github.com/MehulPardeshi/de-group5-project/milestones):** tasks and deadlines
