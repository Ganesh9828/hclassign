# 🚀 Render Deployment Checklist

## Pre-Deployment Steps

- [ ] Commit all changes to Git
  ```bash
  git add .
  git commit -m "Prepare for Render deployment"
  git push origin main
  ```

- [ ] Ensure GitHub repository is public or connected to Render

## Deployment Steps

### 1️⃣ Deploy with Infrastructure as Code (Quickest)

1. Go to [Render Dashboard](https://dashboard.render.com)
2. Click **"New +"** → **"Blueprint"**
3. Select your GitHub repository `hclkackpre`
4. Select branch: **`main`** (or your branch)
5. Click **"Create Blueprint"**
6. Wait for services to deploy (5-10 minutes)

**What gets created:**
- ✅ MySQL Database (`taskmgr-db`)
- ✅ Backend API (`taskmgr-api`) on Java/Spring Boot
- ✅ Frontend (`taskmgr-frontend`) on Static hosting

---

### 2️⃣ Manual Deployment (If Blueprint Fails)

#### A. Create MySQL Database
1. Dashboard → "New +" → "MySQL"
2. Name: `taskmgr-db`
3. Database: `task_db`
4. Copy connection details (Internal URL)

#### B. Deploy Backend
1. Dashboard → "New +" → "Web Service"
2. Connect your GitHub repo
3. Build Command: `cd backend && mvn clean package -DskipTests`
4. Start Command: `cd backend && java -jar target/taskmgr-0.0.1-SNAPSHOT.jar`
5. Add Environment Variables:
```
SPRING_DATASOURCE_URL=jdbc:mysql://[RENDER_DB_HOST]:3306/task_db?createDatabaseIfNotExist=true&serverTimezone=UTC
SPRING_DATASOURCE_USERNAME=[RENDER_DB_USER]
SPRING_DATASOURCE_PASSWORD=[RENDER_DB_PASS]
JWT_SECRET=9a4f2c8d3b7a1e6f45c8a0b3f267d8b1d4e6f3c8a9d2b5f8e3a9c8b5f6v8a3d9
JWT_EXPIRATION=86400000
CORS_ALLOWED_ORIGINS=https://taskmgr-frontend.onrender.com
```
6. Deploy

#### C. Deploy Frontend
1. Dashboard → "New +" → "Static Site"
2. GitHub: `hclkackpre`
3. Build Command: `cd frontend && npm install && npm run build`
4. Publish Dir: `frontend/dist`
5. Environment: `VITE_API_BASE_URL=https://taskmgr-api.onrender.com/api`
6. Deploy

---

## ✅ Files Configured

| File | Purpose |
|------|---------|
| `render.yaml` | Infrastructure as Code for all services |
| `.renderignore` | Files to skip during deployment |
| `RENDER_DEPLOYMENT_GUIDE.md` | Detailed deployment instructions |
| `backend/src/main/resources/application.properties` | Updated to use env vars |
| `frontend/.env.production` | API endpoint for production |
| `frontend/.env.development` | API endpoint for local development |
| `frontend/src/services/api.js` | Updated to use environment variables |

---

## 🔒 Security Reminders

⚠️ **IMPORTANT**: Generate secure values for production:

```bash
# Generate a strong JWT secret (run in terminal)
openssl rand -base64 32
```

Replace `JWT_SECRET` environment variable with a unique value!

---

## 📊 Expected Deployment Time

- **Blueprint Deployment**: 5-10 minutes
- **Manual Deployment**: 15-20 minutes per service

---

## 🔗 After Deployment

Your app will be live at:
- **Frontend**: `https://taskmgr-frontend.onrender.com`
- **API**: `https://taskmgr-api.onrender.com/api`

Test by:
1. Opening frontend URL
2. Register a new account
3. Create a task
4. Check if changes persist

---

## ❌ Common Issues

| Issue | Solution |
|-------|----------|
| Build fails | Check Maven/Node versions in build logs |
| API calls fail | Verify `VITE_API_BASE_URL` and CORS settings |
| Database connection fails | Check connection string and credentials |
| Services not communicating | Ensure `depends_on` is set in render.yaml |

---

See `RENDER_DEPLOYMENT_GUIDE.md` for more detailed information.
