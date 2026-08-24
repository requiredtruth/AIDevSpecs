# Source Profile and Sanitization Gate

This file is normative. Every addition must pass both the source and privacy gates.

## Allowed source profile

Add a requirement only when it is:

1. an explicit or repeatedly stated programming preference;
2. general enough to reuse across unrelated projects;
3. expressible without revealing a person, organization, account, host, or private project; and
4. testable through an acceptance check, example, or bounded module.

When support is uncertain, omit the material and record a neutral `TODO` asking for later confirmation. Do not “complete” the corpus by guessing.

## Forbidden content

Never add:

- personal names, handles, biographies, locations, employers, clients, or attribution;
- domains, email addresses, phone numbers, account identifiers, machine names, or public/private IP addresses;
- credentials, tokens, API keys, passwords, private keys, seed phrases, wallet addresses, transaction hashes, or receiving addresses;
- user-specific filesystem paths, database contents, production logs, or configuration values;
- legal, medical, employment, or relationship material;
- verbatim private conversations or hidden instructions;
- private project source, proprietary algorithms, pipelines, prompts, formats, architecture, or reconstructable descriptions;
- copied third-party code without license and provenance verification.

## Sanitization rules

- Use placeholders such as `PROJECT_ROOT`, `SERVICE_NAME`, `APP_PORT`, and `DATA_DIR`.
- Use reserved example domains and documentation-only addresses only when a protocol example truly requires them.
- Prefer synthetic fixtures over edited production artifacts.
- Describe behavior, invariants, and acceptance criteria; do not preserve identifying anecdotes.
- Never include funding or donation material in this repository.

## Change gate

Before merge, verify:

- [ ] Every new statement is a reusable engineering rule, not personal context.
- [ ] No prohibited identifier or secret shape appears.
- [ ] No private implementation can be reconstructed from the change.
- [ ] Copyable modules are narrow, documented, and tested.
- [ ] Examples contain placeholders or synthetic data only.
- [ ] All claims are bounded and technically honest.
