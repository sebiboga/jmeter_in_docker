# Use Amazon Corretto latest as the base image
FROM amazoncorretto:latest

# Set environment variables
ENV JMETER_VERSION=5.6.3
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV PATH $JMETER_HOME/bin:$PATH

# Update package lists and install necessary tools
RUN yum install -y wget unzip tar gzip xauth xorg && \
    yum clean all

# Download and install JMeter
RUN mkdir -p /tmp/dependencies && \
    wget -qO /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz https://downloads.apache.org/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz && \
    tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt && \
    rm -rf /tmp/dependencies

# Install JMeter Plugins Manager
RUN wget -O ${JMETER_HOME}/lib/ext/jmeter-plugins-manager-1.10.jar https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-manager/1.10/jmeter-plugins-manager-1.10.jar

# Install Dummy Sampler plugin
RUN wget -O ${JMETER_HOME}/lib/ext/jmeter-plugins-dummy-0.4.jar https://repo1.maven.org/maven2/kg/apc/jmeter-plugins-dummy/0.4/jmeter-plugins-dummy-0.4.jar

# Download CMDRunner
RUN wget -O ${JMETER_HOME}/lib/cmdrunner-2.2.jar https://repo1.maven.org/maven2/kg/apc/cmdrunner/2.2/cmdrunner-2.2.jar

# Add custom jmeter.properties file with CookieManager.save.cookies=true
RUN echo "CookieManager.save.cookies=true" >> ${JMETER_HOME}/bin/jmeter.properties

# Expose JMeter default port
EXPOSE 1099 50000

# Define working directory
WORKDIR $JMETER_HOME

# Run JMeter when the container starts
ENTRYPOINT ["jmeter"]
