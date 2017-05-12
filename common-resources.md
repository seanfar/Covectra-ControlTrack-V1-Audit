# Common Audit Resources
Code bases tend to go wrong in common ways.
Provide a short, tailored summary of the issue in your audit,
but don't hesitate to link to a longer discussion.

The links below are to resources we've recommended multiple times across
multiple audits.


## Git
- [Writing a syntactically correct commit message](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
- [Write a useful commit message, and why you should care – includes pictures](http://chris.beams.io/posts/git-commit/)
- [Writing a useful commit message, in extremely verbose detail](https://wiki.openstack.org/wiki/GitCommitMessages)
- [More focused article by BNR on structuring commits](http://www.bignerdranch.com/blog/small-distinct-commits-say-you-care/)
- [Tagging releases](https://help.github.com/articles/about-releases/)


## Core Data
- [Why "one context per thread" is a bug-filled antipattern](http://saulmora.com/2013/09/15/why-contextforcurrentthread-doesn-t-work-in-magicalrecord/)
- [Why and how to connect your PSC to a PS on a background thread](http://martiancraft.com/blog/2015/03/core-data-stack/)


## Code Style
- [Organize your codebase by domain, not by useless MVC structure](http://www.sicpers.info/2014/03/inside-out-apps/)
- [Further info on why organizing by MVC (or similar non-domain system) is unhelpful](http://www.sicpers.info/2014/10/the-trouble-with-layers/)
- Robert "Uncle Bob" Martin expands on this point by emphasizing the primacy of an architecture created around use cases rather than frameworks in [Screaming Architecture](http://blog.8thlight.com/uncle-bob/2011/09/30/Screaming-Architecture.html)
- [Beware Massive View Controller](http://www.objc.io/issues/13-architecture/)
- [Naming guidelines for Obj-C](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CodingGuidelines/CodingGuidelines.html#//apple_ref/doc/uid/10000146-SW1)
    - Watch out especially for `getFoo` methods that are just accessors.
- [Write useful comments](https://www.bignerdranch.com/blog/considerate-commenting/)
- [Probably you shouldn't call NSUserDefaults.synchronize()](https://developer.apple.com/library/prerelease/content/releasenotes/Foundation/RN-Foundation-v10.10/index.html#10_10UserDefaults)
- [Avoiding Singleton Abuse](https://www.objc.io/issues/13-architecture/singletons/)


## Networking
- [Don't use reachability to decide whether to try a request, only to decide whether to retry](https://github.com/tewha/AFNetworking/blob/docs/improve-reachability/README.md#network-reachability-manager)
    - [discussion](https://github.com/AFNetworking/AFNetworking/issues/2701#issuecomment-99965186)
    - [further details](WWDC 2012 Session 706 (https://developer.apple.com/videos/play/wwdc2012/706/))


## Internationalization
- [Easy number localization using localizedStringWithFormat](http://www.objc.io/issues/9-strings/string-localization/#localized-format-strings)
- Date formatters are now thread-safe, yay!
- [How to rig up a date formatter for working with machine-parseable dates](https://developer.apple.com/library/content/qa/qa1480/)


## Third-Party Code
- [Licensing](https://www.bignerdranch.com/blog/using-cocoapods-without-going-court/)
- [CocoaPods docs on their Acknowledgements system](http://blog.cocoapods.org/Acknowledgements/)
    - GOTCHA: If the project doesn't have an independent LICENSE file, then there's nothing for CocoaPods to compile in here, so the project will NOT be in compliance in spite of adding the catenated acks file to their project resources. (This is a bit of a pain to investigate; we could probably automate it.)
    - GOTCHA: Watch out for transitive dependencies. Check out the Podfile.lock to see what all actually gets pulled in, not just the top-level stuff the project wants. **You need to look at all these components, not just the top-level ones.**
    - GOTCHA: Apache2 requires you carry over any NOTICES file, if present. **CocoaPods does not automate this AFAIK.**
