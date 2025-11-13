## Requirements
{:#requirements}

Traqula has been created to cover some specific requirements; in this section we list the most important ones,
covering modularity, round-tripping generation, using web-based technologies, and being sufficiently generic to adopt other query languages.


### Modularity

The required modularity of Traqula is grounded in both existing and future heterogeneity of the SPARQL language.
The SPARQL language already knows many dialects of the SPARQL 1.1 query language,
and the practical heterogeneity is expected to grow even more
as the SPARQL 1.2 specification is being finalized and the working group prepares for
maintenance mode; which will allow for a more rapid evaluation of the SPARQL language specification [](cite:cites modular-parsing).
Since migration from RDF 1.1 to RDF 1.2 is not trivial, introducing the concept of recursive triples in the form of triple terms [](cite:cites rdf-1-2),
the authors expect that migration will require careful consideration by many, slowing down adoption.

Even though the problem of language dialects is not unique to the SPARQL language, e.g. SQL knows many dialects,
the nature of the RDF data model, to allow seamless integration of multiple datasets,
makes the query heterogeneity issue specifically important to solve.
This nature is reflected in the SPARQL specification itself as [federated queries](cite:cites spec:sparqlfed).
When a user-query is written in one version/dialect,
it is possible that the federation target expects a different version/dialect, a visualization is provided in [](#federation).
The [SPARQL service description specification](cite:cites spec:sparqlservicedesc)
exists exactly to allow SPARQL endpoints to describe their supported features and limitations.


<figure id="federation">
<img src="img/traqula-federation.svg" alt="Visual a single query that needs to be executed over vastly different sparql endpoints" style="object-fit: contain; width: 50%; margin: 0 auto;"/>
<figcaption markdown="block">
Schematic representation of federated querying in a heterogeneous SPARQL landscape.
The user query is written in SPARQL 1.2 and uses the builtin ADJUST function that is not specified in the SPARQL specification,
but still supported by [some engines](cite:cites oxigraph-adjust).
The endpoints being queried however, vary in SPARQL version, [RDF profile](cite:cites rdf-1-2), and supported language features. 
</figcaption>
</figure>

Besides the potential to mitigate the heterogeneity issue,
modularity also allows researchers and practitioners to rapidly test new language features.
Traqula has already served its purpose in this regard.
The modular query framework **Comunica has already been adopted to use Traqula** as its parser,
generator, and algebra representation/manipulation library.
By harnessing the modularity of both Traqula and Comunica,
the authors have been able to assist in the standardization of SPARQL 1.2.

### Round tripping

By now I have talked about this too much... should be scrambled...

Editor tooling / linter


### Web-based

Developing using Web-Based technologies such as
[JavaScript](https://ecma-international.org/publications-and-standards/standards/ecma-262/) or
[WebAssembly (WASM)](https://webassembly.org/) allows software to be executed in many environments,
natively in a browser, or on a server using [Node.js](https://nodejs.org/en), [Bun](https://bun.sh/), [Deno](https://deno.com/), etc.
You can access the code within your favorite web-based frontend framework like
[React](https://react.dev/), [Vue](https://vuejs.org/), [Svelte](https://svelte.dev/), etc;
and run your frontend as an application using [Electron](https://www.electronjs.org/) or [Tauri](https://tauri.app/).
In short, choosing to develop using Web-Based technologies keeps many doors open, allowing for a wide adoption.

<!--
"Optimalisatie van sorteringsalgortimes in query engines gebruik makend van WebAssembly": https://lib.ugent.be/fulltxt/RUG01/003/150/197/RUG01-003150197_2023_0001_AC.pdf
https://libstore.ugent.be/fulltxt/RUG01/003/063/185/RUG01-003063185_2022_0001_AC.pdf
Overhead in module instantiation time (minimal) and Overhead in communication (also minimal)
Prev work says that for sorting, a list of 100 elements already makes it worth the sort in WASM (linear data transfer cost vs n log(n) sort cost).

Interestingly, prev work states that a big problem is the inherent [memory limitation of WASM](https://www.w3.org/TR/wasm-js-api-2/#limits).
However, the recently released WASM 2.0 has 64-bit memory support, increasing the storage capacity from 4GB to 16GB.
More issues on WASM memory management: https://github.com/WebAssembly/design/issues/1397
-->

Since many programming languages can be compiled to WASM,
including Rust using [wasm-pack](https://github.com/drager/wasm-pack),
C++ using [Emscripten](https://emscripten.org/),
and even JavaScript using [Javy](https://github.com/bytecodealliance/javy?tab=readme-ov-file),
our options on programming language are still wide open.


### Generic Core

<!--
https://www.w3.org/TR/shacl/#document-outline
> The syntax of SHACL is RDF.
-->

Since Traqula aims to tackle query language heterogeneity issues,
it should provide tools that are sufficiently generic so that they can be used for the implementation of other modular parsers,
generators and transformers.
As such, Traqula's SPARQL 1.1 and SPARQL 1.2 parser, generator and algebra transformations,
all use a single core library that empowers the creation of these modular systems even for non-SPARQL query languages.
A particular interesting case would be the [SHACL Compact Syntax](cite:cites shacl-1-2-cs) grammar shares many similarities with SPARQL,
yet is completely distinct.
