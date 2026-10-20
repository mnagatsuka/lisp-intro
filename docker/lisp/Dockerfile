FROM debian:bookworm-slim
RUN apt-get update \
    && apt-get install -y --no-install-recommends sbcl curl ca-certificates libssl3 \
    && rm -rf /var/lib/apt/lists/*
# Quicklisp を入れ、Hunchentoot をビルド時に取得・コンパイルしておく（実行時はネットワーク不要）
RUN curl -fsSL -o /tmp/quicklisp.lisp https://beta.quicklisp.org/quicklisp.lisp \
    && sbcl --non-interactive \
        --load /tmp/quicklisp.lisp \
        --eval '(quicklisp-quickstart:install :path "/opt/quicklisp/")' \
        --load /opt/quicklisp/setup.lisp \
        --eval '(ql:quickload :hunchentoot)' \
    && rm /tmp/quicklisp.lisp
WORKDIR /samples
