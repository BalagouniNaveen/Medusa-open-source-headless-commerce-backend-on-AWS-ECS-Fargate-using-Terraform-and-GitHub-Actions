// medusa-config.ts                              # Entry point for Medusa backend configuration

import { loadEnv, defineConfig } from "@medusajs/framework/utils"  // Import helpers to load environment variables and define config

loadEnv()                                         // Load environment variables from .env into process.env

export default defineConfig({                    // Export the full Medusa project configuration
  projectConfig: {
    databaseUrl: process.env.DATABASE_URL,       // Set PostgreSQL database URL from env variable
    redisUrl: process.env.REDIS_URL,             // Set Redis connection URL from env variable
    workerMode: process.env.MEDUSA_WORKER_MODE as "shared" | "worker" | "server", // Define worker mode: server, worker, or shared

    http: {
      storeCors: process.env.STORE_CORS,         // Allowed CORS origins for the Storefront API
      adminCors: process.env.ADMIN_CORS,         // Allowed CORS origins for the Admin API
      authCors: process.env.AUTH_CORS,           // Allowed CORS origins for the Auth API
      cookieSecret: process.env.COOKIE_SECRET,   # Secret used to sign cookies
      jwtSecret: process.env.JWT_SECRET,         # Secret used for JWT token generation
    },
  },

  admin: {
    disable: process.env.DISABLE_MEDUSA_ADMIN === "true", // Disable admin panel if true in env
    backendUrl: process.env.MEDUSA_BACKEND_URL,           // Admin backend URL (e.g. http://localhost:9000)
  },

  modules: [                                    // Add production-ready modules to enhance backend
    {
      resolve: "@medusajs/medusa/cache-redis",  // Use Redis as caching backend
      options: {
        redisUrl: process.env.REDIS_URL,        // Redis connection URL for cache
      },
    },
    {
      resolve: "@medusajs/medusa/event-bus-redis", // Use Redis for event bus to handle async events
      options: {
        redisUrl: process.env.REDIS_URL,        // Redis connection URL for event bus
      },
    },
    {
      resolve: "@medusajs/medusa/workflow-engine-redis", // Use Redis for managing distributed workflows
      options: {
        redis: {
          url: process.env.REDIS_URL,           // Redis URL for workflow engine
        },
      },
    },
    // Add other production-ready providers as needed  // Placeholder to add more modules like file storage, email, etc.
  ],
})
