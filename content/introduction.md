## Introduction
{:#introduction}

<!--
Talk about generation, modularity, you can refer to self about parsers but say that we have gone much more broad now.
We support round-tripping, generation, and algebra transformation.
Additional pro for in language parser builder is the variation your get from the type system.
Round-tripping allows you to make language tools such as linters.
AST transformer.
Why JS/ TS?
Modularity allows future proofness.
Why is do you see this issue in sparql? separation between the data model and query language?
What parsers do we support ourselves? Link to the proof of extension we did in Comunica?
-->

<span class="comment" data-author="RT">General comment: I like the start of the intro, but after the first paragraph, I don't find it as strong anymore. I actually like the intro of your previous paper much more. It might make sense to follow the paragraph structure of that one.</span>

The [SPARQL query language](cite:cites spec:sparqllang) is the standard for querying over [RDF](cite:cites spec:rdf) data.
In practise, many SPARQL dialects exist, covering different extensions or limitations related to the standard.
For example, Virtuoso extends SPARQL with full-text search capabilities [](cite:cites virtuoso-full-text-search),
Apache Jena adds support for constructing quads [](cite:cites jena-construct-quad),
and Oxigraph provides an additional built-in function, `ADJUST` [](cite:cites oxigraph-adjust).
Furthermore, some [SPARQL endpoints](cite:cites spec:sparqlprot) might limit the SPARQL language
by removing expensive operators such as OPTIONAL [](cite:cites querycomplexity).
In the near future, this heterogeneity is expected to increase even further as the RDF and SPARQL W3C Working Group enters its
[maintenance mode](https://github.com/w3c/sparql-dev/issues/32#issuecomment-2621209920) [](cite:cites modular-parsing),
which will deliver more rapid successions of SPARQL once SPARQL 1.2 is available.
<!-- -->
This diversity of the different SPARQL versions and dialects poses various challenges:

1. **Query evaluation**: A user query written in one version might not be executable on a SPARQL engine supporting another version.
2. **Tooling**: Linters, formatters, and editors expect queries to be written in a certain SPARQL version.
3. **Tooling maintainability**: Tools that do support multiple SPARQL versions typically do so by maintaining multiple softwaree versions,
   or one version with many conditions, making maintainability highly challenging.

To tackle these issues, we previously discussed how a modular parser can solve this problem, for which we provided a prototypical implementation [](cite:cites modular-parsing).
<span class="comment" data-author="RT">This paragraph goes too deep for an introduction IMO. I would keep this for section 3.</span>
Our idea is essentially to introduce an indirection layer in the grammar definitions,
meaning that the declaration of a rule, consisting of subrules and tokens, is done based on identifiers of the rules.
The identifiers of those rules are only replaced with the actual implementation of the rules when you compile/ build the parser.
By cleverly defining an API that links rule identifiers with rule implementations, one creates a composable parser.
A parser only gets you the Abstract Syntax Tree (AST) or Concrete Syntax Tree (CST) [](cite:cites alfred2007compilers),
while query engines operate on a higher level, namely the [SPARQL Algebra](cite:cites spec:sparqllang),
so additional transformations are required after parsing.
The SPARQL specification describes how to translate the AST into these algebraic operations.
Query evaluation and optimization rely on the manipulation of these algebraic operations,
and [SPARQL federation](cite:cites spec:sparqlfed) relies on the conversion of algebra operations to query strings.
For that reason, we also need a way to translate the algebra operations back into an AST,
which can then be used to generate the appropriate query string.
All these conversions suffer from the same problems caused by the practical heterogeneity of SPARQL.

<span class="comment" data-author="RT">This also seems to go too detailed for the intro. I think we can keep this for Requirements.</span>
Since SPARQL queries are structured languages often created or read by humans, similar to programming languages,
it makes sense that they benefit from similar tools such as editors, code highlighting, linters, and reformatting.
Some of these tools rely on a property called round-tripping, meaning you can convert the query string into an AST,
perform changes to a node, and the conversion back only changes that changed node, keeping everything else the same.
An example of reformatting would be the expansion of the variable _'s'_ to _'subject'_ in `SelECT_*_{_?s__?p_?o_}`
without changing other parts of the query.
Such an expansion would result in `SelECT_*_{_?subject__?p_?o_}`.
[](#representations) provides a schematic overview of these different representations of a query.

<span class="comment" data-author="RT">I would not talk about ASTs here in the intro. So for this figure, I think it'd be more useful to visualize a federated query across SPARQL endpoints with different versions and dialects. (and then also add a paragraph explaining all the challenges (not only parsing) around this, and how traqula can help with tackling this.)</span>
<figure id="representations">
<img src="img/traqula-representations.svg"
    alt="Visual representation of the different representations of a query and arrows depicting the transitions between them"
    style="object-fit: contain;"/>
<figcaption markdown="block">
Schematic representation of various representations of an algebraically equivalent SPARQL 1.1 query and a transformation to a 1.2 query.
A query can be represented as structured language that both end-users and SPARQL endpoints use.
Parsing that representation provides you with the AST representation, which is a structured representation of the language used by linters and formatters.
The AST can be transformed to an algebra representation, which is used by query engines; it provides a higher level of abstraction than the AST.
Transformations exist within the layer, and the choice of what layer to transform in is based on the level of precision or abstraction required. 
</figcaption>
</figure>

<span class="comment" data-author="RT">Important: make sure to explain clearly what the delta is between this paper and the previous one.</span>

To handle the heterogeneity of SPARQL,
<span class="comment" data-author="RT">The remainder is a repetition of what's mentioned before.</span>
which is projected to only increase with the adoption of [RDF 1.2](cite:cites rdf-1-2) and the [subsequent maintenance mode](https://github.com/w3c/sparql-dev/issues/32#issuecomment-2621209920) of the RDF 1.2 workgroup [](cite:cites modular-parsing).
There is a need for a modular SPARQL parser, generator, and algebra transformation toolkit.
In this paper we introduce _Traqula_, a modular toolkit that already supports [SPARQL 1.1](cite:cites spec:sparqllang) and [SPARQL 1.2](cite:cites sparql-1-2).
Traqula aims to allow researchers and practitioners to:

1. investigate the effect of making grammar changes (adding, modifying, or deleting grammar rules),
2. increase maintainability of language tools, including the parsers, generator, and algebra transformers across different SPARQL versions, and
3. open the path for future query formatting/ rewriting tools based on round-tripping.

<span class="comment" data-author="RT">The following is for the implementation section.</span>
Traqula is implemented in the TypeScript programming language,
and can also be used in JavaScript/ECMAScript,
both using the CommonJS (CJS, legacy) format and ECMAScript Modules (ESM, modern) format.
Traqula, and its various components are publicly available on GitHub and the npm package manager
under the open-source MIT software license.

<span class="comment" data-author="JDS">I think it makes sense to swap sota and requirements.
We did our investigation based on the requirements after all? We want to do abc so we looked at xyz.</span>
<span class="comment" data-author="RT">TODO</span>
The next section.... 

<!--
Translation between versions
Allow to test certain language features,
Allow to disable certain language features,
allow maintainability of tools,
allow future implementation of editor that supports rewriting
Modularity also allows introduction of quality of life improvements (see helpers in generator.)
-->
<!--
the authors recently made a [Proof of Concept](cite:cites modular-parsing) on how a **modular parser** could solve issues arising form such a heterogeneous SPARQL landscape.
After positive reactions on that PoC, we extended our work to be
more mature, include modular round-tripping parsers and generators, and modular algebra transformers,
allowing us to present Traqula: a collection of modular parsers, generators and algebra transformers. 
-->
<!--
At the core of the Semantic Web is [the resource Description Framework (RDF)](cite:cites spec:rdf),
which is described as an abstract syntax/ data-model, that ties together multiple other specification such as:
1. [RDF Semantics](cite:cites spec:rdf-semantics);
2. various syntaxes such as [n-triple](cite:cites spec:n-triples), [turtle](cite:cites spec:turtle) and [json-ld](cite:cites spec:json-ld);
3. the [RDF schema vocabulary](cite:cites spec:rdf-schema); and
4. a collection of specification describing the RDF Query Language, SPARQL, like
[SPARQL Query Language](cite:cites spec:sparqllang) and [SPARQL Update](cite:cites spec:sparqlupdatelang).
RDF and it's accompanying specification know multiple versions,
namely [RDF 1.0](cite:cites spec:rdf-1-0), [RDF 1.1](cite:cites spec:rdf), and the upcoming [RDF 1.2](cite:cites rdf-1-2).
-->
<!--
The RDF data model is tightly interconnected with the web,
due to its dependence on IRIs as first class citizens, serving the notion of persistent identifiers.
The existence of persistent identifiers allows for a seamless merge operation between two datasets,
since an IRI used in both datasets identifies the same concept/ resource [](cite:cites spec:rdf).
In turn, this seamless merging of different datasets makes [SPARQL federated queries](cite:cites spec:sparqlfed) specifically interesting.
-->
<!--
Each of those versions thus has their accompanying SPARQL version, [1.0](cite:cites spec:sparql-1-0), [1.1](cite:cites spec:sparqllang), and [1.2](cite:cites sparql-1-2).
-->

