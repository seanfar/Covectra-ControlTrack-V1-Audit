# Big Nerd Ranch Technical Audit Starting Point

[This repository](https://github.com/bignerdranch/tech-audit-starting-point)
contains:

- An [intro to doing code audits at BNR](intro.md), including what they are and the various
  reasons we do them
- [Resources](common-resources.md) relevant to common problems we encounter in audits.
  If someone's Doing It Wrong, these blog posts can probably explain why
  and what it looks like to Do It Right.
- A template and toolchain for producing a polished audit document as your
  final deliverable without giving up the ability to meaningfully version
  control the work in progress

This [content started on NerdNet](https://sites.google.com/a/bignerdranch.com/nerdnet/history/ios-mac-history/technical-audits).
When it became clear we have a reusable toolchain and template,
the content moved to this repo.

The old page continues to host links to several past audits
of various styles; much that we learned through performing those audits
is baked into the current guidelines and template.


## Getting Started
### Stand Up Your Audit Repo
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

### Install Dependencies
You only need to do this one time for your user account on a given machine.

We use Pandoc to handle the Markdown (with interspersed LaTeX)
and XeLaTeX to generate the final PDFs. If you don't have either, relax:

- **Install a TeX System:**
  You have two choices,
  the 2-gig [MacTeX][] or the spartan 110 MB [BasicTeX][].
- **Notify Your Shell:**
  Start a new shell, or stick `/Library/TeX/texbin` on your `PATH`.
- **BasicTeX: Add missing packages:**
  If you went with BasicTeX, you'll need a few more packages:

  ```
  sudo tlmgr update --self
  sudo tlmgr install wallpaper sectsty lm-math
  ```
- **Install Pandoc:**
  `brew install pandoc` if you don't already have it.
- **Run the toolchain on the blank template document:**

  ```
  make
  ```

  This is a smoke test.
  All good? All good!
  Not all good? File an issue and then ask for help on Slack!

  [BasicTeX]: https://www.tug.org/mactex/morepackages.html
  [MacTeX]: https://www.tug.org/mactex/


### Regular Usage
- **`make`:**
  Run `make` to build `audit.pdf` from `audit.md`.

You'll probably need to close and re-open the PDF in Preview to see your
changes.
You can do `make && open audit.pdf`, but you'll still have to close the file
manually, I think, for Preview to notice the changes.
