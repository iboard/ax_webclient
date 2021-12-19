%{
  title: "About",
  author: "Andi",
  tags: ["andi", "2021", "altex"]
}
---
# About Altex

**Altex** is a bunch of mix projects, collaborating to support a clean
architecture and a well crafted system. Yes, think about an Umbrella project
but just without the umbrella, thus the several projects are completely independent from each other.

<center class="max-w-prose"><img src="https://e-matrix.at/assets/ematrix-large.png" width="196px" style="margin: 1rem; margin-top: 2rem;"></center>

At e-Matrix Innovations, we use Altex as a base/scaffold implementation for all our 
Phoenix-applications and -services.

<div class="mb-10 mt-10"></div>

# Parts Of Altex

- [axentity](https://hex.pm/packages/axentity)
- [axrepo](https://hex.pm/packages/axrepo)
- and this, [ax_webclient](https://hex.pm/packages/ax_webclient)



## Entity

A wrapper around any kind of data. Can be used in a repository (`axrepo`). `Entity` also
keeps track of errors and validation (a bit like Ecto's Changeset).

## WebClient

You just read from the `WebClient`. The web client uses `NibleParser` to show 
a little "blog" at `/`.
At the root path we render the index of all posts and `/posts/:id` renders a single post (`WebClient.Post`). 

Where the posts are being read from the directory
`priv/posts/YEAR/DD-MM-TITLE.md` at **compile time!**
The directory structure gets parsed everytime the
module `WebClient.Post` is compiled.

## Installation

First clone the repository 

```
git clone https://github.com/iboard/ax_webclient
```

which uses `axrepo` and `axentity`.

```elixir
def deps do
  [
    #{:axentity, "~> 0.1"}
    {:axrepo, "~> 0.1"}
  ]
end
```

> _NOTE_: it is not necessary to add `:axentity` when you already use `:axrepo`.

Now `cd` into your newly created directory and run

```
mix deps.get
mix test
```

## Start a local server

If everything works fine, you can start your local web-server with

```bash
mix phx.server
```

or, in order you have a REPL into your application, you may use:

```bash
iex -S mix phx.server
```

Once the server is running you can access it at 
[http://localhost:4000](http://localhost:4000)

## Current status

The primary scaffold for CI at GitHub is implemented.

|mix project|CI|documentation|
|-----------|--|-------------|
| [axentity][] | [![CIB axentity][]](https://github.com/iboard/axentity/actions/workflows/elixir.yml) | [![DB axentity][]](https://hexdocs.pm/axentity) |
| [axrepo][] | [![CIB axrepo][]](https://github.com/iboard/axrepo/actions/workflows/elixir.yml) | [![DB axrepo][]](https://hexdocs.pm/axrepo) |
| [ax_webclient][] | [![CIB ax_webclient][]](https://github.com/iboard/ax_webclient/actions/workflows/elixir.yml) | [![DB ax_webclient][]](https://hexdocs.pm/ax_webclient) |


<div class="mt-10 markdown bg-white p-4 shadow rounded-md">
  <img src="/images/altex.svg" class="p-10"/>
</div>

<div class="mb-40"></div>
---
_**MORE TO COME, stay tuned!**_


For now, please see the tests to get a glue what this app is doing.


[axentity]: https://github.com/iboard/axentity
[CIB axentity]: https://github.com/iboard/axentity/actions/workflows/elixir.yml/badge.svg
[DB axentity]: https://img.shields.io/badge/docs-hexpm-blue.svg

[axrepo]: https://github.com/iboard/axrepo
[CIB axrepo]: https://github.com/iboard/axrepo/actions/workflows/elixir.yml/badge.svg
[DB axrepo]: https://img.shields.io/badge/docs-hexpm-blue.svg

[ax_webclient]: https://github.com/iboard/ax_webclient
[CIB ax_webclient]: https://github.com/iboard/ax_webclient/actions/workflows/elixir.yml/badge.svg
[DB ax_webclient]: https://img.shields.io/badge/docs-hexpm-blue.svg
