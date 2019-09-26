FROM ocaml/opam2:alpine-3.10-ocaml-4.08 as builder

RUN opam update
RUN sudo apk add m4
RUN opam depext ssl
RUN opam install dune cohttp-lwt-unix lwt_ssl

RUN mkdir /home/opam/app
WORKDIR /home/opam/app

ENV PATH=/home/opam/.opam/4.08/bin:$PATH
COPY . .
RUN dune build ./http_client.exe --profile=static

FROM alpine:latest
COPY --from=builder /home/opam/app/_build/default/http_client.exe /app/http_client.exe
CMD ["/app/http_client.exe"]

