---
title: Audit of XXXNAMEXXX Application
author: XXXYour NameXXX, Big Nerd Ranch
geometry: margin=1in,bottom=2in
toc: true
toc-depth: 5
include-before:
    - \newpage
header-includes:
    - \usepackage{wallpaper}
    - \usepackage{xcolor}
    - \usepackage{sectsty}
    - \definecolor{Slate}{HTML/cmyk}{505153/0.258,0.227,0.216,0.129}
    - \definecolor{Coral}{HTML}{ED6B45}
    - \sectionfont{\color{Slate}}
    - \subsectionfont{\color{Slate}}
    - \subsubsectionfont{\color{Slate}}
    - \LLCornerWallPaper{1}{FooterStandard.png}
    - \color{Slate}
    - \usepackage{fontspec,xltxtra,xunicode}
    - \defaultfontfeatures{Mapping=tex-text}
    - \setromanfont[Mapping=tex-text]{Helvetica Neue}
    - \setsansfont[Scale=MatchLowercase,Mapping=tex-text]{Futura}
    - \setmonofont[Scale=MatchLowercase]{Menlo}
    - \setcounter{secnumdepth}{3}
    - \providecommand{\recommend}[1]{\addcontentsline{toc}{paragraph}{#1}#1}
---

\newpage

# Scope
BNR reviewed the code for XXX provided by XXX.

The audit focused on…

The particular scenarios driving this focus are…

The audit also evaluated the existing codebase's suitability for continued
development.

Not in scope were…


# Summary
XXX: High level summary, not numbered. Include overall feel, call out major points, especially anything that crosses several categories.
You can use H2s here if that helps communicate.


## Conclusions
XXX: Conclude with recommendations directly addressing the audit's focuses.




# Recommendations
## META: DELETE ME: About the format
There's some \LaTeX\ hackery going on to inject the recommendations in each
section into the Table of Contents and, especially, into the PDF Table of
Contents as a jump point, without needing to structure them all as
sub-sub-sub-sections.

The overall document structure is mostly Jeremy Sherman's work.
The \LaTeX\ toolchain and most of the header is John Gallagher's work.
Jeremy went through and tweaked it to maximize the value of the
Table of Contents by turning it into a short todo-list,
as well as adjusting fonts and colors to match the latest
[BNR Style Guide](https://sites.google.com/a/bignerdranch.com/brand-style-guide/)
as of February 2017.
This capsule history is provided so you have an idea of who to bug on Slack
with questions.

There's a strategy of easing machine processing that goes into where the
linebreaks end up.
You want to ensure the recommendation and the associated complexity
end up on lines of their own, so they're easy to pick out.
That turns this into a "semi-structured" document, and we can exploit that
to dump a starting point CSV for estimating the changes like so:

```
read -d '' BUILD_CSV_AWK <<'EOT'
/^#.*/{
  section = $2
}

/recommend/{
  a = index($0, "{");
  b = index($0, "}");
  recommendation = substr($0, a+1, b-a-1);
}

/Complexity:/{
  complexity = $2;
  printf "%s,%s,%s\\n", section, recommendation, complexity
}
EOT
echo "Section,Recommendation,Complexity" >recommendations.csv
egrep '^(#|1\.| *\*Complexity:\*)' audit.md \
  | awk "$BUILD_CSV_AWK" \
  >> recommendations.csv
```

Just copy-paste this recommendation syntax, and you'll be fine:

1. **\recommend{Do this thing}:**
    Notice:

    - Newline at end of bolded section to facilitate munging your document
      with awk - this makes importing your recommendations into an estimation
      spreadsheet as CSV way easier!
    - The colon is outside the `\recommend` macro arguments, to avoid including
      a bunch of weird colons in the Table of Contents
    - You can **always use `1.`** as the intro. Markdown will renumber them
      for you automatically. This makes reordering recommendations by priority
      within a section really painless, even if done after everything is all
      written up.

    You can have multiple paragraphs in here. Just keep 'em indented to match
    the start of the text above.

    Then we'll have a newline, and the closing complexity estimate.
    This also makes producing an estimate a lot easier, and even if you
    don't have to do an estimate, it helps the recipient understand how hard
    it'd be to implement some advice.
    (The low hanging fruit really stands out.)

    *Complexity:* Medium.

1. **\recommend{Use the imperative}:**
    Recommendations should say, "Do something!"

    I'm also writing this so you can see what multiple entries in a section
    looks like, though.

    Also, here's the list of complexities I tend to use:

    - None
    - Low
    - Medium
    - High
    - Very High

    This tends to be a mix of "how big is it" and "how well-known is it".
    If I know you should do something, but what that means in practice isn't
    clear, then the complexity goes up.

    *Complexity:* Low.

    Sometimes it's useful to explain your complexity evaluation in a follow-up
    paragraph, like so. This recommendation is low complexity,
    because picking from a list and using the imperative mood
    aren't terribly demanding tasks.


## Architecture
1.     XXX: Summarize and critique the app’s architecture. Does it make sense? Is it overly layered? Are there crazy dependencies that make it impossible to build? Or normal dependencies, but pulled in all crazy-like and modified so they’ll never be able to incorporate upstream changes? How do they handle logging? Is this thing debuggable? Can also be appropriate to tackle build-chain issues here – Treat Warnings as Errors, Build & Analyze, that sort of thing.


## Asynchrony
1.     XXX: How do they handle async operation across the app? Is it comprehensible, or all over the place? Can you tell the context any given code will be executed in? Good searches are dispatch_, Operation, async, completion. Also look at their use of Core Data – are they careful with the threading concerns? Make sure they’re not making the MagicalRecord mistake of stashing stuff in thread-specific storage. (Thread-specific storage is a bad idea in general now that we use queues for everything.)


## Error Handling
1.     XXX: Run a search for “error:nil” and “error:NULL” and friends, and see how many hits you get. Check out “error:” in general – what do they do when there’s an error?


## Documentation & Tests
1.     XXX: See if the tests run; if not, poke at the git history to see when they were broken. Did they include a useful README? Are there class-level doc comments? Are there component-level doc comments? Are there comments/docs explaining how the pieces fit together? Is there weird stuff that made you scratch your head that lacks explanation? Just writing up the stuff that made you pull your hair out as you tried to come to grips with the codebase goes a long way here. Include poor git commit style (bad messages or bloated kitchen sink changesets) in your review; that matters for git bisect in particular.


## Data Storage
1.     XXX: Run the app and look at the files it creates on disk. Poke around and see what info is stored – are they leaking private info? Are files stored in sane places, like cache files in /Library/Caches? Do they use the Keychain and user defaults sanely? iCloud? Are they using the file protection flags at all?


## Networking
1.     XXX: Look at how they do their networking, whether they do something funky with URL creation like interpolating strings without escaping, whether they’re using ancient NSURLConnection APIs, pipelining, etc.


## Memory & Performance
1.     XXX: Profile the app in Instruments and look for leaks and insane allocations for memory, hot spots (esp. those blocking the main queue) in Time Profiler. Search for NSDateFormatter and NSNumberFormatter; the former is especially expensive to create and recreate.


## Security
1.     XXX: Goes well with data storage and networking. Are they using HTTPS, are they stashing PII on disk in plaintext, are they letting users control URLs, things like that.


## Style
1.     XXX: Check the naming guidelines and other conventions used in Cocoa-land. Ditto for C++ if they have any of that. Many people are still writing very old-fashioned C++ code. Clang supports C++14, and there is a lot of advantage to be had from working with that; point them at Scott Meyers’ Effective Modern C++ if needed. (Smart pointers are generally a must to avoid leaks.)


## UI
1.     XXX: Anything busted, ugly, awful, likely to get them rejected, whatever. The amount of time you spend on this is often very dependent on the client’s wishes; they might not have a final UI yet. This is a good place to document crashes you ran into during performance testing though.


## Accessibility
1.     XXX: Poke around in Voice Over. Might not be a concern; if so, can just point out it needs some work and move on.


## Internationalization
1.     XXX: Check for use of NSLocalizedString, make sure they’re providing context in the comment arg so the localizer can tell what they’re localizing, watch out for plural issues in strings, make sure they’re using NSNumberFormatter and NSDateFormatter and NSByteCountFormatter. For NSDateFormatter, make sure they’re not setting the format directly, but instead using the format-from-template class method. Look out for art with embedded strings or art that embeds a culture or locale assumption, like a globe image centered on the Americas.


## Third-Party Components & License Compliance
The app is using XXX to integrate most third-party components, but
several remain in the XXX directory.
For a list of components,
see [Appendix A: Tables of Third-Party Components](#appendix-a)

1. XXX: Provide actionable advice here, as elsewhere.
1.     XXX: List all third-party components (and any third-party components they incorporate, etc.), summarize their purpose, and note their licenses.

2. XXX: Discuss whether and how they’re satisfying the license requirements. Verify that the variety of licenses they're probably using are compatible with each other and with App Store distribution.

1. **Consolidate component management using CocoaPods:**
    It is recommended to use a single approach to managing third-party
    components for simplicity of management. Most components are added via
    CocoaPods, thus it's recommended to consolidate component management using
    CocoaPods. A review of the components manually added to the project shows
    that this is eminently practicable.

    *Complexity:* Medium.

    This should be relatively straightforward, but dependency
    management can be a bit of a pain. Vendoring helps a lot here.
1. **Continue vendoring dependencies:**
    The project is already vendoring its dependencies, that is, bundling all
    vendor-provided components with the app source code.
    The component manager is only needed when altering the components used, not
    when performing regular builds.

    This is excellent:
    It ensures reproducible builds and simplifies on-boarding, because a
    `git clone` is all that is needed to build the project.

    *Complexity:* None.
1. **Don't fight CocoaPods when modifying your dependencies:**
    The project has been relying on manually patching files resolved by the
    dependency manager for SwiftyJSON in order to work around a
    [memory leak issue](https://github.com/SwiftyJSON/SwiftyJSON/issues/323).
    That patching addresses an issue fixed in Xcode 7.1 beta 2, so there is no
    need to remain pinned to the version or continue patching.

    That said, you might encounter a similar problem in future.

    Let's pretend you did still need to patch the upstream SwiftJSON component:
    Every time the component manager is used to update SwiftyJSON, the team
    must remember to manually patch it again. This is fragile, because it
    relies on human memory, and so the team has pinned SwiftyJSON at a specific
    version rather than continuing to update it.

    Instead, automate the patching in a way that the component manager
    works with out of the box:

    - Use a
   [`post_install` hook](https://guides.cocoapods.org/syntax/podfile.html#post_install)
    to ensure the patch is applied every time a new version is installed.
    - Depend on a fork with the fixes already applied.

    The post-install hook is far preferable. Forking an upstream project
    forgoes many of the benefits of using CocoaPods in the first place,
    such as easily checking for updates and applying them.
    (Note these are the same benefits
    lost by pinning to a specific version in the `Podfile`.)

    Forking an upstream project is appropriate as a way to upstream the patch
    via a pull request to them, but you would want the app to continue to
    depend on the upstream directly and apply the patch via the post-install
    hook.

    *Complexity:* None.

    The one case where you needed this should no longer be a problem.
    This is primarily informational.



## Miscellaneous
1.     XXX: If you run into something that doesn’t belong elsewhere, but there’s not enough of it to add a new section, throw it here. If you end up with nothing here, then delete this section before publishing


# Appendix A: Tables of Third-Party Components  {#appendix-a}
## Components Managed Manually
The third-party components not managed by CocoaPods are:

Table: Third-Party Components Not Managed by CocoaPods

| Component             | Version    | Latest     | License    | Location                             |
|-----------------------|------------|------------|------------|--------------------------------------|
| Dynatrace             | 6.5.0.1289 | 6.5.7.1500 | Commercial | ThirdParty/Dynatrace/                |
| KAStatusBar           | Unknown    | 0.1        | Apache 2   | mFind/Library/KAStatusBar/           |
| SWRevealTableViewCell | 0.3.5      | 0.3.5      | MIT        | mFind/Library/SWRevealTableViewCell/ |

   Where available via CocoaPods, it is recommended to move to integrating the
   dependency via CocoaPods. In this case, all of these are available as
   CocoaPods.

   Using CocoaPods would also ensure that information about the version used
   is retain. Because the files themselves lack that info for KAStatusBar,
   and no other effort appears to have been made to track the
   version integrated, it is not straightforward to locate the version
   of those dependencie that was originally pulled into the project.


## Components Managed by CocoaPods
The third-party components managed by CocoaPods are:

Table: Direct CocoaPod Dependencies

| Component         | Version         | Latest | License    |
|-------------------|-----------------|--------|------------|
| SwiftyJSON        | 2.3.2 (patched) | 3.1.4  | MIT        |
| ReachabilitySwift | 2.3.3           | 3      | MIT        |
| XMLDictionary     | 1.4             | 1.4.1  | zlib       |
| NHNetworkTime     | 1.7             | ---    | Apache 2   |
| SwiftLint         | 0.16.0          | 0.16.1 | MIT        |
| EZSwipeController | 0.4             | 0.6.1  | MIT        |
| Firebase          | 3.7.1           | 3.11.1 | Commercial |
| Pushwoosh         | 4.0.10          | 5.0.1  | MIT        |

The CocoaPod components directly used by the app also pull in a few other third-party components:

Table: Indirect CocoaPod Dependencies

| Component         | Due To  | Version | Latest         |
|-------------------|---------|---------|----------------|
| CocoaAsyncSocket  | NHNetworkTime | 7.5.0 | 7.5.1 |
| GoogleNetworkingUtilities | Firebase | 1.2.2 | --- |
| GoogleInterchangeUtilities | Firebase | 1.2.2 | --- |
| GoogleSymbolUtilities | Firebase | 1.1.2 | --- |
| GoogleUtilities | Firebase | 1.3.2 | --- |

