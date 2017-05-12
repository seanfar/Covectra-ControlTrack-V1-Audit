% $COMPANY $APP $VERSION $PLATFORM
% YYYY-MM
% Your Name Here <yournamehere@bignerdranch.com>

If you're auditing multiple things (example: iOS app and companion Mac app), you'll have H1s for each thing, and reproduce the sections within each major section. Otherwise, you can just list these directly.

Sections and advice follow.

# Summary

The version reviewed is version XXX corresponding to git commit hash XXX, committed by XXX on XXX.

XXX: High level summary, not numbered. Include overall feel, call out major points, especially anything that crosses several categories.

# Architecture

1.     XXX: Summarize and critique the app’s architecture. Does it make sense? Is it overly layered? Are there crazy dependencies that make it impossible to build? Or normal dependencies, but pulled in all crazy-like and modified so they’ll never be able to incorporate upstream changes? How do they handle logging? Is this thing debuggable? Can also be appropriate to tackle build-chain issues here – Treat Warnings as Errors, Build & Analyze, that sort of thing.

# Asynchrony
1.     XXX: How do they handle async operation across the app? Is it comprehensible, or all over the place? Can you tell the context any given code will be executed in? Good searches are dispatch_, Operation, async, completion. Also look at their use of Core Data – are they careful with the threading concerns? Make sure they’re not making the MagicalRecord mistake of stashing stuff in thread-specific storage. (Thread-specific storage is a bad idea in general now that we use queues for everything.)

# Error Handling

1.     XXX: Run a search for “error:nil” and “error:NULL” and friends, and see how many hits you get. Check out “error:” in general – what do they do when there’s an error?

# Documentation & Tests

1.     XXX: See if the tests run; if not, poke at the git history to see when they were broken. Did they include a useful README? Are there class-level doc comments? Are there component-level doc comments? Are there comments/docs explaining how the pieces fit together? Is there weird stuff that made you scratch your head that lacks explanation? Just writing up the stuff that made you pull your hair out as you tried to come to grips with the codebase goes a long way here. Include poor git commit style (bad messages or bloated kitchen sink changesets) in your review; that matters for git bisect in particular.

# Data Storage

1.     XXX: Run the app and look at the files it creates on disk. Poke around and see what info is stored – are they leaking private info? Are files stored in sane places, like cache files in /Library/Caches? Do they use the Keychain and user defaults sanely? iCloud? Are they using the file protection flags at all?

# Networking

1.     XXX: Look at how they do their networking, whether they do something funky with URL creation like interpolating strings without escaping, whether they’re using ancient NSURLConnection APIs, pipelining, etc.

# Memory & Performance

1.     XXX: Profile the app in Instruments and look for leaks and insane allocations for memory, hot spots (esp. those blocking the main queue) in Time Profiler. Search for NSDateFormatter and NSNumberFormatter; the former is especially expensive to create and recreate.

# Security

1.     XXX: Goes well with data storage and networking. Are they using HTTPS, are they stashing PII on disk in plaintext, are they letting users control URLs, things like that.

# Style

1.     XXX: Check the naming guidelines and other conventions used in Cocoa-land. Ditto for C++ if they have any of that. Many people are still writing very old-fashioned C++ code. Clang supports C++14, and there is a lot of advantage to be had from working with that; point them at Scott Meyers’ Effective Modern C++ if needed. (Smart pointers are generally a must to avoid leaks.)

# UI

1.     XXX: Anything busted, ugly, awful, likely to get them rejected, whatever. The amount of time you spend on this is often very dependent on the client’s wishes; they might not have a final UI yet. This is a good place to document crashes you ran into during performance testing though.

# Accessibility

1.     XXX: Poke around in Voice Over. Might not be a concern; if so, can just point out it needs some work and move on.

# Internationalization

1.     XXX: Check for use of NSLocalizedString, make sure they’re providing context in the comment arg so the localizer can tell what they’re localizing, watch out for plural issues in strings, make sure they’re using NSNumberFormatter and NSDateFormatter and NSByteCountFormatter. For NSDateFormatter, make sure they’re not setting the format directly, but instead using the format-from-template class method. Look out for art with embedded strings or art that embeds a culture or locale assumption, like a globe image centered on the Americas.

# Third-Party Components & License Compliance

1.     XXX: List all third-party components (and any third-party components they incorporate, etc.), summarize their purpose, and note their licenses.

2. XXX: Discuss whether and how they’re satisfying the license requirements. Verify that the variety of licenses they're probably using are compatible with each other and with App Store distribution.
Miscellaneous

1.     XXX: If you run into something that doesn’t belong elsewhere, but there’s not enough of it to add a new section, throw it here. If you end up with nothing here, then delete this section before publishing
