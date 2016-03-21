# travis-runner

This Dockerfile (travis-runner) is a proof of concept how to use a docker image [travisci/travis-ruby](https://quay.io/repository/travisci/travis-ruby) for checking behavior of your test code on Travis CI.

## Purpose of travis-runner

We learn how to use Travis CI by trial and error when we consider a complex build process.

In the situation, we have to create new branch and merge it to main branch repeatedly if we do not have any way to run Travis CI locally.

If a docker image of Travis CI can run locally, the trial and error gets more effective and does not hurt programmers.

## Usage

Assuming that your system has docker toolkit.

### Modify environment variables

Pull this repository, and put your GitHub account, your project name, and target branch in L.6-8 of Dockerfile.

```dockerfile
# Below environment variables should be modified by an user.
ENV USER (your GitHub account name)
ENV REPOSITORY (your project name)
ENV BRANCH (target branch)
```

### Build a docker image

Move to a directory contains this Dockerfile, and execute below command.

```
# docker build -t travis-runner .
```

The build process takes a lot of time, you can break with a cup of tea :tea:

### Run test on a docker container

Build script is generated to `/home/travis/build.sh` in a container. Just kick the build script as travis user like,

```
# docker run -i -t -u travis travis-runner /home/travis/build.sh
```

## Known problems

Build script generator [travis-build](https://github.com/travis-ci/travis-build) generates a build script from .travis.yml, but it seems to have some bugs.

### Multiple ruby versions

If .travis.yml has multiple ruby versions like below snippet, travis-build generates an invalid build script.

```yaml
rvm:
  - 2.1.7
  - 2.2.3
  - 2.3.0
```

So we should specify only one ruby version in .travis.yml like this,

```yaml
rvm: 2.3.0
```

### Branch name

At line 27 in this Dockerfile, there is a dirty hack for a generated build script.

```dockerfile
RUN sed -i -e "s/branch\\\=\\\'\\\'/branch\\\=\\\'$BRANCH\\\'/" ~/build.sh
```

## LISENCE

MIT
