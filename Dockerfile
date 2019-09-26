FROM ocaml/opam2:alpine-3.10-ocaml-4.08 as builder

RUN opam update
RUN sudo apk add m4
RUN opam depext ssl
RUN opam install dune cohttp-lwt-unix lwt_ssl

WORKDIR /app
COPY ./ ./
RUN sudo chown opam:opam -R .
RUN dune build @all --profile=static

FROM alpine:latest
COPY --from=builder /app/_build/default/http_client.exe /app/http_client
CMD ["/app/http_client.exe"]

