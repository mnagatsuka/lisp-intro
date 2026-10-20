COMPOSE = docker compose -f docker/compose.yaml
RUN = $(COMPOSE) run --rm
QS  = 01-algorithms/quicksort
FIB = 01-algorithms/fibonacci
PL  = 02-functional/pipeline
TD  = 02-functional/todo-ddd
MC  = 04-macros

.PHONY: build quicksort fib pipeline todo server macro

build:
	$(COMPOSE) build

quicksort:
	@echo "== Lisp ==";   $(RUN) lisp sbcl --script $(QS)/quicksort.lisp
	@echo "== Java ==";   $(RUN) java java $(QS)/Quicksort.java
	@echo "== Python =="; $(RUN) python python $(QS)/quicksort.py
	@echo "== C ==";      $(RUN) c sh -c "gcc -O2 -o /tmp/qs $(QS)/quicksort.c && /tmp/qs"

fib:
	@echo "== Lisp ==";         $(RUN) lisp sbcl --script $(FIB)/fib.lisp
	@echo "== Lisp (typed) =="; $(RUN) lisp sbcl --script $(FIB)/fib-typed.lisp
	@echo "== Java ==";         $(RUN) java java $(FIB)/Fib.java
	@echo "== Python ==";       $(RUN) python python $(FIB)/fib.py
	@echo "== C ==";            $(RUN) c sh -c "gcc -O2 -o /tmp/fib $(FIB)/fib.c && /tmp/fib"

pipeline:
	@$(RUN) lisp sbcl --script $(PL)/pipeline.lisp

todo:
	@$(RUN) lisp sbcl --script $(TD)/todo.lisp

server:
	@$(COMPOSE) up --build server

macro:
	@$(RUN) lisp sbcl --script $(MC)/my-unless.lisp
