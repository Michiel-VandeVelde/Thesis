## Performance analysis
{:#perf}

In this section we investigate the execution time performance of our Traqula parsing,
comparing different modes available in Traqula, comparing it with [SPARQL.JS](cite:cites sparqljs)/[SPARQLAlgebra.JS](cite:cites sparqlalgebrajs),
and providing a warning on parser reuse.   


[](#traqula-bench) compares the execution time of Traqula using varous targets and parser capabilities.
The figure shows that patching a modular SPARQL 1.1 parser to support SPARQL 1.2 increases the execution time only slightly,
measuring a mean execution time increase of 6.13% <span class="todo">(5.71/5.38)</span>.
In comparison to that cost, the cost to track source information is a little bigger due to the added complexity in the lexing process,
namely 16.5% <span class="todo">(6.27/5.38)</span>, and 17.5% <span class="todo">(6.71/5.71)</span> in the case of SPARQL 1.1 and SPARQL 1.2 parsing respectively.
Similarly, parsing into algebra, meaning you parse into AST and perform some additional transformation comes increases the executiontime further, measuring an increase of
58.7% <span class="todo">(8.54/5.38)</span> and 63.4% <span class="todo">(9.33/5.71)</span> for 1.1 and 1.2 respectively.

It should be noted that these seemingly large costs are still small in comparison to the execution time difference between Traqula and SPARQL.JS,
we measure a mean execution time of 5.38ms for Traqula, and 38.17ms for SPARQL.JS, effectively a difference of 709.5%; even-though Traqula generates a more correct/ complete AST.
This difference be mostly devoted to the chosen system to construct the parser, meaning Chevrotain is just really fast.
Taking the algebra comparison into account, the mean execution time difference is dampened,
Traqula parses in 8.54ms, while SPARQLAlgebra.Js using SPARQL.JS takes 39.69ms, which is only a difference of 464.8%.

<figure id="traqula-bench">
<img src="/img/boxplots.svg" alt="Traqula bench">
<figcaption markdown="block">
Boxplot comparing the execution time in ms for parsing a collection of 199 queries into
<!-- -->
1. an AST,
2. an AST with source tracking (allowing round-tripping), and
3. sparql algebra.
We run the comparison using 1000 iterations on a SPARQL 1.1 parser and a SPARQL 1.2 parser that is created as a patch ontop of the 1.1 parser.
</figcaption>
</figure>

We end our performance analysis by denoting that the choice to create the parser within a non-compiled language like TypeScript comes at a cost.
namely, the optimization of the parser is done in execution time.
This means that creating a parser is computationally expensive, since the optimization happens when you create a parser.
One should therefore always reuse their Traqula parser whenever possible. The mean execution time of parsing our 199 queries,
disregarding query engine execution is 5.38ms, while parsing those same queries, but creating a new parser for every query takes 2572.03ms,
which 478.07 times slower. 

