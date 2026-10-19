# lisp-intro

A simple website for short, casual introduction to Lisp.

## Contents

- What is Lisp: core idea, quotes from well-known people, short history
- Why it's elegant: uniform syntax, code as data, macros, closures, REPL
- Lisp today: classic AI, tools (Emacs, CAD), real-world systems
- References: books and Common Lisp community links
- Discussion: Lisp and future AI (with reference papers), real-world use, drawbacks and community

## Structure

- `index.html`: English page
- `ja/index.html`: Japanese page
- `style.css`: shared stylesheet (light and dark mode)

## Usage

- No build step and no dependencies
- Open the pages directly in a browser (macOS):

```sh
open index.html      # English
open ja/index.html   # Japanese
```

- Or serve the folder locally:

```sh
python3 -m http.server
```

- Then visit `http://localhost:8000/` (English) or `http://localhost:8000/ja/` (Japanese)
