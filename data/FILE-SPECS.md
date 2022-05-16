# Specifications of data files

## [survey.csv](survey.csv)

<!-- "Timestamp" -->
- `Timestamp`: the datetime when the participant answered the questions
  * datetime, e.g., 2022/03/31 10:58:33 AM GMT-3
  * acronym: timestamp

<!-- "Have.you.ever.used.any.Quantum.Programming.Language." -->
- `Have you ever used any Quantum Programming Language?`: Identify if the participant worked with QPL and are able to answer the rest of the survey 
  * factor, i.e., Yes; No;
  * acronym: used_qpl

<!-- "What.is.your.age." -->
- `What is your age?`: the age of the participant
  * numerical, i.e., Under 18 years old; 18-24 years old; 25-34 years old; 35-44 years old; 45-54 years old; 55-64 years old; 65 years or older; Prefer not to say;
  * acronym: age

<!-- "Where.do.you.live...Country." -->
- `Where do you live? (Country)`: the name of the country where the participant lives
  * factor, e.g., Brazil; Portugal; ...
  * acronym: country

<!-- "Which.of.the.following.describe.you." -->
- `Which of the following describe you?`: gender of the participant
  * factor, i.e., Man; Woman; Non-binary ,genderqueer, or gender non-conforming; Prefer not to say; Other;
  * acronym: gender

<!-- "How.many.years.have.you.been.coding." -->
- `How many years have you been coding?`: experience of the participants in terms of coding
  * factor, i.e., Less than 1 year; 1 to 4 years; 5 to 9 years; 10 to 14 years; 15 to 19 years; 20 to 24 years; 25 to 29 years; 30 to 34 years; 35 to 39 years; 40 to 44 years; 45 to 49 years; More than 50 years;
  * acronym: years_coding

<!-- "How.many.years.have.you.coded.𝐩𝐫𝐨𝐟𝐞𝐬𝐬𝐢𝐨𝐧𝐚𝐥𝐥𝐲..as.a.part.of.your.work.." -->
- `How many years have you coded professionally (as a part of your work)?`: professional experience of the participants in terms of coding
  * factor, i.e., Less than 1 year; 1 to 4 years; 5 to 9 years; 10 to 14 years; 15 to 19 years; 20 to 24 years; 25 to 29 years; 30 to 34 years; 35 to 39 years; 40 to 44 years; 45 to 49 years; More than 50 years;
  * acronym: years_coded_professionally

<!-- "How.did.you.learn.to.code..Select.all.that.apply." -->
- `How did you learn to code? Select all that apply.`: how the participants learned to code
  * factor, e.g., Books / Physical media; Coding Bootcamp; Colleague; Friend or family member; Online Courses or Certification; Online Forum; Other online resources (videos, blogs, etc); School; Other; ...
  * acronym: learned_code

<!-- "What.are.the.most.used.programming..scripting..and.markup.languages.have.you.used..Select.all.that.apply." -->
- `What are the most used programming, scripting, and markup languages have you used? Select all that apply.`: languages that the participant have used
  * factor, e.g., Assembly; Bash C; Classic Visual Basic; COBOL C++; C#; Delphi/Object Pascal; Fortran; F#; Go; Groovy; Haskell; Java; JavaScrpit; Julia; Lisp; Matlab; ML; Objective-C; Pascal; Perl; pGCL; PHP; PowerShell; Prolog; Python; Ruby; SQL; Standard ML; Swift; Visual Basic; Visual C++; Other; ...
  * acronym: used_programming_language

<!-- "What.is.your.level.of.knowledge.in.Quantum.Physics.." -->
- `What is your level of knowledge in Quantum Physics?`: level of education in terms of knowledge in quantum physics
  * factor, i.e., 0 (no knowledge); 1 (novice); 2; 3; 4; 5 (expert);
  * acronym: level_quantum_physics

<!-- "Where.did.you.learn.Quantum.Physics." -->
- `Where did you learn Quantum Physics?`: education of the participants in terms of learning quantum physics
  * factor, e.g., Books; Online Course; Search Sites; University; Work; Other; ...
  * acronym: learned_quantum_physics

