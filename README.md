# lisp-intro

A simple website for short, casual introduction to Lisp.

## Contents

- What is Lisp: core idea, quotes from well-known people, short history
- Why it's elegant: uniform syntax, code as data, macros, closures, REPL
- Lisp today: classic AI, tools (Emacs, CAD), real-world systems
- Demo: sample code themes (algorithms, functional programming, web server, macros)
- References: books and Common Lisp community links
- Discussion: Lisp and future AI (with reference papers), real-world use, drawbacks and community

## Structure

- `web/`: website resources
  - `index.html`: English page
  - `ja/index.html`: Japanese page
  - `style.css`: shared stylesheet (light and dark mode)
- `samples/`: sample code
- `docs/`: specs for the sample code, plus Japanese guides to the Lisp syntax used (`docs/lisp/syntax.md`) and the SBCL REPL (`docs/lisp/sbcl-repl.md`)
- `docker/`: Docker environment (`compose.yaml`, Dockerfiles)
- `Taskfile.yaml`: commands to run the samples

## Usage

### Website

- No build step and no dependencies
- Open the pages directly in a browser (macOS):

```sh
open web/index.html      # English
open web/ja/index.html   # Japanese
```

- Or serve the folder locally:

```sh
python3 -m http.server -d web
```

- Then visit `http://localhost:8000/` (English) or `http://localhost:8000/ja/` (Japanese)

### Sample code

- Requires Docker (Docker Compose) and [Task](https://taskfile.dev) (`brew install go-task`). Each language runs in its own container, so no local SBCL, JDK, or gcc is needed
- Build the images (first time only):

```sh
task build
```

- Run the quicksort sample in Lisp, Java, Python, and C:

```sh
task quicksort
```

- Start the Lisp REPL (with `rlwrap`, so arrow keys and history work):

```sh
task repl
```

- Or log in to a container and work inside it (`samples/` is mounted read-only at `/samples`). The service name is `lisp`, `java`, `python`, or `c`:

```sh
docker compose -f docker/compose.yaml run --rm lisp bash
docker compose -f docker/compose.yaml run --rm java bash
docker compose -f docker/compose.yaml run --rm python bash
docker compose -f docker/compose.yaml run --rm c bash
```

```sh
# inside the container
sbcl --script 01-algorithms/quicksort/quicksort.lisp
rlwrap sbcl                                           # Lisp REPL (arrow keys work)
```
