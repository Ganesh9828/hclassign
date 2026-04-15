# Render Deployment Guide

This guide walks you through deploying the Taskmgr application to Render.

## Prerequisites

- A [Render](https://render.com) account
- GitHub repository with this code pushed
- Basic understanding of environment variables

## Deployment Options

### Option 1: Infrastructure as Code (Recommended)

Using `render.yaml` for automated deployment:

1. **Push code to GitHub**
   ```bash
   git push origin main
   ```

2. **Connect GitHub to Render**
   - Go to [Render Dashboard](https://dashboard.render.com)
   - Click "New +" → "Blueprint"
   - Select your GitHub repository
   - Choose the branch (usually `main`)
   - Click "Create Blueprint"

3. **Monitor Deployment**
   - Render will automatically:
     - Create MySQL database (taskmgr-db)
     - Build and deploy backend (taskmgr-api)
     - Build and deploy frontend (taskmgr-frontend)
   - Watch the deployment progress in the dashboard

---

### Option 2: Manual Deployment (Step-by-step)

#### Step 1: Create MySQL Database

1. Go to Render Dashboard
2. Click "New +" → "MySQL"
3. Configure:
   - **Name**: taskmgr-db
   - **Database Name**: task_db
   - **Region**: Oregon (or your preference)
   - **Plan**: Starter (free tier available)
4. Create and note the connection details

#### Step 2: Deploy Backend

1. Click "New +" → "Web Service"
2. Connect your GitHub repository
3. Configure:
   - **Name**: taskmgr-api
   - **Environment**: Docker (or JVM)
   - **Build Command**: `cd backend && mvn clean package -DskipTests`
   - **Start Command**: `cd backend && java -jar target/taskmgr-0.0.1-SNAPSHOT.jar`
   - **Plan**: Standard

4. Add Environment Variables:
   ```
   PORT=8080
   SPRING_DATASOURCE_URL=jdbc:mysql://your_db_host:3306/task_db?createDatabaseIfNotExist=true&serverTimezone=UTC
   SPRING_DATASOURCE_USERNAME=your_db_user
   SPRING_DATASOURCE_PASSWORD=your_db_password
   JWT_SECRET=9a4f2c8d3b7a1e6f45c8a0b3f267d8b1d4e6f3c8a9d2b5f8e3a9c8b5f6v8a3d9
   JWT_EXPIRATION=86400000
   CORS_ALLOWED_ORIGINS=https://your-frontend-url.onrender.com
   ```

5. Create the service

#### Step 3: Deploy Frontend

1. Click "New +" → "Static Site"
2. Connect your GitHub repository
3. Configure:
   - **Name**: taskmgr-frontend
   - **Build Command**: `cd frontend && npm install && npm run build`
   - **Publish Directory**: `frontend/dist`

4. Add Environment Variable:
   ```
   VITE_API_BASE_URL=https://taskmgr-api.onrender.com/api
   ```

5. Deploy

---

## Environment Variables Reference

### Backend Variables

| Variable | Purpose | Example |
|----------|---------|---------|
| `SPRING_DATASOURCE_URL` | Database connection | `jdbc:mysql://host:3306/task_db?createDatabaseIfNotExist=true&serverTimezone=UTC` |
| `SPRING_DATASOURCE_USERNAME` | DB username | From Render MySQL service |
| `SPRING_DATASOURCE_PASSWORD` | DB password | From Render MySQL service |
| `JWT_SECRET` | JWT signing key | Current: `9a4f2c8d3b7a1e6f45c8a0b3f267d8b1d4e6f3c8a9d2b5f8e3a9c8b5f6v8a3d9` |
| `JWT_EXPIRATION` | Token expiration (ms) | `86400000` (24 hours) |
| `CORS_ALLOWED_ORIGINS` | Frontend origin | `https://taskmgr-frontend.onrender.com` |
| `PORT` | Server port | `8080` |

### Frontend Variables

| Variable | Purpose | Example |
|----------|---------|---------|
| `VITE_API_BASE_URL` | Backend API endpoint | `https://taskmgr-api.onrender.com/api` |

---

## Update application.properties for Render

The backend should use environment variables instead of hardcoded values. Add this to `backend/src/main/resources/application.properties`:

```properties
spring.application.name=taskmgr

# Database Configuration (uses env vars)
spring.datasource.url=${SPRING_DATASOURCE_URL:jdbc:mysql://localhost:3306/task_db?createDatabaseIfNotExist=true&serverTimezone=UTC}
spring.datasource.username=${SPRING_DATASOURCE_USERNAME:root}
spring.datasource.password=${SPRING_DATASOURCE_PASSWORD:1234}
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=false
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect

jwt.secret=${JWT_SECRET:9a4f2c8d3b7a1e6f45c8a0b3f267d8b1d4e6f3c8a9d2b5f8e3a9c8b5f6v8a3d9}
jwt.expiration=${JWT_EXPIRATION:86400000}

server.port=${PORT:8080}
server.servlet.context-path=/
management.endpoints.web.exposure.include=health,info
```

---

## Frontend Configuration with Vite

Create `.env.production` in the frontend directory:

```env
VITE_API_BASE_URL=https://taskmgr-api.onrender.com/api
```

Update the API client in `frontend/src/services/api.js` to use the environment variable:

```javascript
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080/api';

export const apiClient = axios.create({
  baseURL: API_BASE_URL,
});
```

---

## Troubleshooting

### Backend Deployment Issues

1. **Build fails**: Check Maven dependencies
   ```bash
   cd backend && mvn clean install
   ```

2. **Database connection fails**: Verify connection string and credentials in Render dashboard

3. **Port conflicts**: Ensure PORT environment variable is set

### Frontend Deployment Issues

1. **API calls fail**: Check `VITE_API_BASE_URL` environment variable
2. **Build fails**: Clear node_modules
   ```bash
   cd frontend && rm -rf node_modules && npm install
   ```

### Database Connection

Get connection details from Render MySQL dashboard:
- Internal URL (use for services in same region)
- External URL (use for external connections)

---

## Deployment URLs

After successful deployment, your application will be available at:

- **API**: `https://taskmgr-api.onrender.com`
- **Frontend**: `https://taskmgr-frontend.onrender.com`
- **API Docs**: `https://taskmgr-api.onrender.com/swagger-ui.html` (if available)

---

## Important Notes

⚠️ **Security**:
- Change the `JWT_SECRET` environment variable to a strong, random value
- Never commit sensitive data to the repository
- Use Render's secret management for sensitive values

⚠️ **Costs**:
- Free tier services have limitations (sleep after inactivity)
- Starter databases may be limited in resources
- Consider upgrading for production use

⚠️ **Cold Starts**:
- Free-tier services may experience delay on first request after sleep
- Use Paid tier for consistent performance

---

## Next Steps

1. Update `CORS_ALLOWED_ORIGINS` once frontend is deployed
2. Test API endpoints from deployed frontend
3. Monitor service health in Render dashboard
4. Set up custom domain (optional)

For more help, visit [Render Documentation](https://render.com/docs)
