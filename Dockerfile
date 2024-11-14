# Stage 1: Build the application using Maven
FROM maven:3.8.6-openjdk-11 AS build

# Set the working directory for the build process
WORKDIR /app

# Copy the pom.xml and source code into the container
COPY pom.xml .
COPY src ./src

# Run Maven to build the WAR file
RUN mvn clean package -DskipTests

# Stage 2: Setup Tomcat and deploy the WAR file
FROM tomcat:9.0.73-jdk17

# Expose port 8100
EXPOSE 8100

# Copy the WAR file from the build stage
COPY --from=build /app/target/MyMavenApp.war /usr/local/tomcat/webapps/MyMavenApp.war

# Optional: You can set the entrypoint to run Tomcat if necessary
# CMD ["catalina.sh", "run"]
