# KOS build container

Place the trimmed `sh-elf.zip` in this directory, then build the image from
`/opt/toolchains/dc`:

```sh
docker build -t kos-dev docker
```

The image contains the trimmed C/C++ SH toolchain, shallow clones of the official
KOS and kos-ports repositories on their `master` branches, a KOS build, and the
installed `sh4zam` port. The repository and branch can be overridden with Docker
build arguments if needed.

Build the image, then start a shell with the KOS environment already sourced:

```sh
docker run --rm -it kos-dev
```

The entrypoint sources `kos/environ.sh` before starting the shell or command.
KOS and sh4zam are built during the Docker image build. To work on a project and
keep its files on the host, mount that project directory without covering the
container's KOS paths, for example:

```sh
docker run --rm -it -v "$PWD:/workspace" -w /workspace kos-dev
```
