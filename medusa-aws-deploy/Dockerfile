FROM node:18-alpine                                      # Use the Alpine-based Node 18 image for a lightweight base :contentReference[oaicite:1]{index=1}
WORKDIR /app                                              # Set the working directory inside the container to /app
COPY . .                                                  # Copy all local files into the container’s /app directory
RUN npm install && npm run build                         # Install dependencies and build the application
CMD ["sh", "-c", "cd .medusa/server && npm install && npm run predeploy && npm run start"]  # Navigate into Medusa server, install server-specific dependencies, run any pre-deploy script, then start the server
