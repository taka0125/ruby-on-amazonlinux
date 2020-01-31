ARG RUBY_VERSION
ARG BUNDLER_VERSION
ARG RUBY_MAJOR_VERSION

FROM amazonlinux:latest

RUN set -ex && \
    yum -y update && \
    yum groupinstall -y "Development Tools" && \
    yum install -y \
      tar \
      locales \
      gzip \
      gcc-c++ \
      readline-devel \
      zlib-devel \
      libyaml-devel \
      libffi-devel \
      openssl-devel \
      make \
      bzip2 \
      autoconf \
      automake \
      libtool \
      bison \
      glibc-common \
      libxml2-devel \
      libxslt-devel \
      wget \
      which \
      vim \
      && \
    yum clean all

RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN set -ex && \
    cd /tmp && \
    curl -O https://cache.ruby-lang.org/pub/ruby/${RUBY_MAJOR_VERSION}/ruby-${RUBY_VERSION}.tar.gz && \
    tar -zxvf ruby-${RUBY_VERSION}.tar.gz && \
    cd ruby-${RUBY_VERSION} && \
    ./configure && \
    make && \
    make install && \
    rm -f /tmp/ruby-${RUBY_VERSION}.tar.gz && \
    rm -rf /tmp/ruby-${RUBY_VERSION}

RUN mkdir -p /usr/local/etc \
	&& { \
		echo 'install: --no-document'; \
		echo 'update: --no-document'; \
	} >> /usr/local/etc/gemrc

ENV GEM_HOME /usr/local/bundle

ENV BUNDLE_PATH="$GEM_HOME" \
    BUNDLE_SILENCE_ROOT_WARNING=1 \
    BUNDLE_APP_CONFIG="$GEM_HOME"

ENV PATH $GEM_HOME/bin:$BUNDLE_PATH/gems/bin:$PATH

RUN mkdir -p "$GEM_HOME" && chmod 777 "$GEM_HOME"

RUN set -ex && \
    gem update --system && \
    gem install bundler:$BUNDLER_VERSION

CMD ["irb"]