<!-- "Which.of.the.following.best.describes.the.highest.level.of.education.that.you.have.completed.." -->
- `Which of the following best describes the highest level of education that you have completed?`: formal education of the participants
  * factor, i.e., Primary/elementary school; Secondary school (e.g. American high school, German Realschule or Gymnasium, etc.); Some college/university study without earning a degree; Associate degree (A.A., A.S., etc.); Bachelor’s degree (B.A., B.S., B.Eng., etc.); Master’s degree (M.A., M.S., M.Eng., MBA, etc.); Professional degree (JD, MD, etc.); Other doctoral degree (Ph.D., Ed.D., etc.); Other;
  * acronym: level_education

<!-- "If.you.have.completed.a.major..what.is.the.subject." -->
- `If you have completed a major, what is the subject?`: work field of the participants
  * factor, e.g., Art / Humanities; Computer Science; Economics; Software Engineering; Math; Other Engineering; Physics; Social Sciences; Other; ...
  * acronym: major

<!-- "Which.of.the.following.describes.your.current.job..Please.select.all.that.apply." -->
- `Which of the following describes your current job? Please select all that apply.`: current job of the participants
  * factor, e.g., Academic researcher; Architect; Business Analyst; CIO / CEO / CTO; DBA (Database Administrator); Data Analyst / Data Engineer/ Data Scientist; Developer Advocate; Developer / Programmer / Software Engineer; DevOps Engineer / Infrastructure Developer; Instructor / Teacher / Tutor; Marketing Manager; Product Manager; Project Manager; Scientist / Researcher; Student; Systems Analyst; Team Lead; Technical Support; Technical Writer; Tester / QA Engineer; UX / UI Designer; Other; ...
  * acronym: job

<!-- "Where.and.how.did.you.learn.𝐐𝐮𝐚𝐧𝐭𝐮𝐦.𝐏𝐫𝐨𝐠𝐫𝐚𝐦𝐦𝐢𝐧𝐠.𝐋𝐚𝐧𝐠𝐮𝐚𝐠𝐞𝐬." -->
- `Where and how did you learn Quantum Programming Languages?`: education of the participants in terms of learning quantum programming languages
  * factor, e.g., Books; Language documentation; University; Online Course; Online Forums; Search Sites; Work; Other; ...
  * acronym: learned_qpl

<!-- "How.many.years.have.you.been.coding.using.𝐐𝐮𝐚𝐧𝐭𝐮𝐦.𝐏𝐫𝐨𝐠𝐫𝐚𝐦𝐦𝐢𝐧𝐠.𝐋𝐚𝐧𝐠𝐮𝐚𝐠𝐞𝐬." -->
- `How many years have you been coding using Quantum Programming Languages?`: experience of the participants in terms of using QPLs
  * factor, i.e., Less than 1 year; 1 to 4 years; 5 to 9 years; 10 to 14 years; 15 to 19 years; 20 to 24 years; 25 to 29 years; 30 to 34 years; 35 to 39 years; 40 to 44 years; 45 to 49 years; More than 50 years;
  * acronym: years_coded_qpls

<!-- "How.many.years.have.you.coded.𝐩𝐫𝐨𝐟𝐞𝐬𝐬𝐢𝐨𝐧𝐚𝐥𝐥𝐲.using.𝐐𝐮𝐚𝐧𝐭𝐮𝐦.𝐏𝐫𝐨𝐠𝐫𝐚𝐦𝐦𝐢𝐧𝐠.𝐋𝐚𝐧𝐠𝐮𝐚𝐠𝐞𝐬..as.a.part.of.your.work.." -->
- `How many years have you coded professionally using Quantum Programming Languages (as a part of your work)?`: professional experience of the participants regarding QPLs
  * factor, i.e., Less than 1 year; 1 to 4 years; 5 to 9 years; 10 to 14 years; 15 to 19 years; 20 to 24 years; 25 to 29 years; 30 to 34 years; 35 to 39 years; 40 to 44 years; 45 to 49 years; More than 50 years;
  * acronym: years_coded_professionally_qpls

