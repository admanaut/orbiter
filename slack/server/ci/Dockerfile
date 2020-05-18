FROM java:8-jdk-alpine
COPY orbiter-slack-server.jar /usr/app/
WORKDIR /usr/app
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "orbiter-slack-server.jar"]
