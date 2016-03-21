FROM quay.io/travisci/travis-ruby:latest

MAINTAINER Moza USANE <mozamimy@quellencode.org>

# Below environment variables should be modified by an user.
ENV USER mozamimy
ENV REPOSITORY rpn_calculator
ENV BRANCH master

USER travis

RUN /bin/bash -l -c "gem install bundler"
RUN /bin/bash -l -c "gem install travis"

WORKDIR /home/travis
RUN mkdir .travis
WORKDIR /home/travis/.travis
RUN git clone https://github.com/travis-ci/travis-build.git
RUN /bin/bash -l -c "bundle install --gemfile ~/.travis/travis-build/Gemfile"

WORKDIR /home/travis
RUN git clone https://github.com/$USER/$REPOSITORY.git

WORKDIR /home/travis/$REPOSITORY
RUN /bin/bash -l -c "travis compile > ~/build.sh"
# XXX: a dirty hack for invalid output of travis-build
RUN sed -i -e "s/branch\\\=\\\'\\\'/branch\\\=\\\'$BRANCH\\\'/" ~/build.sh

WORKDIR /home/travis
RUN chmod +x build.sh