<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Blackbird." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Braket.SDK." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Cirq." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Cove." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...cQASM." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...CQP..Communication.Quantum.Processes.." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...cQPL." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Forest." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Ket." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...LanQ." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...𝐿𝐼𝑄𝑈𝑖..." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...NDQFP." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...NDQJava." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Ocean.Software." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...OpenQASM." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Orquestra." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...ProjectQ." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Q.Language." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QASM..Quantum.Macro.Assembler.." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QCL..Quantum.Computation.Language.." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QDK..Quantum.Development.Kit.." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QHAL." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Qiskit." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...qGCL." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QHaskell." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QML." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QPAlg..Quantum.Process.Algebra.." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QPL.and.QFC." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QSEL." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QuaFL..DSL.for.quantum.programming.." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Quil." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Quipper." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Q.." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...𝑄.𝑆𝐼.." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Sabry.s.Language." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Scaffold." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Silq." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Strawberry.Fields." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...𝜆𝑞..Lambda.Calculi.." -->
<!-- "What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Other." -->
- `What Quantum Programming Languages / frameworks have you been using and for how long? [Blackbird]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [Braket SDK]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [Cirq]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [Cove]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [cQASM]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [CQP (Communication Quantum Processes)]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [cQPL]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [Forest]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [Ket]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [LanQ]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [𝐿𝐼𝑄𝑈𝑖|⟩]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [NDQFP]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [NDQJava]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [Ocean Software]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [OpenQASM]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [Orquestra]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [ProjectQ]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [Q Language]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [QASM (Quantum Macro Assembler)]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [QCL (Quantum Computation Language)]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [QDK (Quantum Development Kit)]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [QHAL]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [Qiskit]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [qGCL]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [QHaskell]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [QML]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [QPAlg (Quantum Process Algebra)]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [QPL and QFC]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [QSEL]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [QuaFL (DSL for quantum programming)]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [Quil]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [Quipper]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [Q#]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [𝑄|𝑆𝐼⟩]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [Sabry's Language]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [Scaffold]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [Silq]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [Strawberry Fields]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [𝜆𝑞 (Lambda Calculi)]`
- `What Quantum Programming Languages / frameworks have you been using and for how long? [Other]`: which QPLs the participants use and how long
  * factor, e.g., "QDK" (Multiple Choice Grid)
  * factor, i.e., Less than 1 year; 1 to 2 years; 3 to 4 years; 5 to 6 years; 7 to 8 years; 9 to 10 years; More then 11 years; 
  * acronym: used_qpls

<!-- "Is.there.any.other.Quantum.Programming.Language.not.listed.that.you.have.been.using." -->
- `Is there any other Quantum Programming Language not listed that you have been using?`: others QPLs and frameworks not listed that the participant used
  * text, e.g., "Perceval"
  * acronym: other_used_qpl

<!-- "Which.of.the.following.is.your.𝐩𝐫𝐢𝐦𝐚𝐫𝐲.Quantum.Programming.Language...framework." -->
- `Which of the following is your primary Quantum Programming Language / framework?`: the most used QPL by the participants
  * factor, i.e., Blackbird; Braket SDK; Cirq; Cove; cQASM; CQP (Communication Quantum Processes); cQPL; Forest; Ket; LanQ; 𝐿𝐼𝑄𝑈𝑖|⟩; NDQFP; NDQJava; Ocean Software; OpenQASM; Orquestra; ProjectQ; Q Language; QASM (Quantum Macro Assembler); QCL (Quantum Computation Language); QDK (Quantum Development Kit); QHAL; Qiskit; qGCL; QHaskell; QML; QPAlg (Quantum Process Algebra); QPL and QFC; QSEL; QuaFL (DSL for quantum programming); Quil; Quipper; Q#; 𝑄|𝑆𝐼⟩; Sabry's Language; Scaffold; Silq; Strawberry Fields; 𝜆𝑞 (Lambda Calculi); Other;
  * acronym: primary_qpl

