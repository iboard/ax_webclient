# WebClient for [Altex](https://github.com/iboard/altex)

[![Documentation](https://img.shields.io/badge/docs-hexpm-blue.svg)](http://hexdocs.pm/ax_webclient/)
[![Elixir CI](https://github.com/iboard/ax_webclient/actions/workflows/elixir.yml/badge.svg)](https://github.com/iboard/ax_webclient/actions/workflows/elixir.yml)


A basic web client for the Altex applications. This is a Phoenix application
excluding ecto nut using Altex-modules by referencing them as a path-dependency
until we have a releas where we have published each single Altex-project as a
Hex package.

## Altex Mix projects

- `../[axentity][]` A general "Entity" protocol. Entities are wrapper around any
   valid term and makes it possible to store those data in a "Repository".

- `../[axrepo][]` A general "Data repository" to persist and load `Entities` from
  somewhere. Axrepo provides an In-Memory and a On-Disk implementation. If
  you think an application without a SQL-database isn't a real application,
  its up to you to just implement a SQL-implementation.

- `../[ax_webclient][]` This package. [See in action...](https://altex.iboard.cc)
  The web-page made out from path `altex/altex_iboard_cc` in this code repository.
 
## Hex Packages

- [axentity hex.pm][]
- [axrepo hex.pm][]
- [ax_webclient hex.pm][]

[axentity]: https://github.com/iboard/axentity
[CIB axentity]: https://github.com/iboard/axentity/actions/workflows/elixir.yml/badge.svg
[DB axentity]: https://img.shields.io/badge/docs-hexpm-blue.svg

[axrepo]: https://github.com/iboard/axrepo
[CIB axrepo]: https://github.com/iboard/axrepo/actions/workflows/elixir.yml/badge.svg
[DB axrepo]: https://img.shields.io/badge/docs-hexpm-blue.svg

[ax_webclient]: https://github.com/iboard/ax_webclient
[CIB ax_webclient]: https://github.com/iboard/ax_webclient/actions/workflows/elixir.yml/badge.svg
[DB ax_webclient]: https://img.shields.io/badge/docs-hexpm-blue.svg


[axentity hex.pm]: https://hex.pm/packages/axentity
[axrepo hex.pm]: https://hex.pm/packages/axrepo
[ax_webclient hex.pm]: https://hex.pm/packages/ax_webclient
