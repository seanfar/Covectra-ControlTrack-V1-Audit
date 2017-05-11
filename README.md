# Big Nerd Ranch Technical Audit Starting Point

[This repository](https://github.com/bignerdranch/tech-audit-starting-point)
contains:

- An intro to doing code audits at BNR, including what they are and the various
  reasons we do them
- A template and toolchain for producing a polished audit document as your
  final deliverable without giving up the ability to meaningfully version
  control the work in progress

This [content started on NerdNet](https://sites.google.com/a/bignerdranch.com/nerdnet/history/ios-mac-history/technical-audits).
When it became clear we have a reusable toolchain and template,
the content moved to this repo.


## Getting Started

- **Create a new repo under the `bignerdranch` organization for your audit.**
  Say you're auditing version 3 of an iOS app named "I'm So Appy" for BigCorp.
  Then you might fork the repo to `bignerdranch/audit-ios-bigcorp-im-so-appy-v3`.

- **Clone this repo, then aim the `origin` remote at your audit's repo.**
  This'll look something like:

  ```
  AUDIT_DIR="audit-ios-bigcorp-im-so-appy-v3"
  git clone git@github.com:bignerdranch/tech-audit-starting-point.git "$AUDIT_DIR"
  cd "$AUDIT_DIR"
  git remote set-url origin "git@github.com:bignerdranch/$AUDIT_DIR.git"
  git push -u origin
  ```

- **Ensure you have the toolchain prereqs installed.**
  We use Pandoc to handle the Markdown (with interspersed LaTeX)
  and XeLaTeX to generate the final PDFs. If you don't have either, relax:
  Just run XXX to install them, and you'll be on your way in no time!

  Not sure if you have everything installed?
  Skip to the next step, and if it all works, you're golden!

- **Run the toolchain on the blank template document.**
  This is a smoke test.
  All good? All good!
  Not all good? File an issue and then ask for help on Slack!
