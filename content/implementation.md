## Implementation
{:#implementation}


### TypeScript

In order to maximize adoption, we decided to implement the Traqula in Typescript,
a popular language extending JavaScript with static types.
According to a [blogpost by GitHub](https://github.blog/news-insights/octoverse/octoverse-a-new-developer-joins-github-every-second-as-ai-leads-typescript-to-1/),
Typescript is now the most popular language on the immensely popular version control platform;
as such, many developers should be able to use Traqula and even collaborate on the project.
Traqula is available on GitHub using the open [MIT licence](https://www.tldrlegal.com/license/mit-license),
allowing anyone to use, modify, and maintain the code.


Traqula's core library provides many quality of life features through a dynamic API
which is empowered by the turing complete type system of the TypeScript language. 
By calling Traqula within a TypeScript project, this strong core will facilitate you is spotting mistakes early,
and discovering capabilities through your IDE's typing support.
Outside the typing API, Traqula provides documentation though JS docs,
which is both available as a [website](https://comunica.github.io/traqula/), and within your IDE.


### Current support

Traqula currently supports [SPARQL 1.1](cite:cites spec:sparqllang), [SPARQL 1.2](cite:cites sparql-1-2), and [SPARQL 1.1 + ADJUST](cite:cites sparql-adjust);
being able to transform them to an AST, and their algebra.
Given algebra, an AST can be created that would result in the same algebra, and given an AST a matching query string can be generated.
Both the AST and the algebra for all query languages can be easily transformed using type safe functions in the core library.
Given an AST that includes source information, the generator generates a query string reflecting that source information,
meaning semantically unimportant information can still be maintained.

To ensure correctness, Traqula already contains many integration level tests, e.g. testing the correctness of AST of a parsed query string.
These integration tests contain tests we created,
but also tests present in [SPARQL.JS](cite:cites sparqljs) and [SPARQLAlgebra.js](cite:cites sparqlalgebrajs),
two projects that <span class='todo'>are/ will be</span> deprecated in favor of Traqula.
Additionally, Traqula relies on the efforts of the RDF Tests Community Group,
which provides many positive/ negative tests for implementors of various RDF technologies through [their GitHub repository](https://github.com/w3c/rdf-tests/).
To increase maturity, reliability, and ease future contributions,
the authors are committed to increase the test coverage of Traqula by crafting additional unit/integration tests.


### Maintenance plan

Software project require a maintenance plan, both for the authors of these project, but also in order for users to trust them.
A first part in this maintenance plan is making the source open, we go even further, providing it as free software under the MIT license.
This licence allows anyone to contribute to Traqula, but also allows anyone to copy it and maintain their own version,
which provides some insurance in case the project would become unmaintained; since anyone can pick up the slack.
However, unmaintained projects are still bad, MIT licensed or not,
that's why Traqula's authors decided for Traqula to be part of the Comunica association.
being part of this association means that the code is not just the responsibility of a single individual.
Additionally, the association allows dependents to provide
economic insensitive when they require a specific feature or any other changes to the code in the form of bounties.
This ability to provide economic inventive behind certain wishes can be an additional reason for organisations
to use a software project, as it guarantees that they can trust development providing enough inventive. 
