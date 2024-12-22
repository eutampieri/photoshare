FROM eclipse-temurin:21 as jre-build

# Create a custom Java runtime
RUN $JAVA_HOME/bin/jlink \
         --add-modules java.base,java.xml,java.desktop,java.management,java.instrument,jdk.zipfs,java.logging,java.naming,java.sql,jdk.unsupported,java.net.http,java.scripting,java.compiler,java.rmi,jdk.incubator.vector \
         --strip-debug \
         --no-man-pages \
         --no-header-files \
         --compress=2 \
         --output /javaruntime
RUN cd /opt && wget https://dlcdn.apache.org/jena/binaries/apache-jena-fuseki-5.2.0.tar.gz && tar xvf apache-jena-fuseki-5.2.0.tar.gz && rm apache-jena-fuseki-5.2.0.tar.gz

# Define your base image
FROM debian:buster-slim
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH "${JAVA_HOME}/bin:${PATH}"
COPY --from=jre-build /javaruntime $JAVA_HOME
COPY --from=jre-build /opt/apache-jena-fuseki-5.2.0 /opt/
COPY shiro.ini /run/shiro.ini
COPY jenafuseki.sh /opt/jenafuseki.sh
ENV ADMIN_PASSWORD=pw
CMD /opt/jenafuseki.sh
EXPOSE 3030
