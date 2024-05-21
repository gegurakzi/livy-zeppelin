ARG SPARK_BASE="spark-livy/spark:hadoop3"
ARG LIVY_BUILDER="spark-livy/builder:latest"

### Livy Builder Container
FROM $LIVY_BUILDER as build

ARG LIVY_GITHUB_REPO=apache/incubator-livy
ARG LIVY_GITHUB_BRANCH=v0.8.0-incubating

RUN cd /opt && \
    git clone https://github.com/${LIVY_GITHUB_REPO}.git --branch ${LIVY_GITHUB_BRANCH} --single-branch --depth=50 && \
    cd incubator-livy && \
    mvn clean package -B -V -e \
        -Pspark3 \
        -Pscala-2.12 \
        -Pthriftserver \
        -DskipTests \
        -DskipITs \
        -Dmaven.javadoc.skip=true && \
    ls assembly/target
RUN cp /opt/incubator-livy/assembly/target/apache-livy-0.8.0-incubating_2.12-bin.zip /

### Final Container
FROM $SPARK_BASE

ARG LIVY_VERSION_ARG=0.8.0-incubating_2.12

ENV LIVY_VERSION            $LIVY_VERSION_ARG
ENV LIVY_HOME               /opt/livy

# install livy
COPY --from=build /apache-livy-${LIVY_VERSION}-bin.zip /

RUN apt-get install -y unzip && \
    unzip /apache-livy-${LIVY_VERSION}-bin.zip -d / && \
    mv /apache-livy-${LIVY_VERSION}-bin /opt/ && \
    rm -rf $LIVY_HOME && \
    ln -s /opt/apache-livy-${LIVY_VERSION}-bin $LIVY_HOME && \
    rm -f /apache-livy-${LIVY_VERSION}-bin.zip