<!-- "In.terms.of.ease...rate.your.𝐩𝐫𝐢𝐦𝐚𝐫𝐲.Quantum.Programming.Language...Features...functionalities.of.the.language." -->
<!-- "In.terms.of.ease...rate.your.𝐩𝐫𝐢𝐦𝐚𝐫𝐲.Quantum.Programming.Language...Documentation.avaliable." -->
<!-- "In.terms.of.ease...rate.your.𝐩𝐫𝐢𝐦𝐚𝐫𝐲.Quantum.Programming.Language...Code.examples." -->
<!-- "In.terms.of.ease...rate.your.𝐩𝐫𝐢𝐦𝐚𝐫𝐲.Quantum.Programming.Language...Several.forums." -->
<!-- "In.terms.of.ease...rate.your.𝐩𝐫𝐢𝐦𝐚𝐫𝐲.Quantum.Programming.Language...Support..e.g...github.issues.." -->
<!-- "In.terms.of.ease...rate.your.𝐩𝐫𝐢𝐦𝐚𝐫𝐲.Quantum.Programming.Language...Easy.to.code." -->
- `In terms of ease, rate your primary Quantum Programming Language. [Features / functionalities of the language]`
- `In terms of ease, rate your primary Quantum Programming Language. [Documentation avaliable]`
- `In terms of ease, rate your primary Quantum Programming Language. [Code examples]`
- `In terms of ease, rate your primary Quantum Programming Language. [Several forums]`
- `In terms of ease, rate your primary Quantum Programming Language. [Support (e.g., github issues)]`
- `In terms of ease, rate your primary Quantum Programming Language. [Easy to code]`:  rate the main characteristics of the participants favourite QPL
  * factor, i.e., Features / functionalities of the language; Documentation avaliable; Code examples; Several forums; Support (e.g., github issues); Easy to code; (Multiple Choice Grid)
  * factor, i.e., 1; 2; 3; 4; 5;
  * acronym: rate_primary_qpl

<!-- "Is.there.anything.else.you.𝗹𝗶𝗸𝗲.𝘁𝗵𝗲.𝗺𝗼𝘀𝘁.in.your.𝐩𝐫𝐢𝐦𝐚𝐫𝐲.Quantum.Programming.Language." -->
- `Is there anything else you like the most in your primary Quantum Programming Language?`: the main characteristic that the participants like in their primary QPL
  * text, e.g., "Open source"
  * acronym: like_primary_qpl

<!-- "Is.there.anything.else.you.𝗱𝗼.𝗻𝗼𝘁.𝗹𝗶𝗸𝗲.in.your.𝐩𝐫𝐢𝐦𝐚𝐫𝐲.Quantum.Programming.Language." -->
- `Is there anything else you do not like in your primary Quantum Programming Language?`: the main characteristic that the participants do not like in their primary QPL
  * text, e.g., "Missing features"
  * acronym: not_like_primary_qpl

<!-- "Which.forums..e.g...to.ask.for.help..search.for.examples..do.you.use...if.any." -->
- `Which forums, e.g., to ask for help, search for examples, do you use? (if any)`: the most used forums to ask questions on quantum computing
  * factor, e.g., Devtalk; Quantum Open Source Foundation; Slack; StackOverflow; Other; ...
  * acronym: forum

<!-- "Which.Quantum.Programming.Languages...frameworks.would.you.like.to.work.or.try.in.the.near.future.." -->
- `Which Quantum Programming Languages / frameworks would you like to work or try in the near future? `: which is the most like QPL to be used in the future
  * factor, e.g., Blackbird; Braket SDK; Cirq; Cove; cQASM; CQP (Communication Quantum Processes); cQPL; Forest; Ket; LanQ; 𝐿𝐼𝑄𝑈𝑖|⟩; NDQFP; NDQJava; Ocean Software; OpenQASM; Orquestra; ProjectQ; Q Language; QASM (Quantum Macro Assembler); QCL (Quantum Computation Language); QDK (Quantum Development Kit); QHAL; Qiskit; qGCL; QHaskell; QML; QPAlg (Quantum Process Algebra); QPL and QFC; QSEL; QuaFL (DSL for quantum programming); Quil; Quipper; Q#; 𝑄|𝑆𝐼⟩; Sabry's Language; Scaffold; Silq; Strawberry Fields; 𝜆𝑞 (Lambda Calculi); Other; ...
  * acronym: qpl_future

<!-- "Why.would.you.like.to.work.or.try.those.languages...frameworks." -->
- `Why would you like to work or try those languages / frameworks?`: motive why the participant wants do work with the QPL
  * factor, e.g., Heard about the language; Is part of a course about the language; Read an article about the language; Widely used; Other features; Other; ...
  * acronym: why_like_try_qpl

