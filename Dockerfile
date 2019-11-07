#################################################################################################################################
# 
# Copyright 2019 Ray Elenteny
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
# modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software
# is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
# IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
#################################################################################################################################
#
# Construct an image configured with pyenv. The image can be used directly, or it can be extended and configured to build an
# image with a specific version of python installed.
#
#################################################################################################################################
#
# Image path: relenteny/pyenv:1.2.14
#
#################################################################################################################################

FROM relenteny/alpine:3.10.2

LABEL relenteny.repository.url=https://github.com/relenteny/pyenv
LABEL relenteny.repository.tag=1.2.14
LABEL relenteny.pyenv.version=1.2.14
LABEL relenteny.pyenv.virtualenv.version=1.1.5

COPY build /opt/build

USER root

RUN set -x && \
    apk add --no-cache git bash build-base libffi-dev openssl-dev bzip2-dev zlib-dev readline-dev sqlite-dev && \
    cp -r /opt/build/home/alpine/* /home/alpine && \
    chmod +x /home/alpine/bin/*.sh && \
    chown -R alpine.alpine /home/alpine && \
    rm -rf /opt/build

USER alpine

RUN set -x && \
    cd /home/alpine && \
    git clone https://github.com/pyenv/pyenv.git /home/alpine/.pyenv && \
    cd /home/alpine/.pyenv && \
    git branch pyenv-1.2.14 v1.2.14 && \
    git checkout pyenv-1.2.14 && \
    cd /home/alpine && \
    git clone https://github.com/pyenv/pyenv-virtualenv.git /home/alpine/.pyenv/plugins/pyenv-virtualenv && \
    cd /home/alpine/.pyenv/plugins/pyenv-virtualenv && \
    git branch virtualenv-1.1.5 v1.1.5 && \
    git checkout virtualenv-1.1.5 && \
    cd /home/alpine && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> /home/alpine/.profile && \
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /home/alpine/.profile && \
    echo 'eval "$(pyenv init -)"' >> /home/alpine/.profile && \
    echo 'eval "$(pyenv virtualenv-init -)"' >> /home/alpine/.profile
