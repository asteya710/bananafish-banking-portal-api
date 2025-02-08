FROM maven:3.8-openjdk-11 as build
WORKDIR /app
COPY . .
RUN mvn install

# Use OpenJDK 17 slim version
#FROM openjdk:17-jdk-slim
FROM openjdk:8-jre-alpine
# Set a non-root user for OpenShift compatibility
RUN useradd -m appuser
USER appuser
# Set the working directory
WORKDIR /app
# Copy the JAR file from the target directory
#COPY target/banking-portal-api-0.0.1-SNAPSHOT.jar app.jar
COPY --from=build /app/target/banking-portal-api-*.jar /app/app.jar
# Expose the application port
EXPOSE 8081
ENTRYPOINT ["sh", "-c"]
# Set the entrypoint to run the Java application
CMD ["java", "-jar", "app.jar"]
