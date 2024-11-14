# Step 1: Build the WAR file using Maven
FROM maven:3.8.6-openjdk-17 AS build


# Set the working directory for the Maven build
WORKDIR /app

# Copy the pom.xml and source code
COPY pom.xml /app/
COPY src /app/src/

# Build the project (this should generate the WAR file)
RUN mvn clean package -DskipTests

# Step 2: Create the Tomcat image and copy the WAR file
FROM tomcat:9.0.73-jdk17

# Expose the Tomcat port
EXPOSE 8100

# Copy the WAR file from the build stage to the Tomcat webapps directory
COPY --from=build /app/target/java-tomcat-maven-example.war /usr/local/tomcat/webapps/java-tomcat-maven-example.war

# Start Tomcat (this is already the default entrypoint for the Tomcat image)
