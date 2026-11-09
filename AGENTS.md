# Guide for AI assistants (Claude, Codex and others)

A teammate has asked you for help with our course project. Read this whole file first, then follow **What to do first**.

## The project
- **Course:** 95-815 Data Engineering, Carnegie Mellon (Fall 2026, Mini 2). The project is 30% of the grade.
- **Team:** Section C2, Group 5.
- **Goal:** build an end-to-end data pipeline that answers a real-world problem: acquire, store, clean, integrate, serve and analyze data.

### Team

| GitHub | Name | Role |
| --- | --- | --- |
| @MehulPardeshi | Mehul Pardeshi | Project manager. Assembles deliverables. |
| @JoshuaKalakoti | Joshua Kalakoti | Owns the team's Google Doc ("DE Group 5 Docs"). Meeting agendas and minutes go in its "Meeting Agenda & Minutes" tab. |
| @Sowmya-Rajesh | Sowmya Rajesh | Communication with TAs and professors; shares docs and submits deliverables |
| @yanglin4ni | Yang Lin (goes by Henry) | |

## Current status
_Updated Nov 9, 2026. The project manager keeps this section current._

- **Topic:** flight delays and weather. Project manager: Mehul.
- **Milestone 1** (proposal) is being submitted by Sowmya on Mon Nov 9 ([#12](https://github.com/MehulPardeshi/de-group5-project/issues/12)). The final text is in the Google Doc's "Project Proposal" tab.
- **Now: Milestone 2**, due **Mon Nov 23, 11:59 pm**: a 3-4 page PDF plus a 5-minute video on data sources, ingestion and initial cleaning. Late work is not accepted.
- **Each person owns one dataset end to end** (acquire, load raw, profile, clean, write its PDF section, record about 1 minute of video):

  | Owner | Dataset | Issue | Stored in |
  | --- | --- | --- | --- |
  | Sowmya | BTS on-time flights | [#47](https://github.com/MehulPardeshi/de-group5-project/issues/47) | PostgreSQL |
  | Yang | NOAA daily weather (JSON, our semi-structured dataset) | [#48](https://github.com/MehulPardeshi/de-group5-project/issues/48) | MongoDB or S3 |
  | Joshua | NOAA Storm Events | [#49](https://github.com/MehulPardeshi/de-group5-project/issues/49) | PostgreSQL |
  | Mehul | OurAirports, plus the shared database setup ([#13](https://github.com/MehulPardeshi/de-group5-project/issues/13)) | [#50](https://github.com/MehulPardeshi/de-group5-project/issues/50) | PostgreSQL |

- **Date range:** Jan 2025 through the latest month BTS has published.
- **Conventions:** each person works only in their own `pipeline/<dataset>/` folder. Raw data goes in the `raw` schema exactly as downloaded, and cleaned tables go in the `clean` schema. Quality issues go in `docs/data_quality_log.md`. Database logins are shared privately and never committed.
- **Schedule:**

  | By | What |
  | --- | --- |
  | Thu Nov 12 | Shared database ready (Mehul) |
  | Sun Nov 15 | Every dataset loaded raw; short weekly meeting |
  | Nov 16-17 | Midterm, no project work |
  | Thu Nov 19 | Profiling, quality log and first cleaning done |
  | Fri Nov 20 | Each person's PDF section (Google Doc, Milestone 2 tab) and video clip done |
  | Sat Nov 21 | Mehul assembles the PDF ([#19](https://github.com/MehulPardeshi/de-group5-project/issues/19)); Joshua edits the video ([#20](https://github.com/MehulPardeshi/de-group5-project/issues/20)) |
  | Sun Nov 22 | Team review meeting |
  | Mon Nov 23, 9 pm | Mehul submits ([#21](https://github.com/MehulPardeshi/de-group5-project/issues/21)) |

- **Meetings:** weekly, online, with the time posted in WhatsApp. Decisions are made in chat beforehand, and meetings confirm who does what.

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
- **[pipeline/](pipeline):** one folder per dataset (ingestion code, raw and clean SQL, source notes), plus `setup/` for the shared databases
- **[docs/data_quality_log.md](docs/data_quality_log.md):** every data quality issue and how we handled it
- **[.env.example](.env.example):** the connection settings each person copies to `.env`. Logins are shared privately.
- **[proposal/](proposal):** topic ideas and the archived Milestone 1 draft
- **[meetings/](meetings):** short meeting summaries. The graded minutes live in the Google Doc.
- **Google Doc:** meeting minutes, the Milestone 1 proposal and the Milestone 2 draft. The link is in the README.
- **[Issues](https://github.com/MehulPardeshi/de-group5-project/issues), [milestones](https://github.com/MehulPardeshi/de-group5-project/milestones) and the [board](https://github.com/users/MehulPardeshi/projects/2):** tasks and deadlines
