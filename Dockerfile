FROM continuumio/miniconda3
MAINTAINER Fedor Baart <fedor.baart@deltares.nl>
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
# update system and install wget
RUN \
    apt-get install -y apt-utils && \
    echo "deb http://httpredir.debian.org/debian jessie-backports main non-free" >> /etc/apt/sources.list && \
    echo "deb-src http://httpredir.debian.org/debian jessie-backports main non-free" >> /etc/apt/sources.list && \
    apt-get update --fix-missing && \
    apt-get install -y build-essential
# switch to python 3.5 (no gdal in 3.6)
RUN conda create -y -n py36 python=3.6 pyramid cookiecutter
# add the virtualenv
ENV PATH /opt/conda/envs/py36/bin:$PATH

RUN cookiecutter gh:Pylons/pyramid-cookiecutter-alchemy --checkout master --no-input
# create the demo
RUN cd pyramid_scaffold && pip install -e .
# not sure what this is
WORKDIR pyramid_scaffold
EXPOSE 6543
ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "pserve production.ini" ]
