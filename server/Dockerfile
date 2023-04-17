FROM node:16.14.0

# Create the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json files to the working directory
COPY package*.json ./

# Install the dependencies
RUN npm install

# Copy the source code to the working directory
COPY . .

# Expose the port that the app will run on
EXPOSE 3100

# Start the application
CMD ["npm", "start"]