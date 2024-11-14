# Step 1: Build the Maven Project
FROM maven:3.8.6-openjdk-11 as build

# Set the working directory inside the container
WORKDIR /app

# Clone the repository (or copy the contents if the project is on your local machine)
# This assumes that you have the code inside your Docker build context (with `git` installed).
RUN git clone https://github.com/Rachana860/MyMavenApp.git /app

# Build the application using Maven
WORKDIR /app
RUN mvn clean install -DskipTests

# Step 2: Deploy the WAR file to the remote Tomcat
FROM busybox:1.35.0-uclibc

# Install curl to be able to send HTTP requests
RUN apk add --no-cache curl

# Set the working directory
WORKDIR /deploy

# Copy the WAR file from the build stage
COPY --from=build /app/target/MyMavenApp.war /deploy/

# Step 3: Deploy the WAR file to Tomcat via HTTP
# This will use curl to deploy the WAR file to Tomcat's Manager app
CMD curl -u "jenkins:Tomcat@123" -T /deploy/MyMavenApp.war \
    "http://172.16.51.26:8100/manager/text/deploy?path=/MyMavenApp&update=true"
