# syntax=docker/dockerfile:1
FROM golang:buster AS wkhtmltopodf-builder
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.buster_amd64.deb
RUN apt update && apt install -y fontconfig libfreetype6 libjpeg62-turbo libpng16-16 libx11-6 libxcb1 libxext6 libxrender1 xfonts-75dpi xfonts-base
RUN dpkg --install wkhtmltox_0.12.6-1.buster_amd64.deb


FROM wkhtmltopodf-builder AS builder
COPY go.mod /app/go.mod
COPY wkhtmltopdf-service/ /app/wkhtmltopodf-service/
WORKDIR /app/wkhtmltopodf-service/
RUN go build -o bin/wkhtmltopodf-service

FROM builder AS app
COPY wkhtmltopodf-proxy.sh /usr/local/bin/wkhtmltopodf-proxy.sh
ENTRYPOINT /app/wkhtmltopodf-service/bin/wkhtmltopodf-service
EXPOSE 9800

