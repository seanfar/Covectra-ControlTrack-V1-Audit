# What Is, Why, and How to Tech Audit
## What is a tech/code audit?
A code audit is an organized summary of the state of a codebase.
A tech audit broadens this from just code to other details.
For simplicity, we'll just say "audit" from here on out.


## State of the codebase? Why?
Clients often ask us to do an assessment of what they have now
before they decide what to ask us to do next for them.
They might also ask us to look it over
to evaluate continuing to work with a different contractor:
"Is this stuff we paid them to make us any good?"

That first scenario bears repeating:
**An audit often proves to be the Discovery phase of a development project.**
You should 100% expect that all the recommendations in your audit document
will turn into tasks in an estimate!


## How do I do an audit?
There are two main modes when auditing:

- Diving in and surfing around
- Targeted investigation

I recommend starting with diving in.
Audit due date vs scope often determines when I switch to targeted
investigation.

### TIP: Keep a log!
You have one tremendous benefit as an auditor
on a project you've never seen before:
You'll never be less immune to confusing details
and weird project configurations
than you are now.

Be sure to **keep a running commentary**
of all the hiccups and confusing things you encounter in a log file.
You'll mine this later to write up your findings in the audit document.
You'll also refer back to it to remind yourself
how to navigate this weird architecture they've undoubtedly created.
(After all, anything new is weird at first.)

You'll find a template log in [audit-log.md](audit-log.md)
all ready and waiting for you.

### First step: get the thing to build and run.
This can sometimes be hard. It might require cooperation with the client to get login credentials, as well. But you need to be able to see the thing in action to evaluate UI look and feel, try to crash the thing, and run a profiler against it.

Document what you needed to do to get it working. You'll pull these into your audit document, and the client will hopefully fix the issues or add the steps to a readme for new developers.

Leverage the compiler and other tools to populate your audit:

- Copy out the build warnings and errors.
  - Reporting the sheer number of them can dramatize the poor state of a project, or clarify how clean a project is.
