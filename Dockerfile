# Use OpenJDK 17 slim version
FROM openjdk:17-jdk-slim

# Set a non-root user for OpenShift compatibility
RUN useradd -m appuser
USER appuser

# Set the working directory
WORKDIR /app

# Copy the JAR file from the target directory
COPY target/banking-portal-api-0.0.1-SNAPSHOT.jar app.jar

# Expose the application port
EXPOSE 8081

# Set the entrypoint to run the Java application
CMD ["java", "-jar", "app.jar"]
