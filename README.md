# Data Engineering Project: Section C2, Group 5

Course project for 95-815 Data Engineering (Fall 2026, Mini 2), worth 30% of the course grade.

We are building an end-to-end data pipeline that answers a real-world problem: acquire, store, clean, integrate, serve, analyze.

**Topic:** to be decided (see Milestone 1).

## Team

| Name | GitHub | Role |
| --- | --- | --- |
| Mehul Pardeshi | @MehulPardeshi | Project manager (to be confirmed by team vote) |
| Joshua Kalakoti | @JoshuaKalakoti | TBD |
| Sowmya Rajesh | @Sowmya-Rajesh | TBD |
| Yang Lin | @yanglin4ni | TBD |

## Deadlines

Late project submissions are not accepted, and late passes do not apply. If this table and Canvas ever disagree, Canvas wins.

| Date | What | Weight |
| --- | --- | --- |
| Mon, Nov 9, 11:59 pm | **Milestone 1:** proposal PDF, 1-2 pages | 1% |
| Mon, Nov 23, 11:59 pm | **Milestone 2:** PDF, 3-4 pages, plus 5-minute video | 4% |
| Wed, Dec 9, 5:30-8:30 pm | **Milestone 3:** 15-minute live presentation, everyone in person, plus final report | 20% |
| To be announced | Individual peer evaluation | 5% |

The midterm falls in the same stretch as Milestone 2 (Nov 16/17), and Thanksgiving break comes right after it, so Milestone 2 tasks are scheduled early.

## Where things live

| What | Where |
| --- | --- |
| Tasks and deadlines | [Issues](../../issues) and the [project board](https://github.com/users/MehulPardeshi/projects/2) |
| Progress by milestone | [Milestones](../../milestones) |
| Meeting agendas and minutes | Our shared Google Doc (required by the course and reviewed for grading) |
| Code and SQL | This repo |
| Group chat | WhatsApp |
| Help from Claude or Codex | Ask it to read [AGENTS.md](AGENTS.md) first |

## How we work

1. **Every piece of work is an issue** with one owner and a due date. Use **New issue → Task**.
2. **Pick up work** by assigning yourself and moving the card to In Progress on the board.
3. **Contribute through pull requests.** Don't push to `main`. Put your work on a branch and open a pull request with `Closes #<issue number>`, or `Part of #<issue number>` if the task isn't finished. This covers written work as well as code. You can do it all on the GitHub website: see [proposal/ideas](proposal/ideas/README.md) for the steps.
4. **One teammate reviews** each pull request before it's merged.
5. **Discuss on the issue or pull request**, so decisions stay findable.
6. **Stuck?** Add the `blocked` label and say so in WhatsApp. Early warnings give us more options.
7. **We meet online at least weekly**, and minutes go in the Google Doc. Pull requests don't replace this, because the course grades the meeting record. The final presentation on Dec 9 is in person.

## Ground rules

- **Never commit** passwords, API keys, AWS credentials or `.env` files.
- **Never commit datasets.** They live in PostgreSQL, S3 or MongoDB, and the `data/` folder is ignored by git.
- **Real data only.** Fabricating data is an automatic project failure.
