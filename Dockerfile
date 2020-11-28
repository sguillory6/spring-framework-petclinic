FROM maven:3.5.2-jdk-8-alpine AS MAVEN_TOOL_CHAIN
ENV spring.profiles.active hsqldb
COPY pom.xml /tmp/
COPY src /tmp/src/
WORKDIR /tmp/
RUN mvn -D{$spring.profiles.active} package

FROM tomcat:9.0-jre8-alpine
ENV spring_profiles_active hsqldb
COPY --from=MAVEN_TOOL_CHAIN /tmp/target/petclinic*.war $CATALINA_HOME/webapps/petclinic.war
COPY ./setenv.sh $CATALINA_HOME/bin
COPY ./wait-for-it.sh $CATALINA_HOME/bin

HEALTHCHECK --interval=1m --timeout=3s CMD wget --quiet --tries=1 --spider http://localhost:8080/petclinic/ || exit 1
