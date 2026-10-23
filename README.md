# lisp-intro

Casual project of introduction to Lisp.

## Website

A short website that introduces Lisp, in English and Japanese. It covers:

- What Lisp is: the core idea, quotes from well-known people, and a short history
- Why it is elegant: uniform syntax, code as data, macros, closures, and the REPL
- Where it is used today: classic AI, tools such as Emacs and CAD, and real-world systems
- Demo: an overview of the sample code
- References: books and Common Lisp community links
- Discussion: Lisp and future AI (with papers), real-world use, drawbacks, and community

## Sample codes

Small programs that show what Lisp looks like. Some are also written in Java, Python, and C for comparison:

- Algorithms: quicksort and Fibonacci
- Functional programming: a pipeline and a DDD-style todo
- A web server
- Macros

## Structure

```text
lisp-intro/
├── README.md
├── Taskfile.yaml              # commands to open the website and run the samples
├── web/                       # website resources
│   ├── index.html             # English page
│   ├── ja/
│   │   └── index.html         # Japanese page
│   └── style.css              # shared stylesheet (light and dark mode)
├── samples/                   # sample code (each folder has its own README.md)
│   ├── 01-algorithms/
│   │   ├── fibonacci/         # Lisp (2 patterns), Java, Python, C
│   │   └── quicksort/         # Lisp, Java, Python, C
│   ├── 02-functional/
│   │   ├── pipeline/          # functional pipeline (Lisp)
│   │   └── todo-ddd/          # DDD todo (Lisp)
│   ├── 03-web-server/         # web server (Lisp)
│   └── 04-macros/             # my-unless macro (Lisp)
├── docs/
│   ├── lisp/
│   │   ├── syntax.md          # guide to the Lisp syntax used (Japanese)
│   │   └── sbcl-repl.md       # guide to the SBCL REPL (Japanese)
│   └── samples/               # specs for the sample code (mirrors samples/)
│       └── README.md
└── docker/                    # Docker environment
    ├── compose.yaml
    ├── c/Dockerfile
    ├── java/Dockerfile
    ├── lisp/Dockerfile
    └── python/Dockerfile
```

## Requirements

Works on macOS, Linux, and Windows.

- [Task](https://taskfile.dev): required on your local machine to run the `task` commands below. See the [installation guide](https://taskfile.dev/installation/):
  - macOS: `brew install go-task`
  - Linux: `brew install go-task`, or your package manager / the install script in the guide
  - Windows: `winget install Task.Task`, or `scoop install task`
- Docker (Docker Compose): only for the sample code. Each language runs in its own container, so no local SBCL, JDK, or gcc is needed
  - macOS / Windows: Docker Desktop
  - Linux: Docker Engine with the Compose plugin
- A web browser: for the website. `task open-web` opens `web/index.html` with `open` (macOS), `xdg-open` (Linux), or PowerShell `Start-Process` (Windows)

## Usage

### Website

- No build step and no dependencies
- Open the English page in the default browser (macOS, Linux, Windows):

```sh
task open-web
```

- Or open the pages directly in a browser from the command line:

```sh
open web/index.html        # macOS
xdg-open web/index.html    # Linux
start web\index.html       # Windows (cmd)
ii web\index.html          # Windows (PowerShell)
```

- The Japanese page is `web/ja/index.html`
- Or open the file with the file manager: double-click `web/index.html`, or drag it into a browser window

### Sample code

- See [Requirements](#requirements): Docker and Task are needed
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
