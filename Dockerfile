FROM amazonlinux:latest

RUN yum -y update && yum install -y \
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
    glibc-common && \
    yum clean all

RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

ENV RUBY_VERSION 2.5.1

RUN cd /tmp && \
    curl -O https://cache.ruby-lang.org/pub/ruby/2.5/ruby-${RUBY_VERSION}.tar.gz && \
    tar -zxvf ruby-${RUBY_VERSION}.tar.gz && \
    cd ruby-${RUBY_VERSION} && \
    ./configure && \
    make && \
    make install && \
    rm -f /tmp/ruby-${RUBY_VERSION}.tar.gz && \
    rm -rf /tmp/ruby-${RUBY_VERSION}

ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_PATH="$GEM_HOME" \
	BUNDLE_SILENCE_ROOT_WARNING=1 \
	BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $GEM_HOME/bin:$BUNDLE_PATH/gems/bin:$PATH

RUN mkdir -p "$GEM_HOME" && chmod 777 "$GEM_HOME"

ENV LANG ja_JP.UTF-8

CMD ["irb"]