## Related Work
{:#sota}

In this section we cover the related work,
while the next one provides a detailed motivation which might used light on why some things are deemed to be related.
We start by looking into the related work covering parsers/ compilers from a theoretical perspective,
afterward we list some existing parsers for SPARQL and the omnipresent [SQL query-language](cite:cites iso-sql).
After covering the parsing itself, we have a look at common AST structures, specifically when the AST needs to support round tripping.
The AST allows users to look at the structure of the language itself, but in the case of query languages,
you often want the additional abstraction of algebra operations, which requires additional transformations over the AST, so we look into these kind of transformations next. 

We might talk about query generation too.

### Parsers

To parse a structured language is to take that language as a string and transform it into a data structure of your desire.
[Parsing involves three steps](cite:cites alfred2007compilers):

1. **Lexical analysis** (or _scanning_) performed by a _lexer_: reading a source stream of characters and identifying non-overlapping sequences called _lexemes_.
The description of what type of lexemes (called token type) should be identified is often done through a Regex.
Lexemes can be represented as a string, or a range in relation to the source, or both.
The scanning process outputs a stream or list of tokens, which is the lexeme representation together with its token type.  
2. **Syntax analysis** (or _parsing_) performed by a _parser_: after having generated a 'flat' stream or list of tokens, the next part is to create a data structure,
which is often a tree, often called the Abstract Syntax Tree (AST).  
3. **Semantic analysis**: after having generated the tree, you check the non-structural constraints.
An example of such a constraint in SPARQL is that the variable assigned in a BIND clause cannot be used in the immediately preceding tripleBlock withing the same block.
While parsing programming languages it could be something like type checking.

It should be noted that these three steps are conceptually distinct but are not necessarily executed distinctly.
One example of joined execution is the case of a streaming parser where parts the output data structure of the parser is itself a stream.
Streaming parser are specifically interesting when parsing large amounds of data,
where sematic analysis is either not required or required in limited form.
Example data formats that tailer themselves to streaming, specifically RDF data are
[Jelly](cite:cites streaming-parsing-jelly) and [n-triples](cite:cites spec:n-triples).
Another way of joined execution is where syntax analysis and semantic analysis are joined together,
allowing the parser to fail fast in case a semantic contain would be broken.  

The actual programmatic definition of the different parsing steps can happen in various ways, we identify the following three:

1. **Generated**: Code generation tools come with their own Domain Specific Language (DSL)
that will typically share a lot of similarities with Extended Backus–Naur Form (EBNF) and some Regular Expression (regex/ regexp) dialect.
The build process of the software that uses the custom parser should then compile the parser definition file (in the custom DSL) to the desired target language,
which is typically the same language as the software being build.
Example parser generators are [Bison](cite:cites bison-gnu) and [ANTLR](cite:cites parr1995antlr).
2. **Hand build**: Code generation can come with optimization limitations, when your grammar allows for optimizations not taken by the code generator.
Just like writing assembly yourself, writing a handwritten parser is powerful but very hard to get right,
because compilers often know powerful, very specific, non-trivial optimizations.
On top of programming language specific optimizations, other powerful optimizations exist for specific sets of grammars,
such as [LL(1) and LL(k)](cite:cites alfred2007compilers, parr1995antlr).
3. **Toolkits/ libraries**: A compromise between hand build parsers and generators exists in the form of toolkits/ libraries.
Parser Building toolkits, e.g. [Chevrotain](cite:cites chevrotain),
are software libraries that provide an API which facilitates the construction of parsers within a specific programming language.
The benefit of constructing a parser within the programming language the parser would be called from is that the projects code can be more coherent allowing better for integration, 
while also providing abstraction for powerful optimizations that can be made for specific grammars such as LL(1) and LL(k).
Additionally, it allows you to use language specific features, such as type checking, which are often not present in DSLs used by parser generators, which are often limited.
However, toolkits miss out on compiler based optimizations since they cannot fully optimize the user's code,
and similarly miss out on certain optimizations that could be possible in hand build parsers.

We will go on to argue that parser building toolkits provide a nice middle-ground between both generated parsers,
and hand build parser while still providing excellent execution times according to the preformed benchmark
[(TODO: footnote)](https://chevrotain.io/performance/). 

### Existing SPARQL/ SQL parsers

[Previous work](cite:cites modular-parsing) which introduced the concept of modular parsing for SPARQL contained a
detailed analysis of what tools were used by popular open-source SPARQL implementations.
Since an analysis of used methods to create query language parsers is relevant,
we repeat it here while extending their analysis to cover query languages such as
[SQL](cite:cites iso-sql), [GraphQL](cite:cites spec:graphql), [GQL](cite:cites iso-gql), and [Neo4J's cypher](cite:cites neo4j).   


<table>
    <thead><tr>
        <th>Software Package</th><th>Query Language</th><th>Parsing Software</th><th>Parser Generator</th>
    </tr></thead>
    <tbody><tr>
        <td markdown="1">
[Comunica](cite:cites comunica)
</td>
        <td>SPARQL</td>
        <td markdown="1">
[SPARQL.js](cite:cites sparqljs)
<sup class="screenonly"><a href="https://github.com/comunica/comunica/blob/94e1eacab069551590cc250074b36bce08720c4c/packages/actor-query-parse-sparql/package.json#L50">proof</a></sup>
</td>
        <td markdown="1">
[Jison](cite:cites jison)
<sup class="screenonly"><a href="https://github.com/RubenVerborgh/SPARQL.js/blob/13cc3d2ee4d2528b85d8b25cfbf886597dd100c1/lib/sparql.jison">proof</a></sup>
</td>
    </tr><tr>
        <td>[Yasgui](cite:cites yasgui)</td>
        <td>SPARQL</td>
        <td></td>
        <td><a href="https://www.swi-prolog.org/">SWI Prolog</a>
        <sup class="screenonly"><a href="https://github.com/TriplyDB/Yasgui/blob/4086f8ba5281e2781488dd83e1e2cc4af775cdc2/packages/yasqe/grammar/build.sh">proof</a></sup>
        </td>
    </tr><tr>
        <td><a href="https://jena.apache.org/">Apache Jena</a></td>
        <td>SPARQL</td>
        <td></td>
        <td><a href="https://javacc.github.io/javacc/">JavaCC</a>
        <sup class="screenonly"><a href="https://github.com/apache/jena/blob/3b6fb69d4ef78f4f130235a8fccb853291ea2b47/jena-arq/src/main/java/org/apache/jena/sparql/lang/sparql_10/SPARQLParser10.java">proof</a></sup>
        </td>
    </tr><tr>
        <td><a href="https://github.com/oxigraph/oxigraph">Oxigraph</a></td>
        <td>SPARQL</td>
        <td></td>
        <td><a href="https://github.com/kevinmehall/rust-peg">rust-peg</a>
        <sup class="screenonly"><a href="https://github.com/oxigraph/oxigraph/blob/2247319a1ff9132fd574d56db40f7178da938000/lib/spargebra/src/parser.rs#L778">proof</a></sup>
        </td>
    </tr><tr>
        <td><a href="https://github.com/stardog-union/millan">Stardog - Millan</a></td>
        <td>SPARQL</td>
        <td></td>
        <td><a href="https://chevrotain.io/docs/">Chevrotain</a>
        <sup class="screenonly"><a href="https://github.com/stardog-union/millan/blob/fc0c04b1818d20c68cf7fceb41f6ba0ee8258bd5/src/sparql/BaseSparqlParser.ts">proof</a></sup>
        </td>
    </tr><tr>
        <td><a href="https://virtuoso.openlinksw.com/">Virtuoso</a></td>
        <td>SPARQL</td>
        <td></td>
        <td><a href="https://www.gnu.org/software/bison/">Bison</a>
        <sup class="screenonly"><a href="https://github.com/openlink/virtuoso-opensource/blob/23cff6731d6f8f431bde314453ec07038cc62bf5/README.GIT.md#package-dependencies">proof</a></sup>
        </td>
    </tr><tr>
        <td><a href="https://github.com/blazegraph/database/">Blazegraph</a></td>
        <td>SPARQL</td>
        <td></td>
        <td><a href="https://javacc.github.io/javacc/">JavaCC</a>
        <sup class="screenonly"><a href="https://github.com/blazegraph/database/blob/829ce8241ec29fddf7c893f431b57c8cf4221baf/sparql-grammar/src/main/java/com/bigdata/rdf/sail/sparql/ast/sparql.jj">proof</a></sup>
        </td>
    </tr><tr>
        <td><a href="https://www.ontotext.com/products/graphdb/">GraphDB</a></td>
        <td>SPARQL</td>
        <td><a href="https://rdf4j.org/">RDF4J</a>
        <sup class="screenonly"><a href="https://github.com/eclipse-rdf4j/rdf4j/tree/b33d91485502d2f5266916c0581960e41b8f28b5/core/queryparser/sparql/JavaCC">proof</a></sup>
        </td>
        <td><a href="https://javacc.github.io/javacc/">JavaCC</a>
        <sup class="screenonly"><a href="https://github.com/eclipse-rdf4j/rdf4j/tree/b33d91485502d2f5266916c0581960e41b8f28b5/core/queryparser/sparql/JavaCC">proof</a></sup>
        </td>
    </tr>

<!------------- SQL ------------------>
    <tr>
        <td>[DuckDB](cite:cites duckdb)</td>
        <td>SQL</td>
        <td></td>
<!-- Uses bison/flex to generate lexer:
https://github.com/duckdb/duckdb/blob/main/scripts/generate_flex.py using https://github.com/duckdb/duckdb/blob/main/third_party/libpg_query/scan.l
Parser is generated in: https://github.com/duckdb/duckdb/blob/main/scripts/generate_grammar.py using 
https://github.com/duckdb/duckdb/tree/main/third_party/libpg_query/grammar
-->
        <td><a href="https://www.gnu.org/software/bison/">Bison</a>
        <sup class="screenonly"><a href="https://github.com/duckdb/duckdb/tree/main/third_party/libpg_query">proof</a></sup>
        </td>
    </tr><tr>
        <td>PostgreSQL</td>
        <td>SQL</td>
        <td></td>
        <td><a href="https://www.gnu.org/software/bison/">Bison</a>
        <sup class="screenonly"><a href="https://github.com/postgres/postgres/blob/master/src/backend/parser/gram.y">proof</a></sup>
        </td>
    </tr><tr>
        <td>SQLite</td>
        <td>SQL</td>
        <td></td>
        <td><a href="https://github.com/sqlite/sqlite/blob/master/doc/lemon.html">Lemon</a>
        <sup class="screenonly"><a href="https://github.com/sqlite/sqlite/blob/master/README.md?plain=1#L247-L253">proof</a></sup>
        </td>
    </tr>

<!--- TODO: GraphQL ---->
    <tr>
        <td>GraphQL</td>
        <td>GraphQL</td>
        <td></td>
        <td><a href="https://github.com/sqlite/sqlite/blob/master/doc/lemon.html">Lemon</a>
        <sup class="screenonly"><a href="https://github.com/sqlite/sqlite/blob/master/README.md?plain=1#L247-L253">proof</a></sup>
        </td>
    </tr>
<!--- TODO: GQL ---->
    <tr>
        <td>GraphQL</td>
        <td>GQL</td>
        <td></td>
        <td><a href="https://github.com/sqlite/sqlite/blob/master/doc/lemon.html">Lemon</a>
        <sup class="screenonly"><a href="https://github.com/sqlite/sqlite/blob/master/README.md?plain=1#L247-L253">proof</a></sup>
        </td>
    </tr>
<!--- TODO: Cypher ---->
    <tr>
        <td>Neo4J</td>
        <td>Cypher</td>
        <td></td>
        <td><a href="https://github.com/sqlite/sqlite/blob/master/doc/lemon.html">Lemon</a>
        <sup class="screenonly"><a href="https://github.com/sqlite/sqlite/blob/master/README.md?plain=1#L247-L253">proof</a></sup>
        </td>
    </tr>

</tbody>
</table>


### AST structures (round tripping)

Round tripping/ AST manipulation targets language tooling

Babel.js

### Transformations?

Algebra transformations are required for rewriting/ optimizations.

RDF star?

### Query generation(?)/ text generation (?)

Might not be needed since it could be covered in AST structures.
