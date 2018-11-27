FROM gradle:jdk8-alpine as compiler

COPY . /app

WORKDIR /app
USER root
RUN ./gradlew build

FROM java:openjdk-8-jre-alpine
COPY --from=compiler /app/build/libs/starter-1.0.0-SNAPSHOT-fat.jar .

EXPOSE 8080
CMD java -jar /starter-1.0.0-SNAPSHOT-fat.jar
