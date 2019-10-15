---
title: Audit of ControlTrack Application (Server)
author: Sean Farahdel, Big Nerd Ranch
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
    - \providecommand{\recommend}[1]{\addcontentsline{toc}{paragraph}{#1}\textbf{#1:}}
---

\newpage

# Scope
BNR reviewed the code for ControlTracks Backend code provided by Covectra.

The audit focused on a high level overview of the state of the application.

The particular scenarios driving this focus are what steps may be necessary to deliver a scalable, production-ready application.

The audit also evaluated the existing codebase's suitability for continued
development.


# Summary
Although the application is currently meant to serve as a proof of concept,
there are patterns (or lack thereof) observed which could lead to a highly unsustainable, unmaintainable, and error-prone codebase.
There were also frequent scenarios encountered which were degrading the integrity of the data. 

The much needed extensibility, which was communicated during the engagement, could be compromised due to these factors.
Implementing recommended techniques outlined below would significantly reduce and help mitigate these risks.


## Conclusions
Upon review of the aforementioned application, the recommendation would be a complete rewrite. Due to complexity and length of 
the codebase being relatively low and isolated at this point in time, a rewrite would be the most cost effective way to instill
a stable foundation in which to build and continue development on. 


The recommendations below are meant to serve as a set of guidelines to follow in either rebuilding or refactoring the application.


# Recommendations

1. \recommend{Resolve Lint Errors}
      Eslint: __2142__ problems (__408__ errors, _1734_ warnings)

      These are based on the eslint library which can have its level of strictness tweaked. Because of the nature of Javascript being an interpreted language, these errors/warnings may or may not manifest during runtime.
      - ie. Error for missing semicolons at the end of lines - but most runtimes do not strictly require these to properly terminate statements.


      These counts are only meant to serve as an approximate indicator for quality of code. Would still recommend a thorough audit and fixes where appropriate. 


    *Complexity:* Low.

1. \recommend{Utilize ORM to update related records}

    In almost all cases, the application is relying on the client (iOS app) to send relational identifiers (for parent/child records). Client should only send __necessary__ data, allowing the applications ORM to fetch related data to perform cascading create, update, and delete operations.

    *Complexity:* Medium.

1. \recommend{Move business logic to server}

    Client code is performing most logical operations and sending updated data to server. Example of this would be on patients dose verification. Business logic should be, where possible, moved to the server. This centralizes the code and reduces the amount of logic each client will have to replicate (Android, IOS, Web, etc.), while also reducing the risk of data integrity being compromised.

    *Complexity:* Medium.

1. \recommend{Add automated testing}

    Would strongly recommend writing integration tests to test controller actions, as well as unit tests to test isolated/abstracted methods. Automated testing allows us to gain better insight into functionality as well as protect against future changes having unintended side-effects, which could break implementation(s).

    *Complexity:* Medium.

1. \recommend{Update logging}

    Code currently has log statements (sails.log) consistently sprinkled throughout business logic, including within conditional checks which are responsible for nothing other than to log - these are wasted operations.
      - ie. **File**: `api/controllers/PatientController.js` **Line**: 217

    Logging should follow proper logging practices, which involves moving the related code to a middleware.

    *Complexity:* Medium.

    _Note_: This is set to medium not because of the logging being moved to a middleware, but because the rest of the application code contains a large amount of log statements which require consideration and effort during implementation.

1. \recommend{Abstract logic in controllers}

    Currently, controller actions contain __all__ of the logic inside of them. This pattern is highly discouraged, and even alluded to in the official documentation for the utilized framework (SailsJS). Moving these to helpers, model methods, and middlewares would reduce replication and increase testability and maintainability of common functionality.

    *Complexity:* Medium.

1. \recommend{Refactor controller actions to `action2` syntax}

    Actions are currently written in the “classic” syntax, the recommended format is to use the SailsJS `action2` format. This is outlined as the proper approach in the official documentation for SailsJS. This would help maintainability moving forward with respect to using the SailsJS framework, in case the classic syntax is deprecated in future releases.

    *Complexity:* Medium.

1. \recommend{Add model/attribute validations}

    The application is using a 3rd party validation library called __Joi__ to validate request and model payloads.
    SailsJS has built in validation functionality, at both the controller and model level, the application should make use of these to consolidate logic and reduce external dependencies.

    *Complexity:* Medium.

1. \recommend{Fix data types for model attributes}

    Observed the model attributes using inconsistent and often _wrong_ data types for certain columns.
    Attributes relating to tab counts (dailyDose, totalTabs) are being stored as string types, these should be numbers.
    Certain timestamp columns being stored as a string in ISO format
      - _Note_: Waterline does not provide a `datetime` attribute/column type, recommended to be stored as a unix epoch (NUMBER/INTEGER)


    *Complexity:* Low.

1. \recommend{Utilize model lifecycle callbacks}

    App has some functionality that could be refactored to  make use of the built in model lifecycle callbacks. An example of this would be creating an Audit record after a prescription (Rx) record is updated. 

    The `afterUpdate` callback on Rx would fit this particular use case. This would reduce the risk of human error, removing the redundancy of having to create an audit record manually on every update of prescription.

    *Complexity:* Medium.

1. \recommend{Utilize application policies}

    For authorization and authentication, SailsJS exposes `Policies` for implementation of common functionality regarding the auth state of a user. The app is properly utilizing the `isLoggedIn` policy to verify a user has a valid authentication token, but in all other cases surrounding verifying the role of the user to be either a physician, pharmacist, or patient, the controllers have hard coded these conditional checks to allow or disallow certain resources from being exposed. This approach is highly discouraged as it could lead to inconsistency due to human error.

    Moving these to an abstracted policy middleware would allow the logic to "live" in one place, practically removing the potential for errors if properly maintained and tested.

    *Complexity:* Medium.



\newpage

## Architecture
1. This application utilized the SailsJS framework for server-side implementation and a MySQL database. SailsJS is relatively new MVC framework which comes complete with the server engine (express), an ORM (waterline) and a view engine (EJS).
MySQL is a transactional SQL database engine developed and maintained by Oracle. The application is deployed using Google Cloud Platform (GCP) and most procedures observed here were implemented properly. 

2. The application code itself was without proper organization, which led to many of the recommendations above. Currently, the written code is monolithic and top down in its approach. The lack of proper patterns observed are highly unsustainable and should be addressed thoroughly before it is deployed to a production environment.


## Error Handling
1. The codebase had frequently wrapped code blocks in `try/catch` statements with no propagation of the error(s) to a logging mechanism.  Google cloud platform has this baked into their platform, but because most of the errors are being caught at the application layer, this functionality was unusable. For server side code, the recommended practice is to not only respond to the HTTP request with and appropriate status code and body, but to also raise the error in the respective runtime for investigation and subsequent remediation.


## Documentation & Tests
1. Limited documentation found in the README of the repository. As outlined above, there were no tests observed when starting the engagement. A handful of tests were added to allow for rapid iteration during time on project.


## Security
In most cases, proper protocol was followed here. Found hashed and salted passwords, HTTPS was utilized, and connection to the database was done using an SSL certificate. 


## Third-Party Components & License Compliance
The app is using NPM (Node Package Manager) to integrate third-party components.
For a list of components,
see [Appendix A: Tables of Third-Party Components](#appendix-a)

\newpage


# Appendix A: Tables of Third-Party Components  {#appendix-a}
## Components Managed by Node Package Manager (NPM)
The third-party components managed by NPM are:

Table: Direct NPM Dependencies

| **Dependency** | **Version** | **License** | **Type** 
| -------------- | ----------- | ----------- | -------- 
| @google-cloud/storage     | 1.7.0 | Apache-2.0 | production |
| @sailshq/connect-redis    | 3.2.1 | MIT | production |
| @sailshq/lodash           | 3.10.3 | MIT | production |
| @sailshq/socket.io-redis  | 5.2.0 | MIT | production |
| @sailshq/upgrade          | 1.0.9 | SEE LICENSE IN LICENSE | production |
| ajv                       | 6.10.0 | MIT | production |
| async                     | 2.0.1 | MIT | production |
| aws-sdk                   | 2.448.0 | Apache-2.0 | production |
| bcrypt                    | 2.0.1 | MIT | production |
| firebase-admin            | 5.13.1 | Apache-2.0 | production |
| generate-password         | 1.4.1 | MIT | production |
| grunt                     | 1.0.4 | MIT | production |
| joi                       | 13.7.0 | BSD-3-Clause | production |
| jsonwebtoken              | 8.5.1 | MIT | production |
| lodash                    | 4.17.11 | MIT | production |
| lusca                     | 1.6.1 | UNLICENSED | production |
| moment                    | 2.24.0 | MIT | production |
| moment-timezone           | 0.5.25 | MIT | production |
| multer                    | 1.4.1 | MIT | production |
| pm2                       | 2.10.4 | AGPL-3.0 | production |
| sails                     | 1.1.0 | MIT | production |
| sails-hook-grunt          | 3.1.0 | MIT | production |
| sails-hook-orm            | 2.1.1 | MIT | production |
| sails-hook-sockets        | 1.5.5 | MIT | production |
| sails-mysql               | 1.0.1 | MIT | production |
| serve-static              | 1.13.2 | MIT | production |
| sshpk                     | 1.16.1 | MIT | production |
| @sailshq/eslint           | 4.19.3 | MIT | dev |
