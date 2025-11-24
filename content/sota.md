## Related Work
{:#sota}

We start by looking into the related work covering parsers and compilers from a theoretical perspective,
afterward we list the most relevant existing parsers for SPARQL and other query languages.
After covering the parsing itself, we take a look at common AST structures, specifically when the AST needs to support round-tripping.

### Parsers

To parse a structured language is to take that language as a string and transform it into a data structure of your desire.
[Parsing involves three steps](cite:cites alfred2007compilers):

1. **Lexical analysis** (or _scanning_) performed by a _lexer_: reading a source stream of characters and identifying non-overlapping sequences called _lexemes_.
   The description of what type of lexemes (called token type) should be identified is often done through a Regex.
   Lexemes can be represented as a string, or a range in relation to the source, or both.
   The scanning process outputs a stream or list of tokens, which is the lexeme representation together with its token type.
2. **Syntax analysis** (or _parsing_) performed by a _parser_: after having generated a 'flat' stream or list of tokens, the next part is to create a data structure,
   which is typically a tree, often called the Abstract Syntax Tree (AST).
3. **Semantic analysis**: after having generated the tree, you check the non-structural constraints.
   An example of such a constraint in SPARQL is that the variable assigned in a BIND clause cannot be used in the immediately preceding tripleBlock within the same block.
   While parsing programming languages it could be something like type checking.

It should be noted that these three steps are conceptually distinct but are not necessarily executed distinctly.
One example of joined execution is the case of a streaming parser where the output data structure of the parser is itself a stream.
Streaming parsers are specifically interesting when parsing large amounts of data,
where semantic analysis is either not required or required in limited form.
Example data formats that tailor themselves to streaming, specifically RDF data, are
[Jelly](cite:cites streaming-parsing-jelly) and [n-triples](cite:cites spec:n-triples).
Another way of joined execution is where syntax analysis and semantic analysis are joined,
allowing the parser to fail fast in case a semantic constraint would be broken.

The actual programmatic definition of the different parsing steps can happen in various ways; we identify the following three:

1. **Generated**: Code generation tools come with their Domain Specific Language (DSL)
   that will typically share similarities with Extended Backus–Naur Form (EBNF) and some Regular Expression (regex/ regexp) dialect.
   The build process of the software that uses the custom parser should then compile the parser definition file (in the custom DSL) to the desired target language,
   which is typically the same language as the software being build.
   Example parser generators are [Bison](cite:cites bison-gnu) and [ANTLR](cite:cites parr1995antlr).
2. **Hand build**: Code generation can come with optimization limitations, when your grammar allows for optimizations not taken by the code generator.
   Just like writing assembly yourself, writing a handwritten parser is powerful but very challenging to get right,
   because compilers often know powerful, very specific, non-trivial optimizations.
   On top of programming language-specific optimizations, other powerful optimizations exist for specific sets of grammars,
   such as [LL(1) and LL(k)](cite:cites alfred2007compilers, parr1995antlr).
3. **Toolkits/ libraries**: A compromise between hand-built parsers and generators exists in the form of toolkits/ libraries.
   Parser building toolkits, e.g. [Chevrotain](cite:cites chevrotain),
   are software libraries that provide an API that facilitates the construction of parsers within a specific programming language.
   The benefit of constructing a parser within the programming language the parser would be called from is that the project's code can be more coherent, allowing better integration,
   while also providing abstraction for powerful optimizations that can be made for specific grammars such as LL(1) and LL(k).
   Additionally, it allows you to use language-specific features, such as type checking, which are often not present in DSLs used by parser generators, which are often limited.
   However, toolkits miss out on compiler-based optimizations since they cannot fully optimize the user's code,
   and similarly miss out on certain optimizations that could be possible in hand-built parsers.

We will go on to argue that parser-building toolkits provide a nice middle ground between both generated parsers,
and hand-built parser while still providing excellent execution times according to the performed benchmark
[(TODO: footnote)](https://chevrotain.io/performance/).

### Existing SPARQL/SQL parsers

[Previous work](cite:cites modular-parsing) which introduced the concept of modular parsing for SPARQL, contained a
detailed analysis of what tools were used by popular open-source SPARQL implementations.
Since an analysis of used methods to create query language parsers is relevant,
we repeat it here while extending their analysis to cover query languages such as
[SQL](cite:cites iso-sql), [GraphQL](cite:cites spec:graphql), [GQL](cite:cites iso-gql), and [Neo4J's cypher](cite:cites neo4j).

<figure id="parsers" class="table">

<table>
    <thead><tr>
        <th>Software Package</th><th>Query Language</th><th>Parsing Software</th><th>Parser Constructed Using</th>
    </tr></thead>
    <tbody><tr>
        <td markdown="1">
[Comunica (V4.4.1)](cite:cites comunica)
</td>
        <td>SPARQL</td>
        <td markdown="1">
[SPARQL.js (V3.7.1)](cite:cites sparqljs)
<sup class="screenonly"><a href="https://github.com/comunica/comunica/blob/94e1eacab069551590cc250074b36bce08720c4c/packages/actor-query-parse-sparql/package.json#L50">proof</a></sup>
</td>
        <td markdown="1">
[Jison](cite:cites jison)
<sup class="screenonly"><a href="https://github.com/RubenVerborgh/SPARQL.js/blob/13cc3d2ee4d2528b85d8b25cfbf886597dd100c1/lib/sparql.jison">proof</a></sup>
</td>
    </tr><tr>
        <td>[Yasgui (V4.0.113)](cite:cites yasgui)</td>
        <td>SPARQL</td>
        <td></td>
        <td><a href="https://www.swi-prolog.org/">SWI Prolog</a>
        <sup class="screenonly"><a href="https://github.com/TriplyDB/Yasgui/blob/4086f8ba5281e2781488dd83e1e2cc4af775cdc2/packages/yasqe/grammar/build.sh">proof</a></sup>
        </td>
    </tr><tr>
        <td><a href="https://jena.apache.org/">Apache Jena (V5.6.0)</a></td>
        <td>SPARQL</td>
        <td></td>
        <td><a href="https://javacc.github.io/javacc/">JavaCC</a>
        <sup class="screenonly"><a href="https://github.com/apache/jena/blob/3b6fb69d4ef78f4f130235a8fccb853291ea2b47/jena-arq/src/main/java/org/apache/jena/sparql/lang/sparql_10/SPARQLParser10.java">proof</a></sup>
        </td>
    </tr><tr>
        <td><a href="https://github.com/oxigraph/oxigraph">Oxigraph (V0.5.2)</a></td>
        <td>SPARQL</td>
        <td></td>
        <td><a href="https://github.com/kevinmehall/rust-peg">rust-peg</a>
        <sup class="screenonly"><a href="https://github.com/oxigraph/oxigraph/blob/2247319a1ff9132fd574d56db40f7178da938000/lib/spargebra/src/parser.rs#L778">proof</a></sup>
        </td>
    </tr><tr>
        <td><a href="https://github.com/stardog-union/millan">Stardog - Millan (commit 6109984)</a></td>
        <td>SPARQL</td>
        <td></td>
        <td><a href="https://chevrotain.io/docs/">Chevrotain</a>
        <sup class="screenonly"><a href="https://github.com/stardog-union/millan/blob/fc0c04b1818d20c68cf7fceb41f6ba0ee8258bd5/src/sparql/BaseSparqlParser.ts">proof</a></sup>
        </td>
    </tr><tr>
        <td><a href="https://virtuoso.openlinksw.com/">Virtuoso (commit 23cff67)</a></td>
        <td>SPARQL</td>
        <td></td>
        <td><a href="https://www.gnu.org/software/bison/">Bison</a>
        <sup class="screenonly"><a href="https://github.com/openlink/virtuoso-opensource/blob/23cff6731d6f8f431bde314453ec07038cc62bf5/README.GIT.md#package-dependencies">proof</a></sup>
        </td>
    </tr><tr>
        <td><a href="https://github.com/blazegraph/database/">Blazegraph (commit 829ce82)</a></td>
        <td>SPARQL</td>
        <td></td>
        <td><a href="https://javacc.github.io/javacc/">JavaCC</a>
        <sup class="screenonly"><a href="https://github.com/blazegraph/database/blob/829ce8241ec29fddf7c893f431b57c8cf4221baf/sparql-grammar/src/main/java/com/bigdata/rdf/sail/sparql/ast/sparql.jj">proof</a></sup>
        </td>
    </tr><tr>
        <td><a href="https://www.ontotext.com/products/graphdb/">GraphDB (V11.0)</a></td>
        <td>SPARQL</td>
        <td><a href="https://rdf4j.org/">RDF4J (V5)</a>
        <sup class="screenonly"><a href="https://graphdb.ontotext.com/documentation/11.0/architecture-components.html#architecture-and-components">proof</a></sup>
        </td>
        <td><a href="https://javacc.github.io/javacc/">JavaCC</a>
        <sup class="screenonly"><a href="https://github.com/eclipse-rdf4j/rdf4j/tree/b33d91485502d2f5266916c0581960e41b8f28b5/core/queryparser/sparql/JavaCC">proof</a></sup>
        </td>
    </tr>

<!------------- SQL ------------------>
<tr>
        <td>[DuckDB (V1.4.2)](cite:cites duckdb)</td>
        <td>SQL</td>
        <td></td>
<!-- Uses bison/flex to generate lexer:
https://github.com/duckdb/duckdb/blob/main/scripts/generate_flex.py using https://github.com/duckdb/duckdb/blob/main/third_party/libpg_query/scan.l
Parser is generated in: https://github.com/duckdb/duckdb/blob/main/scripts/generate_grammar.py using 
https://github.com/duckdb/duckdb/tree/main/third_party/libpg_query/grammar
-->
        <td><a href="https://www.gnu.org/software/bison/">Bison</a>
        <sup class="screenonly"><a href="https://github.com/duckdb/duckdb/tree/8d6608785487ba62129307e73be89b561f623638/third_party/libpg_query">proof</a></sup>
        </td>
    </tr><tr>
        <td>PostgreSQL (V18)</td>
        <td>SQL</td>
        <td></td>
        <td><a href="https://www.gnu.org/software/bison/">Bison</a>
        <sup class="screenonly"><a href="https://github.com/postgres/postgres/blob/877a024902a73732d9f976804aee9699dcbe1d90/src/backend/parser/gram.y">proof</a></sup>
        </td>
    </tr><tr>
        <td>SQLite (V3.51.0)</td>
        <td>SQL</td>
        <td></td>
        <td><a href="https://github.com/sqlite/sqlite/blob/master/doc/lemon.html">Lemon</a>
        <sup class="screenonly"><a href="https://github.com/sqlite/sqlite/blob/7efded5edccb28a950f18bea099599887fba96ff/README.md?plain=1#L247-L253">proof</a></sup>
        </td>
    </tr>

<!--- GraphQL ---->
<tr>
        <td>GraphQL (V16.12.0)</td>
        <td>GraphQL</td>
        <td></td>
        <td>hand written
        <sup class="screenonly"><a href="https://github.com/graphql/graphql-js/blob/e2457b33e928f4ec8b22e96a6dc6cb2808c03dfa/src/language/parser.ts">proof</a></sup>
        </td>
    </tr>
<!--- GQL ---->
    <tr>
        <td><a href="https://github.com/opengql/grammar">opengql grammar (V1.9.0)</a></td>
        <td>GQL</td>
        <td></td>
        <td>ANTLR
        <sup class="screenonly"><a href="https://github.com/opengql/grammar/tree/16ea71bd320ad07fd2c46a3066afbaef7d226922">proof</a></sup>
        </td>
    </tr>
<!--- Cypher ---->
    <tr>
        <td>Neo4J (V25)</td>
        <td>Cypher</td>
        <td></td>
        <td>ANTLR
        <sup class="screenonly"><a href="https://github.com/neo4j/neo4j/tree/c68156edf24164435ab1ac257ec633134c2887f7/community/cypher/front-end/parser/v25/parser">proof</a></sup>
        </td>
    </tr>

</tbody>
</table>

<figcaption markdown="block">
List of different query software packages covering various query languages.
For each software component we list the software on which they depend to perform the parsing (blank in case they parse themselves); the last column lists how the parser is constructed.
</figcaption>
</figure>

[](#parsers) clearly shows that parser generators are the most popular approach, concretely 12 systems out of the 14 listed,
while only one implementation uses a handwritten parser, and another one uses a parser toolkit, namely Chevrotain.
Even though some parser builders support composability,
like though [ANTLR's grammar imports](https://github.com/antlr/antlr4/blob/857fb46e781ce9c40249b9f0156c67051cec12c1/doc/grammars.md#grammar-imports), they do so using parser granularity, and not rule granularity.
Specifically, parsers can be extended similar to an OOP class extension,
but rules cannot be deleted, nor can a patched rule still reference the original implementation.
Furthermore, all parser builder require a compile step, and most parser builders only provide a CST,
necessitating a tree walk to create the AST, splitting the task of parsing to an AST in two.

### AST structures (round-tripping)

To support reformatting and linting, both important tools for structured languages,
an essential property is the round-tripping between the AST and string representation.
In the case of SPARQL, both blank spaces and capitalization of keywords are irrelevant; however,
it should not be the case that a reformatter changing indentation also changes the capitalization,
as such, the AST should keep track of capitalization somehow, even though it is irrelevant for the language interpretation.

A popular tool that manipulates structured language on the AST level is [Babel](cite:cites babel), a compiler for writing next-generation JavaScript,
which allows you to write one of JavaScript and compile/ transpile it to another version, empowering you to write new JavaScript and execute it on old environments. 
To support this rewriting approach while still providing a structured AST,
Babel uses [source-location annotations within their AST nodes](https://github.com/babel/babel/blob/master/packages/babel-parser/ast/spec.md#node-objects),
meaning nodes can specify what range of offsets they represent in the string.
A node can then be replaced either by
a _source string_ which means the specified string will replace the node when regenerating the string,
or by _another node_ that should be auto generated.
Auto generation generates a specific version of valid syntax,
for example a SPARQL string literal '`a`' could be generated as `'a'`, `"a"`, `'''a'''`, or `"""a"""`.

[ESLint](cite:cites eslint) is a very popular linter that also allows automatic fixes and thus operates as a rewriter.
The [AST used by ESLint](https://github.com/eslint/eslint/blob/main/docs/src/extend/custom-parsers.md#all-nodes)
expects a source location identification similar to Babel, requiring it for each node.
Unlike Babel, though, the fixes are not applied through the AST itself but
using a [fixer helper](https://github.com/eslint/eslint/blob/main/lib/rules/no-var.js#L342-L344)
that expects you to provide what range you would like to patch with what string.
The core idea of tracking the source location does, however, stay the same.


<!--
### Transformations?

Algebra transformations are required for rewriting/ optimizations.

RDF star?

### Query generation(?)/ text generation (?)

Might not be needed since it could be covered in AST structures.
-->
