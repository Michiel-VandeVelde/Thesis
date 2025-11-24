## Architecture
{:#architecture}

The concept of our core architecture for parser has been explained in [our previous work](cite:cites modular-parsing).
In this work, we go into more detail on the actual implemented architecture in Traqula and extend the vision towards
indirected generation and generic indirection.

### Loose coupling through indirection

The core idea of Traqula is to introduce a level of indirection when declaring your parser, generator or generic indirection.
This is done by declaring modular components and accessing them through a named index.
For example, when you define your transformation functions, instead of defining a function and calling that function,
you define an indirection component using a name and an anonymous function as implementation.
The anonymous function gets some task-specific helpers which depend on the task performed, and are listed in [](#task-helpers).
It should be noted that all indirection tasks have the `SUBRULE` helper to call an indirected function.
The result of this first anonymous function should be another function that gets the execution context (similar to `this`),
and some function-specific parameters.
<span class="todo">add a small example listing - can be left: component; right: builder</span>

<figure id="task-helpers" class="table">

<table>
    <thead><tr>
        <th>parser indirection</th><th>generator indirection</th><th>general indirection</th>
    </tr></thead>
    <tbody><tr>
        <td>SUBRULE[0-9]?</td><td>SUBRULE</td><td>SUBRULE</td>
    </tr><tr>
        <td>CONSUME[1-9]?</td><td>PRINT</td><td></td>
    </tr><tr>
        <td>OPTION[1-9]?</td><td>ENSURE</td><td></td>
    </tr><tr>
        <td>OR[1-9]?</td><td>ENSURE_EITHER</td><td></td>
    </tr><tr>
        <td>MANY[1-9]?</td><td>NEW_LINE</td><td></td>
    </tr><tr>
        <td>MANY_SEP[1-9]?</td><td>HANDLE_LOC</td><td></td>
    </tr><tr>
        <td>AT_LEAT_ONE[1-9]?</td><td>CATCHUP</td><td></td>
    </tr><tr>
        <td>AT_LEAT_ONE_SEP[1-9]?</td><td>PRINT_WORD</td><td></td>
    </tr><tr>
        <td>ACTION</td><td>PRINT_WORDS</td><td></td>
    </tr><tr>
        <td>BACKTRACK</td><td>PRINT_ON_EMPTY</td><td></td>
    </tr><tr>
        <td></td><td>PRINT_ON_OWN_LINE</td><td></td>
    </tr>
</tbody>
</table>

<figcaption markdown="block">
List of helpers provided for the three specific indirection tasks provided by Traqula, namely: parsing, generating and generic indirection.
It should be noted that all parser indirection rules are provided by the [Chevrotain library](cite:cites chevrotain).
<span class="todo">an explanation on each of these helpers would be nice, but I do not know how we can do that compactly.</span>
</figcaption>
</figure>

### Builder pattern

In the previous section, we introduced the concept of indirection,
in this section, we describe how this indirection map should be managed,
namely, through a task specific [builder](https://refactoring.guru/design-patterns/builder).
A builder is a software design pattern that helps you create complex objects,
by describing the creation step by step.
Traqula's core library manages three builders, a parser-, generation-, and indirection-builder, which all have the same functionality:

- **create**: creates a builder either as a copy from another builder, or from a list of initial rules.
- **widen context**: widens the type of the context (alternative to `this`) for all rules in the builder.
- **type patch**: patch the type (TypeScript specific) of a collection of rules, allows you to change the type API of the builder after an invasive patch.
- **patch rule**: patches a single already registered rule with a new implementation.
- **add rule**: add a single new rule.
- **add many**: add a collection of new rules.
- **delete rule**: delete a single rule from the builder.
- **get rule**: get the indirection component registered under some name.
  When types have been changed, or context widened, the returned component will reflect these changes.
- **merge**: Merge this builder with another one, changing this builder.
  (somewhat comparable to [ANTLR's import](https://github.com/antlr/antlr4/blob/857fb46e781ce9c40249b9f0156c67051cec12c1/doc/grammars.md#grammar-imports))
- **build**: Build a single parser, generator, or generic indirection object from the given builder.

The importance of the type rules will be further discussed in [TODO]() and plays a vital rule in the maintainability of your modular system.

### Transformers

One of Traqula's goals is to facilitate the creation of translations between different query languages, whether they are completely different or just dialects.
This translation/ compilation/ transpilation will enable federated querying to overcome the problems they face in a heterogeneous query environment.
In order to facilitate this transformation on different levels for different languages,
Traqula exposes a versatile, yet optimized generic transformer/ visitor.
The transformer facilitates the transformation process by having an API that dynamically changes to reflect
the AST/algebra you want to manipulate by harnessing generics using TypeScripts strong (turing complete) type system.
Similar to rewriting,
the transformer facilitates the reformatting process since reformatting can be considered a transformation on AST level between the same AST types.

To utilize the provided transformer, simply create a new transformer object, with optional default transformation contexts,
and declaring the types your AST contains.
You can guide the transformation process by registering _'preVisitors'_ that return a transformation context;
allowing you to:
<!-- -->
1. shortcut, stopping the discovery of to be transformed nodes;
2. continue, continuing the search for nodes to transform within the descendants;
3. ignore keys, allowing you to specify which keys of the current node should not be visited;
4. shallow keys, declare which keys should only be shallowly copied;
5. copy, state that the current node should be copied. 
<!-- -->
Using the preVisitor, the transformer builds a stack of _'to be transformed nodes'_,
an element is transformed once it is popped from that stack; meaning the descendants have been transformed already.
[](#transformer) shows an example algebraic transformation that wraps a 'distinct' around the first project it finds.


<figure id="transformer">
<pre style="overflow: auto"><code class="language-typescript" style="background: unset; font-size: 0.8em">new TransformerTyped&lt;Sparql11Nodes&gt;()
  .transformNode({
    type: Algebra.Types.SLICE,
    input: {
      type: Algebra.Types.PROJECT,
      input: {
        type: Algebra.Types.JOIN,
        input: [{ type: Algebra.Types.PROJECT }, { type: Algebra.Types.BGP }],
      },
    },
  }, {
    [Algebra.Types.PROJECT]: {
      preVisitor: () => ({ continue: false }),
      transform: projection => algebraFactory.createDistinct(projection),
    },
  });</code></pre>
<figcaption markdown="block">
Example transformation wrapping a 'distinct' node around the first 'project' node within the node provided as a first argument of the transformer function.
</figcaption>
</figure>



### Modules

In order to maximize independent evolution, Traqula exists as many small interlinked packages, instead of a single big package that does it all.
As a user of Traqula, that means you need only depend on what you actually need.
For example, if you only need parsing for SPARQL 1.1,
you just depend on _'@traqula/parser-sparql-1-1'_,
allowing you to ignore that we also maintain a parser for SPARQL 1.2, or that Traqula also has generators etc.
The architectural decision away from monoliths is typical, especially when modularity is of high importance.
Modularity also forces Traqula's various package API's to be sufficiently open for extensions,
since traqula itself needs to go through those same package APIs.
In order to keep Traqula maintainable from a version control perspective, it is managed in a single Git/ GitHub repository under the Comunica organisation:
[https://github.com/comunica/traqula](https://github.com/comunica/traqula).
