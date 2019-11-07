#!/bin/sh -l

version=$1

pyenv install ${version}
pyenv virtualenv ${version} python-${version}
pyenv global python-${version}
pip install --upgrade pip
echo "pyenv global python-${version}" >> /home/alpine/.profile
