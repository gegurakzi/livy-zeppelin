ARG SPARK_DIST_IMAGE="gegurakzi/spark:hadoop3"
ARG SCALA_DIST_IMAGE="gegurakzi/spark:hadoop3"
ARG LIVY_DIST_IMAGE="gegurakzi/livy:latest"

FROM $SPARK_DIST_IMAGE as spark_dist
FROM $SCALA_DIST_IMAGE as scala_dist
FROM $LIVY_DIST_IMAGE as livy_dist

### Final container
FROM apache/zeppelin:0.10.1
MAINTAINER Apache Software Foundation <dev@zeppelin.apache.org>

ENV SPARK_HOME		/opt/spark
ENV SCALA_HOME		/opt/scala-2.12
ENV LIVY_HOME		/opt/livy

COPY --from=spark_dist $SPARK_HOME $SPARK_HOME
COPY --from=scala_dist $SCALA_HOME $SCALA_HOME
COPY --from=livy_dist $LIVY_HOME $LIVY_HOME

ARG PYTHON_VERSION=3.9.5
ARG conda_dir=/opt/conda
ARG zeppelin_uid=1000

ARG WORK_DIR=/opt/zeppelin
### copy distributions
WORKDIR ${WORK_DIR}

### install Zepplin's conda env
USER root
COPY env_python_3_with_R.yml /env_python_3_with_R.yml
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install libarchive13 -y && \
    conda update --all && \
    conda install mamba -c conda-forge && \
    mamba env update -f /env_python_3_with_R.yml --prune && \
    # Cleanup based on https://github.com/ContinuumIO/docker-images/commit/cac3352bf21a26fa0b97925b578fb24a0fe8c383
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    mamba clean -ay
    # Allow to modify conda packages. This allows malicious code to be injected into other interpreter sessions, therefore it is disabled by default
    # chmod -R ug+rwX /opt/conda
ENV PATH=/opt/conda/envs/python_3_with_R/bin:$PATH

RUN chown -R ${zeppelin_uid} $SPARK_HOME && \
    chown -R ${zeppelin_uid} $SCALA_HOME && \
    chown -R ${zeppelin_uid} $LIVY_HOME

### default zeppelin user
USER ${zeppelin_uid}

