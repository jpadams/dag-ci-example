package main

import ( "alpha.dagger.io/dagger"
         "alpha.dagger.io/os"
	 "alpha.dagger.io/docker"
)

src: dagger.#Artifact & dagger.#Input
target: "localhost:5000/helloworld:1.0"

test: os.#Container & {
    image: docker.#Pull & { from: "golang:1.16-alpine" }
    mount: "/app": from: src
    command: "go test -v ./..."
    dir:     "/app"
}

lint: os.#Container & {
    image: docker.#Pull & { from: "golangci/golangci-lint:v1.39.0" }
    mount: "/app": from: src
    command: "golangci-lint run -v"
    dir:     "/app"
}

build: docker.#Build & {
    source: src
    args: { "-t": target }
}

push: docker.#Push & {
    source: build
    target: target
}
