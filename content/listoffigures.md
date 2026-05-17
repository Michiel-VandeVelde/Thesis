## List of figures
{:.no-label-increment}

- **Fig. 1:** Individual data fragments, each seemingly harmless in isolation, combine to form a detailed and revealing profile of a person. Own work.
- **Fig. 2:** Organisational structure tends to mirror system design. Adapted from Sketchplanations, "Conway's Law" [7].
- **Fig. 3:** Key principles of a user-centric media profile architecture. Own work.
- **Fig. 4:** Solid pod resources accessed via HTTP verbs, showing read, write, and append operations by different actor types. Own work.
- **Fig. 5:** The user's pod partitioned into three containers at different sensitivity levels, with access rules per partition. Own work.
- **Fig. 6:** WebID and Solid-OIDC enabling a user to authenticate across independent services using a single user-controlled identity document. Own work.
- **Fig. 7:** The ODRL policy layer intercepts access requests and evaluates them against user-defined permissions, prohibitions, and duties. Own work.
- **Fig. 8:** The aggregation agent reads only new events from each service partition using LDES, derives a unified cross-service profile, and writes it back to the pod. Own work.
- **Fig. 9:** The five architectural building blocks and their interactions, showing the full data flow from ingestion through aggregation to consumption. Own work, created with AI assistance.
- **Fig. 10:** European Strategy for Data: a common European data space enabling trusted and interoperable data sharing across sectors. Adapted from European Commission, *A European Strategy for Data* [20].
- **Fig. 11:** The five requirement areas that any valid user-centric media behaviour profile architecture must address, as established in the literature study. Own work.
- **Fig. 12:** System architecture of the prototype, showing the Kvasir User Pod, identity and authentication layer, aggregation pipeline, logging layer, and policy enforcement as future work. Own work.
- **Fig. 13:** A committed change report in Kvasir showing the six RDF triples written to the music-tracker slice for a single listen event. Own work.
- **Fig. 14:** A GraphQL query against the video-tracker slice returning the six most recent watch events, executed through Kvasir's GraphiQL interface. Own work.