<!-- "What.challenges.did.you.run.into.when.choosing.a.Quantum.Programming.Language...framework." -->
- `What challenges did you run into when choosing a Quantum Programming Language / framework?`: the challenges that the participant faces when they are choosing a QPL
  * text, e.g., "Lack of documentation"
  * acronym: challenges

<!-- "In.your.opinion..what.makes.learning.Quantum.Programming.Languages...frameworks.important." -->
- `In your opinion, what makes learning Quantum Programming Languages / frameworks important?`: why the participants want to learn QPLs
  * text, e.g., "Solving optimization problems"
  * acronym: learn_qpl_important

<!-- "How.do.you.use.Quantum.Programming.Languages.." -->
- `How do you use Quantum Programming Languages?`: how the participants use QPLs
  * factor, e.g., Use it for work; Use it for research; Like to learn; Other; ...
  * acronym: how_use_qpl

<!-- "What.are.the.type.of.tools.you.think.are.necessary.or.missing.to.develop.better.and.faster.Quantum.Programs...E.g...IDE.tailored.for.quantum..tools.to.debug.quantum.programs..tools.to.test.." -->
- `What are the type of tools you think are necessary or missing to develop better and faster Quantum Programs? (E.g., IDE tailored for quantum, tools to debug quantum programs, tools to test)`: what are the tools missing in the QPLs
  * text, e.g., "Tools to debug"
  * acronym: tools_missing_qpl

<!-- "Do.you.test.your.Quantum.Programs." -->
- `Do you test your Quantum Programs?`: identify if the participants perform tests
  * factor, i.e., Yes; No;
  * acronym: do_test

<!-- "How.often.do.you.test.your.Quantum.Programs." -->
- `How often do you test your Quantum Programs?`: the frequency that the participant test their quantum programs
  * factor, e.g., Before go to production; Every day; Every time you change the code; Other; ...
  * acronym: how_often_test

<!-- "How.do.you.test.your.Quantum.Programs.." -->
- `How do you test your Quantum Programs?`: if the participants use automatic or manual tests
  * factor, i.e., Automatically (e.g., unit test); Manually;
  * acronym: how_test

<!-- "What.tools.do.you.use.to.test.your.Quantum.Programs." -->
- `What tools do you use to test your Quantum Programs?`: what are the most used tools to test quantum programs
  * factor, e.g., Cirq Simulator and Testing - cirq.testing (https://quantumai.google/cirq); Forest using pytest (https://github.com/rigetti/forest-software); MTQC - Mutation Testing for Quantum Computing (https://javpelle.github.io/MTQC/); Muskit: A Mutation Analysis Tool for Quantum Software Testing (https://ieeexplore.ieee.org/document/9678563); ProjectQ Simulator (https://arxiv.org/abs/1612.08091); QDiff - Differential Testing of Quantum Software Stacks (https://ieeexplore.ieee.org/abstract/document/9678792); QDK - xUnit (https://azure.microsoft.com/en-us/resources/development-kit/quantum-computing/); Qiskit - QASM Simulator (https://qiskit.org/); QuanFuzz - Fuzz Testing of Quantum Program (https://arxiv.org/abs/1810.10310); Quito - A Coverage-Guided Test Generator for Quantum Programs (https://ieeexplore.ieee.org/abstract/document/9678798); Straberry Fields using pytest (https://strawberryfields.ai/); Other; ...
  * acronym: tools_test

<!-- "In.your.opinion..do.you.think.there.are.too.many.or.too.few.Quantum.Programming.Languages..Why." -->
- `In your opinion, do you think there are too many or too few Quantum Programming Languages? Why?`: the opinion of the participants why exists or not several QPLs
  * text, e.g., "There are too many."
  * acronym: why_too_many_qpl

<!-- "In.your.opinion..do.you.think.that.quantum.developers.would.need.yet.another.Quantum.Programming.Languages.in.the.near.future..Why." -->
- `In your opinion, do you think that quantum developers would need yet another Quantum Programming Languages in the near future? Why?`: if the participant think that it is necessary the development of another QPL
  * text, e.g., "yes, because of the abstraction level"
  * acronym: why_need_another_qpl
