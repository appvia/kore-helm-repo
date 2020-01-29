FROM alpine/helm as helm-package
RUN apk add make curl
RUN curl -sSL https://github.com/mikefarah/yq/releases/download/2.4.1/yq_linux_amd64 > /usr/bin/yq && \
    chmod +x /usr/bin/yq
WORKDIR /app
COPY . .
RUN make helm-update
RUN make helm-package

FROM golang:1.12.7 as server
WORKDIR /app
COPY . .
RUN make build-web-static

FROM alpine:3.10
COPY --from=helm-package /app/charts /charts
COPY --from=server /app/bin/kore-helm-repo /

ENTRYPOINT [ "/kore-helm-repo" ]