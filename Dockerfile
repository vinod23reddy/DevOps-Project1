# Stage 1: Build the app using Maven + Java 21
FROM maven:3.9.6-eclipse-temurin-21 AS build

# Set working directory inside container
WORKDIR /app

# Copy pom.xml first (so Maven can download dependencies)
COPY pom.xml .

# Download dependencies (separate layer = faster rebuilds)
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build the JAR (skip tests here, tests run in Jenkins pipeline)
RUN mvn clean package -DskipTests

# ---------------------------------------------------

# Stage 2: Run the app using just Java 21 (smaller image)
FROM eclipse-temurin:21-jre-alpine

# Set working directory
WORKDIR /app

# Copy the JAR from Stage 1
COPY --from=build /app/target/hello-world-1.0-SNAPSHOT.jar app.jar

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
