## Requirements
{:#requirements}

Traqula has been created in order to cover some specific requirements, in this section we list the most important ones,
covering modularity, round tripping generation, using web-based technologies, and being sufficiently generic to adopt other query languages.


### Modularity

The required modularity of Traqula is grounded in both existing and future heterogeneity of the SPARQL language.
The SPARQL language already knows many dialects of the SPARQL 1.1 query language,
and the practical heterogeneity is expected to grow even more
as the SPARQL 1.2 specification is being finalized and the working-group prepares for
maintenance mode; which will allow for a more rapid evaluation of the SPARQL language specification [](cite:cites modular-parsing).
Since migration from RDF 1.1 to RDF 1.2 is not trivial, introducing the concept of recursive triples in the form of triple terms [](cite:cites rdf-1-2),
the authors expect that migration will require careful consideration by many, slowing down adoption.

Even though the problem of language dialects is not unique to the SPARQL language, e.g. SQL knows many dialects,
the nature of the RDF data model, to allow seamless integration of multiple datasets,
makes the query heterogeneity issue specifically important to solve.
This nature is reflected in the SPARQL specification itself as [federated queries](cite:cites spec:sparqlfed).
When a user-query is written in one version/dialect,
it is possible that the federation target expects a different version/dialect, a visualisation in provided in [](#federation).
The [SPARQL service description specification](cite:cites spec:sparqlservicedesc)
exists exactly to allow SPARQL endpoints to describe their supported features and limitations.


<figure id="federation">
<img src="img/traqula-representations.svg" alt="Visual representation of the interface" style="object-fit: contain;"/>
<figcaption markdown="block">
Schematic representation of federated querying in a heterogeneous SPARQL landscape.   
</figcaption>
</figure>

Besides the potential to mitigate the heterogeneity issue,
modularity also allows researchers and practitioners to rapidly test new language features.
Traqula has already served its purpose in this regard.
The modular query framework **Comunica has already been adopted to use Traqula** as its parser,
generator, and algebra representation and manipulation library.
By harnessing the modularity of both Traqula and Comunica,
the authors have been able to assist in the standardisation of SPARQL 1.2.

### Round tripping 

Editor tooling / linter


### Web-based


High cost to get data from JS to webasm


### Strong core

Core needs to provide facilitation for other query languages too
