FROM openjdk:8-jdk-alpine

COPY . /app

RUN /app/gradlew build
EXPOSE 8080

CMD java -jar /app/build/libs/starter-1.0.0-SNAPSHOT-fat.jar
