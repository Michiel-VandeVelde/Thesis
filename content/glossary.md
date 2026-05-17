## Glossary 
{:.no-label-increment}

Media behaviour data
: Data generated when a user interacts with media services, such as playing a video, pausing content, skipping a song, listening to music, or entering a search query.

Media behaviour profile
: A structured representation derived from media behaviour data over time, including patterns such as preferred genres, typical moments of use, recurring interests, or cross-platform consumption habits.

Personal data
: Any information relating to an identified or identifiable natural person. Under the GDPR, this includes not only directly identifying information but also behavioural data that can be linked to an individual. In this thesis, media behaviour data recorded by streaming services constitutes personal data because it is tied to a specific user account and can reveal preferences, habits, and identity.

User-centric architecture
: An architecture in which the user remains the central point of control over where personal data is stored, who may access it, and under which conditions it may be used.

Data sovereignty
: The ability of a user or organisation to exercise meaningful control over data, including access, storage, sharing, and governance.

JSON-LD
: A serialisation format for RDF data that is valid JSON and uses a `@context` field to map JSON keys to semantic vocabulary terms.

Kvasir
: A personal data broker developed at imec-IDLab that exposes a Solid-compatible storage API. Kvasir organises data into schema-governed partitions called slices and uses ClickHouse for analytical storage and Redpanda for event-based change notifications.

Music Ontology
: An RDF vocabulary for describing music-related concepts, including tracks, recordings, artists, and listening events.

OpenFGA
: An open-source relationship-based authorisation engine that models permissions as typed relationships between objects, such as a user having a writer relationship on a specific slice.

Redpanda
: A Kafka-compatible distributed event streaming platform used in the prototype to publish change events from Kvasir slices to the aggregation processor.

Slice
: A schema-governed partition within a Kvasir pod. Each slice holds a specific type of data, such as music listening events or video watch events, and has its own access rules.

Solid
: An ecosystem of specifications and tools for decentralised personal data management, where users store data in personal online data stores.

Solid pod
: A decentralised personal data store controlled by the user, in which data can be stored, accessed, and shared through web standards.

Data vault
: A user-controlled storage environment for personal data. In this thesis, the term is closely related to the concept of a Solid pod.

WebID
: A globally unique web-based identifier used to identify a user or agent in the Solid ecosystem.

Solid-OIDC
: The authentication mechanism used in Solid, based on OpenID Connect, that allows applications to verify a user’s identity and request access to pod resources.

RDF
: A standard data model that represents information as triples consisting of a subject, predicate, and object.

Triple
: A single RDF statement consisting of a subject, predicate, and object.

URI
: A Uniform Resource Identifier used to uniquely identify resources, concepts, users, or relationships on the web.

Linked Data
: A method for publishing and connecting structured data on the web using shared identifiers and standard data models.

Web Access Control
: An access control mechanism used in Solid that defines permissions for agents, groups, applications, and resources.

Access Control Policy
: A more flexible Solid access control mechanism that can express detailed access rules and conditions.

ODRL
: The Open Digital Rights Language, used to express permissions, prohibitions, and duties related to data usage.

Policy engine
: A component that evaluates access and usage policies before allowing or denying a data request.

Aggregation agent
: A user-authorised component that combines media behaviour data from multiple services and produces an aggregated cross-service profile.

Change processor
: A component in the aggregation pipeline that consumes change events from Redpanda, derives a unified cross-service profile, and writes it back to the Kvasir pod.

Audit log
: A record of data access or usage, showing who accessed which data, when, and for what stated purpose.

LDES
: Linked Data Event Streams, a technique for publishing and processing timestamped event data incrementally.

Data space
: A governed ecosystem in which different organisations can share and use data according to common rules, standards, and trust mechanisms.

Interoperability
: The ability of independent systems or services to exchange, interpret, and reuse data consistently.

Mosaic effect
: The privacy risk that separate pieces of seemingly harmless data can reveal sensitive information when combined.