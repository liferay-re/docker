# Liferay Portal 6.2 RE
#
# VERSION               0.0.1

FROM snasello/docker-debian-java7:7u79


MAINTAINER ipodporin@liferay.ru

# Download Liferay Portal 6.2-ce-ga6  
ADD ./liferay-portal-tomcat-6.2.5.7.zip /
# Unzip the Portal Tomcat Bundle
RUN unzip -qq liferay-portal-tomcat-6.2.5.7.zip

# Default customized portal-ext.properties that will enable the users
# to point the Liferay home to the mount volume
ADD ./portal-ext.properties /liferay-portal-6.2.5.7/tomcat-7.0.62/webapps/ROOT/WEB-INF/classes/portal-ext.properties

# Remove the bundle
RUN rm liferay-portal-tomcat-6.2.5.7.zip

# Setup Mount Volume Directories
RUN mkdir -p /liferay/deploy && mv liferay-portal-6.2.5.7/data /liferay/data

ENV PATH /opt/java/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin


# Liferay Home Dir
VOLUME  /liferay

## Container Start

WORKDIR /liferay-portal-6.2.5.7

# Expose the ports HTTP | OSGi console

EXPOSE 8080 
EXPOSE 8009 

## Add points of extension
ONBUILD ADD ./deploy /liferay/deploy
ONBUILD ADD ./lib    /liferay-portal-tomcat-6.2.5.7/tomcat-7.0.62/lib
ONBUILD COPY ./bin/*.sh /liferay-portal-tomcat-6.2.5.7/tomcat-7.0.62/bin/

# Start Liferay
ENTRYPOINT ["tomcat-7.0.62/bin/catalina.sh"]
CMD ["run"]

