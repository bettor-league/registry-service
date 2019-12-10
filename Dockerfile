FROM maven:3.6.1-jdk-11-slim AS java-builder

WORKDIR /usr/src/app

COPY ./pom.xml .

RUN mvn dependency:go-offline

COPY . .

RUN mvn clean install

FROM openjdk:11.0-jre as java-runtime

COPY --from=java-builder /usr/src/app/target/*.jar /app.jar

CMD ["java", "-Xmx50m", "-jar", "/app.jar", "--spring.profiles.active=docker"]

HEALTHCHECK --interval=30s --timeout=30s CMD curl -f http://localhost:2000/actuator/health || exit 1

EXPOSE 2000