- Run some analyzers on the codebase:
    - cloc: Can dump general file size info as a CSV, which you can then open
      in a spreadsheet program and sort, filter, etc:

          cloc \
            --exclude-dir build,Pods,Library \
            --by-file \
            --csv \
            --out proj-cloc.csv \
            .
    - [code-maat](https://github.com/adamtornhill/code-maat): This has many
      analyses based on a dump of project history from the VCS in a specified
      format. It can be used to find "busy" files (many authors, frequently
      edited) or coupled files (often changed together by a commit).
    - clang static analyzer: Can find logic errors in an Obj/C/++ project.
        - Run this via Xcode, most likely.
    - code complexity analyzer:
        - [Flog for Ruby](http://ruby.sadi.st/Flog.html) (content warning on the homepage!)
    - linter: Some of these are liable to report mostly style violations,
      rather than juicy goodness, but even those can still help you populate
      that section and can hint at the familiarity of the team with best
      practices. Examples:
        - [SwiftLint](https://github.com/realm/SwiftLint)
        - [RxLint](https://bitbucket.org/littlerobots/rxlint/)
        - [ktlint](https://ktlint.github.io/)
        - [ErrorProne for Java](https://errorprone.info/)
        - [FauxPas for Obj-C](http://fauxpasapp.com/) (see 1Password for license)
        - [ESLint for JavaScript](https://eslint.org/)
        - [Rubocop for Ruby](https://rubocop.readthedocs.io/) - general linter including security and code complexity checks
        - [Brakeman for Ruby](https://brakemanscanner.org/) - vulnerability scanner
    - code coverage: Reports which lines (and percentage) are covered by
      automated tests. A high score doesn't mean they're *good* tests, but
      a low score means there is *untested* code.
        - [Istanbul for JavaScript](https://istanbul.js.org/)
        - [SimpleCov for Ruby](https://github.com/colszowka/simplecov)
- Flip on ALL the compiler warnings (`-Wall` and `-Wextra`) and see if there
  are serious errors lurking.


### Surfing Around
This is where you get a general feel for the project.

#### Mine any version control history

- Do you see recurring problems, i.e., "Fixed this thing" 10 times for the same thing ("fixed" it, yup)?
- How many people have worked on the project (`git shortlog -ns`, maybe with a .mailmap file)?
- Are the commits huge or focussed? (`git log --stat` is handy here)
- Are the commit messages useful?
- Do they cross-reference an issue tracker?
- Are the commits stylish?
    - [Recommended syntax](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
    - [Why small commits are good](http://www.bignerdranch.com/blog/small-distinct-commits-say-you-care/)
    - [Way too much info on writing good commits](https://wiki.openstack.org/wiki/GitCommitMessages)


If you have a useful commit history, you can often come to a deeper
understanding of the code by looking at how it's grown over time. Read the log
in reverse to relive the story of the app's development. If the commits aren't
useful, you can still hope the project organization is. **code-maat** can help
in condensing this history into meaningful info about the project.

#### Survey the project

- Use a class browser
- Look at what happens at app launch; a lot of critical environmental stuff tends to get set up during startup, and understanding this will often ease understanding the rest of the application
- Look at how the code is organized into groups/folders
- Poke at any package manager they're using (CocoaPods, Carthage, Gems, NPM)


#### Survey third-party components
This "getting to know you" phase is a good time to survey their use of third-party code.

- Compile a list of components and their licenses
- Investigate if they're in compliance with those licenses (http://www.bignerdranch.com/blog/using-cocoapods-without-going-court/)
    - Watch out for Apache-2-licensed stuff: If modified, they need to have added a modification note at the top.
- Is it easy to tell what's a third-party component and what's a first-party component?
- Are there any unused components?
- Are there any obsolete components?
    - If so, are there substantive changes (security patches or bad bugs) that should motivate adoption ASAP, or are they OK to linger on their current version?
      - [bundler-audit for Ruby](https://github.com/rubysec/bundler-audit)


#### Start filling out your final audit document template!
After this, stop and write up what you have now, working off your logs. If you put it off any further, you'll find you have such a mass of things to type up that you never want to HEY WHAT'S NEW ON TWITTER?



### Targeted Investigation
I hope you wrote up your notes so far.
You won't be writing many more; instead, you'll want to write directly into the audit template.
You will want to open a TODO file to track issues you'd like to investigate later, but you'll make less work for yourself with targeted investigation by just writing the rough draft copy directly in place.

Go read the SOW. The client probably has specific areas of concern or questions they want answered. **Add or promote section headers for these focus areas, then start by investigating those.**

We probably also mentioned some typical areas we examine in the SOW.
Spread your effort around to start so you populate each section at least
somewhat, but if push comes to shove, prefer to hit the client's main focal
points hard.

> **Honest truth:** You should ask the client at the kick-off what
> they'd consider a successful audit, and deliver that, no matter what this
> document might say!

The audit template has tips on searches to run and issues to investigate for
each section, so that advice is not repeated here.


### Write the Summary
When you're all done, go back to the top of the audit.
Note what version you were examining and when it was committed.
Write up a high-level summary of what you were tasked to investigate and your general read of the state of the project.
Call out any serious issues that they should fix ASAP;
by this point, you likely have 10 pages or more of document,
and clients will appreciate knowing where to look.



### Document Delivery & Debriefing
When you're all done, post the document on Basecamp for feedback.
Wait a day, do a final readthrough and edit yourself,
and then shoot it on over to the client.

They'll likely want to meet with you to talk it over.
They'll want you to emphasize the highlights
amongst all the many issues you found
and give them hints on the way to move forward.

Be prepared for them to ask,
"How do you address this problem in your BNR projects?"
If you don't know, ask around ahead of time:
Make [Slack](https://bignerdranch.slack.com/) your friend.
