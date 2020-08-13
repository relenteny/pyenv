# pyenv

The pyenv image is an Alpine Linux image configured with the basic requirements for, and an installation of pyenv (<https://github.com/pyenv/pyenv).>

Although the image can be used directly, it is intended to be used as a base image for creating subsequent Docker images with specific versions of Python installed.

## Capabilities

As stated, the image is built with the expectation that it will be the basis for specific Python installations. Also, there are additional capabilities that assist in creating final application images. Each of these capabilities is driven with a script.

### `install-python.sh`

`install-python.sh` is used to configure a specific version of Python. The intent is that a new image would be created from the resulting execution of this script. For example, the Dockerfile example below will build an image with Python 3.8.5 installed and the default Python installation set for the built-in user `alpine`.

```Dockerfile
FROM relenteny/pyenv:1.2.14

RUN /home/alpine/bin/install-python.sh 3.8.5
```

Typically, although not required, the resultant image would be stored in the registry as a generic Python runtime image. Using the example above, an example image name and tagged could be `myregistry/python:3.8.5`.

### `install-requirements.sh`

`install-requirements.sh` is a convenience script that will install additional Python modules as specified through a requirements file, by convention, named `requirements.txt`. This script can only be executed once a version of Python has been installed. When invoked, the path to the text file containing the modules to be installed must be provided as an argument as follows:

```bash
/home/alpine/bin/install-requirements.sh /home/alpine/requirements.txt
```

Here `requirements.txt` is specified as being in the home directory of the built in user, `alpine`. This, of course, is dependent on how the actual Dockerfile is written. An example of its usage is below.

```Dockerfile
FROM myregistry/python:3.8.5
.
.
.
# Execute various Dockerfile commands to copy requirements text file and application code
.
.
.
RUN /home/alpine/bin/install-requirements.sh /home/alpine/requirements.txt

WORKDIR /home/alpine/app
ENTRYPOINT ["python my-application.py"]
```
