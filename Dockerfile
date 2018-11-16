FROM openjdk:8-jdk-alpine

COPY . /app

RUN /app/gradlew build

FROM java:openjdk-8-jre-alpine
COPY --from=0 /app/build/libs/starter-1.0.0-SNAPSHOT-fat.jar .
EXPOSE 8080
CMD java -jar ./starter-1.0.0-SNAPSHOT-fat.jar
