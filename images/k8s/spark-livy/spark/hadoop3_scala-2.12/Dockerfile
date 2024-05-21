FROM spark-livy/builder:latest as spark_dist

RUN cd / && \
    git clone https://github.com/apache/spark.git --branch v3.5.1 --single-branch && \
    cd /spark && \
    dev/make-distribution.sh \
        --name hadoop3.3.6 --pip --tgz -DskipTests \
        -Phadoop-3.3 \
        -Dhadoop.version=3.3.6 \
        -Pkubernetes \
        -Phive \
        -Phive-thriftserver \
        -DskipTests
RUN ls /spark && \
    cp /spark/spark-3.5.1-bin-hadoop3.3.6.tgz /

FROM openjdk:8-jre-slim

ARG SPARK_VERSION=3.5.1
ARG HADOOP_VERSION=3.3.6
ARG SCALA_VERSION=2.12
ARG SCALA_FULL_VERSION=2.12.17

ARG UPSTREAM_FILE_NAME=spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
ARG SPARK_FULL_NAME=spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}

ENV SPARK_HOME		/opt/spark
ENV SPARK_CONF_DIR	${SPARK_HOME}/conf

ENV PYTHONHASHSEED	0
ENV CONDA_DIR		/opt/conda
ENV SHELL		/bin/bash

ARG MINICONDA_VERSION=4.11.0
ARG MINICONDA_SHA256=4ee9c3aa53329cd7a63b49877c0babb49b19b7e5af29807b793a76bdb1d362b4
ARG CONDA_VERSION=4.11.0
ARG PYTHON_VERSION=3.9.5

ENV SCALA_HOME=/opt/scala-${SCALA_VERSION}
ENV PATH=$PATH:$SCALA_HOME/bin

ENV PATH		$PATH:$SPARK_HOME/bin:$CONDA_DIR/bin

# install Conda (https://github.com/jupyter/docker-stacks/blob/6d42503c684f3de9b17ce92a6b0c952ef2d1ecd8/base-notebook/Dockerfile#L78-L101)
RUN apt-get update && \
    apt-get install wget -y && \
    mkdir -p $CONDA_DIR && \
    cd /tmp && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-py39_${MINICONDA_VERSION}-Linux-x86_64.sh -O miniconda.sh && \
    echo "${MINICONDA_SHA256} miniconda.sh" | sha256sum -c - && \
    /bin/bash miniconda.sh -f -b -p $CONDA_DIR && \
    rm miniconda.sh && \
    echo "conda ${CONDA_VERSION}" >> $CONDA_DIR/conda-meta/pinned && \
    conda config --system --prepend channels conda-forge && \
    conda config --system --set auto_update_conda false && \
    conda config --system --set show_channel_urls true && \
    conda config --system --set channel_priority strict && \
    if [ ! $PYTHON_VERSION = 'default' ]; then conda install --yes python=$PYTHON_VERSION; fi && \
    conda list python | grep '^python ' | tr -s ' ' | cut -d '.' -f 1,2 | sed 's/$/.*/' >> $CONDA_DIR/conda-meta/pinned && \
    conda install --quiet --yes conda && \
    conda install --quiet --yes pip && \
    conda install --quiet --yes numpy scipy pandas scikit-learn && \
    conda install --quiet --yes -c conda-forge pyarrow && \
    conda update --all --quiet --yes && \
    conda clean --all -f -y
    
# install Scala
RUN \
    wget https://downloads.lightbend.com/scala/${SCALA_FULL_VERSION}/scala-${SCALA_FULL_VERSION}.tgz && \
    tar -xvf scala-${SCALA_FULL_VERSION}.tgz && \
    mv scala-${SCALA_FULL_VERSION} ${SCALA_HOME}
    
### install Spark
COPY --from=spark_dist /${UPSTREAM_FILE_NAME} /opt

RUN cd /opt && \
    tar -xvf ${UPSTREAM_FILE_NAME} && \
    ln -s /opt/${SPARK_FULL_NAME} ${SPARK_HOME}

ENV HADOOP_CONF_DIR=$SPARK_HOME/conf

COPY conf/* $SPARK_HOME/conf
COPY jars/* $SPARK_HOME/jars
