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


### AST structures (round tripping)

Round tripping/ AST manipulation targets language tooling

### Transformations?

Algebra transformations are required for rewriting/ optimizations.

### Query generation(?)/ text generation (?)

Might not be needed since it could be covered in AST structures.
