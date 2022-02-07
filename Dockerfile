FROM docker.io/library/golang:1.17-alpine

ARG GIT_REPO
ARG GIT_BRANCH

RUN set -e ; \
    apk add --no-cache git ; \
    cd /tmp ; \
    git clone ${GIT_REPO} -b ${GIT_BRANCH} src ; \
    cd /tmp/src ; \
    echo "Pre-requisites..." ; \
    if [ -f tools.go ]; then \
      go install -v $(go list -f '{{join .Imports " "}}' tools.go); \
    fi ; \
    echo "Code generation..." ; \
    go generate ./... ; \
    echo "Compilation..." ; \
    go build -o /app ; \
    cd / ; \
    rm -rf /tmp/src
EXPOSE 8080
ENTRYPOINT [ "/app" ]
CMD [ ]

