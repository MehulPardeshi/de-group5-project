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
_Updated Nov 19, 2026. The project manager keeps this section current._

- **Topic:** flight delays and weather. Project manager: Mehul.
- **Milestone 1** (proposal) was due Mon Nov 9; Sowmya submitted it (confirmed in [#12](https://github.com/MehulPardeshi/de-group5-project/issues/12)). The final text is in the Google Doc's "Project Proposal" tab, and the doc is shared with all instructors and TAs.
  - **Graded 20/20.** The TA asked us to specify the analysis period, define "bad weather" and "usual" delay rates, and say how we pick the three busiest airports. The team decides these at the Sat Nov 21 meeting ([#76](https://github.com/MehulPardeshi/de-group5-project/issues/76)). NOAA weather covers only ATL, DFW, JFK, ORD and PIT.
- **Progress:**
  - OurAirports: raw load, cleaning and quality log done ([PR #55](https://github.com/MehulPardeshi/de-group5-project/pull/55), [PR #57](https://github.com/MehulPardeshi/de-group5-project/pull/57)).
  - NOAA weather: raw JSON in Atlas, profiling and `clean.noaa_daily` done ([PR #62](https://github.com/MehulPardeshi/de-group5-project/pull/62)). Data runs Jan 2025 through **Aug 2026**, so BTS should load through the same month.
  - BTS: raw load (11,730,351 flights), profiling, quality log and `clean.bts_flights` done ([PR #74](https://github.com/MehulPardeshi/de-group5-project/pull/74)). B1 and C1 are in the Google Doc.
  - Storm Events: **not on GitHub yet** (raw load was due Sun Nov 15, cleaning Thu Nov 19). The files are downloaded; keep them in `data/`, not in git ([PR #66](https://github.com/MehulPardeshi/de-group5-project/pull/66)).
- **Google Doc:** the "Milestone 2" tab has a section for each owner (Part B data sources, Part C quality and cleaning). The Sat Nov 14 check-in was held in WhatsApp; its notes are in the minutes tab.
- **Now: Milestone 2**, due **Mon Nov 23, 11:59 pm**: a 3-4 page PDF plus a 5-minute video on data sources, ingestion and initial cleaning. Late work is not accepted. The instructors will post Canvas instructions for submitting the video link (Piazza post 39).
- **Each person owns one dataset end to end** (acquire, load raw, profile, clean, write its PDF section, record about 1 minute of video):

  | Owner | Dataset | Issue | Stored in |
  | --- | --- | --- | --- |
  | Sowmya | BTS on-time flights | [#47](https://github.com/MehulPardeshi/de-group5-project/issues/47) | PostgreSQL |
  | Yang | NOAA daily weather (JSON, our semi-structured dataset) | [#48](https://github.com/MehulPardeshi/de-group5-project/issues/48) | MongoDB Atlas |
  | Joshua | NOAA Storm Events | [#49](https://github.com/MehulPardeshi/de-group5-project/issues/49) | PostgreSQL |
  | Mehul | OurAirports, plus the database setup ([#13](https://github.com/MehulPardeshi/de-group5-project/issues/13), done) | [#50](https://github.com/MehulPardeshi/de-group5-project/issues/50) | PostgreSQL |

- **What's left before the Nov 23 deadline.** The pinned tracker [#70](https://github.com/MehulPardeshi/de-group5-project/issues/70) has the overview, and each person's checklist is at the top of their dataset issue:

  | Who | Task | Due | Where |
  | --- | --- | --- | --- |
  | Joshua | Storm Events raw load, profiling, quality log rows, clean table (overdue) | ASAP | [#49](https://github.com/MehulPardeshi/de-group5-project/issues/49) |
  | Joshua | B3 and C3 in the Milestone 2 tab | Fri Nov 20 | #49 |
  | Everyone | ~1 minute video clip, Drive link to Joshua | Fri Nov 20 | #47-#50 |
  | Everyone | One line under "Acknowledgment of help received" in the Milestone 2 tab | Fri Nov 20 | [#69](https://github.com/MehulPardeshi/de-group5-project/issues/69) |
  | Mehul | Assemble and trim the PDF | Sat Nov 21 | [#19](https://github.com/MehulPardeshi/de-group5-project/issues/19) |
  | Joshua | Edit the clips into one video, under 5:00 | Sat Nov 21 | [#20](https://github.com/MehulPardeshi/de-group5-project/issues/20) |
  | Everyone | Weekly meeting + Milestone 2 review on Google Meet, cameras on (Henry takes notes) | Sat Nov 21, 11am | [#68](https://github.com/MehulPardeshi/de-group5-project/issues/68) |
  | Mehul | Submit the PDF and video on Canvas | Mon Nov 23, 9 pm | [#21](https://github.com/MehulPardeshi/de-group5-project/issues/21) |

  Already done: OurAirports (Mehul), NOAA weather (Henry) and BTS (Sowmya), including their B and C sections; Part A of the PDF. The Milestone 2 tab exports to 3 pages without Storm Events. The Sat Nov 21 meeting agenda is in the Google Doc.

- **Date range:** Jan 2025 through **Aug 2026** (the latest BTS month when the weather data was loaded). Every dataset uses this range.
- **Databases:** PostgreSQL runs **locally in Docker** for each person (`docker compose up -d`; setup in [pipeline/setup](pipeline/setup/README.md)). MongoDB Atlas (cloud, shared) holds the NOAA JSON. AWS RDS was blocked on our account.
- **Conventions:** each person works only in their own `pipeline/<dataset>/` folder. Raw data goes in the `raw` schema exactly as downloaded, and cleaned tables go in the `clean` schema. Quality issues go in `docs/data_quality_log.md`. Database logins are shared privately and never committed.
- **Schedule:**

  | By | What |
  | --- | --- |
  | Thu Nov 12 | Everyone has Docker and Postgres running locally ([setup guide](pipeline/setup/README.md)) |
  | Sat Nov 14 | Weekly check-in (held in WhatsApp; notes in the Google Doc) |
  | Sun Nov 15 | Every dataset loaded raw |
  | Nov 16-17 | Midterm, no project work |
  | Thu Nov 19 | Profiling, quality log and first cleaning done (course Assignment 4 is also due) |
  | Fri Nov 20 | Each person's PDF section (Google Doc, Milestone 2 tab) and video clip done |
  | Sat Nov 21 | Mehul assembles the PDF ([#19](https://github.com/MehulPardeshi/de-group5-project/issues/19)); Joshua edits the video ([#20](https://github.com/MehulPardeshi/de-group5-project/issues/20)) |
  | Sat Nov 21, 11am | Weekly meeting + Milestone 2 review ([#68](https://github.com/MehulPardeshi/de-group5-project/issues/68)) |
  | Sun Nov 22 | Last fixes to the PDF and video |
  | Mon Nov 23, 9 pm | Mehul submits ([#21](https://github.com/MehulPardeshi/de-group5-project/issues/21)) |
  | Tue Nov 24 (proposed) | Thanksgiving-week meeting: M2 wrap-up, M3 kickoff |

- **Meetings:** every **Saturday at 11am on Google Meet**, cameras on. Tracker: [#2](https://github.com/MehulPardeshi/de-group5-project/issues/2).
  - Per Piazza post 39 (Nov 17), only **live** meetings count: in person or video. **WhatsApp or Slack threads do not**, so the Nov 14 WhatsApp check-in didn't count.
  - Thanksgiving week: meet Mon Nov 23 or Tue Nov 24, or hold two meetings Nov 30-Dec 6.
  - The teaching team needs **Editor** access to the Google Doc, not Viewer, because they check its version history.
  - Chat is still for day-to-day coordination.

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
- **All work goes through pull requests.** `main` is protected, so direct pushes are blocked.
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
- **Team decision (Nov 10, 2026): no AI tools for graded work.** Code, SQL, PDF text, video narration and slides are written by the team member themselves. This follows the syllabus "Policy on Collaboration and Cheating", which treats generative AI as unauthorized material unless the teaching team says otherwise.
  - **AI assistants may:** explain the project, the tasks, course concepts and GitHub steps, and do admin work (issues, board, scheduling).
  - **AI assistants must not:** write or rewrite graded code or text, including "in my style" rewrites.
  - Any help received is still acknowledged in the PR description and the submission.

## Key dates

| Date | Deliverable |
| --- | --- |
| Mon Nov 9, 11:59 pm | Milestone 1: proposal PDF, 1-2 pages |
| Mon Nov 23, 11:59 pm | Milestone 2: PDF, 3-4 pages, plus a 5-minute video |
| Wed Dec 9, 5:30-8:30 pm | Final presentation, in person, everyone attends, plus the final report |

## Where things are
- **[README.md](README.md):** team overview and ground rules
- **[pipeline/](pipeline):** one folder per dataset (ingestion code, raw and clean SQL, source notes), plus `setup/` for the shared databases
- **[docs/video_guide.md](docs/video_guide.md):** what each person shows in their 1-minute Milestone 2 clip
- **[docs/data_quality_log.md](docs/data_quality_log.md):** every data quality issue and how we handled it
- **[.env.example](.env.example):** the connection settings each person copies to `.env`. Logins are shared privately.
- **[proposal/](proposal):** topic ideas and the archived Milestone 1 draft
- **[meetings/](meetings):** short meeting summaries. The graded minutes live in the Google Doc.
- **Google Doc:** meeting minutes, the Milestone 1 proposal and the Milestone 2 draft. The link is in the README.
- **[Issues](https://github.com/MehulPardeshi/de-group5-project/issues), [milestones](https://github.com/MehulPardeshi/de-group5-project/milestones) and the [board](https://github.com/users/MehulPardeshi/projects/2):** tasks and deadlines
