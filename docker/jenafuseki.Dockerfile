FROM eclipse-temurin:21 as jre-build

# Create a custom Java runtime
RUN $JAVA_HOME/bin/jlink \
         --add-modules java.base \
         --strip-debug \
         --no-man-pages \
         --no-header-files \
         --compress \
         --output /javaruntime
RUN cd /opt && wget https://dlcdn.apache.org/jena/binaries/apache-jena-fuseki-5.2.0.tar.gz && tar xvf apache-jena-fuseki-5.2.0.tar.gz && rm apache-jena-fuseki-5.2.0.tar.gz

# Define your base image
FROM debian:buster-slim
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH "${JAVA_HOME}/bin:${PATH}"
COPY --from=jre-build /javaruntime $JAVA_HOME
COPY --from=jre-build /opt/apache-jena-fuseki-5.2.0 /opt
CMD /opt/apache-jena-fuseki-5.2.0/fuseki-server
