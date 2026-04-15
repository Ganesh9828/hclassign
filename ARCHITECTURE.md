# System Architecture & Design Diagrams

## 1. Overall System Architecture

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃                         CLIENT LAYER                           ┃
┃  ┌──────────────────────────────────────────────────────────┐ ┃
┃  │  React SPA (Vite)                                        │ ┃
┃  │  Port: 5173 (Dev), 443 (Prod)                           │ ┃
┃  │                                                          │ ┃
┃  │  ├─ Pages: Login, Register, Dashboard                   │ ┃
┃  │  ├─ Services: Auth, Task, API                           │ ┃
┃  │  ├─ Context: Authentication State                       │ ┃
┃  │  └─ UI: Task management interface                       │ ┃
┃  └──────────────────────────────────────────────────────────┘ ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
                    HTTPS/TLS
                       ↕
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃                      API LAYER                                 ┃
┃  ┌──────────────────────────────────────────────────────────┐ ┃
┃  │  Spring Boot REST API                                    │ ┃
┃  │  Port: 8080                                              │ ┃
┃  │                                                          │ ┃
┃  │  ├─ Controllers                                          │ ┃
┃  │  │  ├─ AuthController (/auth/register, /auth/login)    │ ┃
┃  │  │  └─ TaskController (/tasks/*, authenticated)        │ ┃
┃  │  │                                                      │ ┃
┃  │  ├─ Services                                            │ ┃
┃  │  │  ├─ AuthService (registration, authentication)      │ ┃
┃  │  │  └─ TaskService (CRUD operations)                   │ ┃
┃  │  │                                                      │ ┃
┃  │  ├─ Security                                            │ ┃
┃  │  │  ├─ SecurityConfig (Spring Security setup)          │ ┃
┃  │  │  ├─ JwtTokenProvider (token generation/validation)  │ ┃
┃  │  │  ├─ JwtAuthenticationFilter (request filtering)     │ ┃
┃  │  │  └─ CustomUserDetailsService (user details)         │ ┃
┃  │  │                                                      │ ┃
┃  │  ├─ Exception Handling                                  │ ┃
┃  │  │  ├─ GlobalExceptionHandler                          │ ┃
┃  │  │  ├─ ErrorDetails (error response format)            │ ┃
┃  │  │  └─ ResourceNotFoundException                       │ ┃
┃  │  │                                                      │ ┃
┃  │  ├─ Configuration                                       │ ┃
┃  │  │  └─ CorsConfig (CORS setup)                        │ ┃
┃  │  │                                                      │ ┃
┃  │  └─ DTOs                                                │ ┃
┃  │     ├─ LoginDto, RegisterDto                           │ ┃
┃  │     ├─ JwtAuthResponse                                 │ ┃
┃  │     └─ TaskDto                                         │ ┃
┃  └──────────────────────────────────────────────────────────┘ ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
                    JDBC/MySQL Protocol
                       ↕
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃                   DATA ACCESS LAYER                            ┃
┃  ┌──────────────────────────────────────────────────────────┐ ┃
┃  │  Spring Data JPA                                         │ ┃
┃  │                                                          │ ┃
┃  │  ├─ UserRepository                                      │ ┃
┃  │  │  ├─ findByUsername(String)                          │ ┃
┃  │  │  ├─ findByEmail(String)                             │ ┃
┃  │  │  └─ save(User)                                      │ ┃
┃  │  │                                                      │ ┃
┃  │  └─ TaskRepository                                      │ ┃
┃  │     ├─ findByUserId(Long)                              │ ┃
┃  │     ├─ findById(Long)                                  │ ┃
┃  │     ├─ save(Task)                                      │ ┃
┃  │     └─ deleteById(Long)                                │ ┃
┃  └──────────────────────────────────────────────────────────┘ ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
                    Database Connection Pool
                       ↕
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃                   DATABASE LAYER                               ┃
┃  ┌──────────────────────────────────────────────────────────┐ ┃
┃  │  MySQL 8.0+                                             │ ┃
┃  │  Database: task_db                                      │ ┃
┃  │  Port: 3306                                             │ ┃
┃  │                                                          │ ┃
┃  │  Tables:                                                │ ┃
┃  │  ├─ users (id, username, email, password, roles)       │ ┃
┃  │  ├─ user_roles (user_id, role)                         │ ┃
┃  │  └─ tasks (id, title, description, completed, user_id) │ ┃
┃  │                                                          │ ┃
┃  │  Indexes:                                               │ ┃
┃  │  ├─ users.username (UNIQUE)                            │ ┃
┃  │  ├─ users.email (UNIQUE)                               │ ┃
┃  │  └─ tasks.user_id (foreign key)                        │ ┃
┃  └──────────────────────────────────────────────────────────┘ ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

---

## 2. Authentication Flow Sequence Diagram

```
User          Browser          Frontend         Backend API      Database
 │                │                │                │               │
 │─ Enter Creds →│                │                │               │
 │                │─ POST /auth/login (username, password) →│       │
 │                │                │                │               │
 │                │                │        Check user exists       │
 │                │                │                │─ Query user →│
 │                │                │                │← User object ←│
 │                │                │                │               │
 │                │                │   Verify password (BCrypt)     │
 │                │                │                │               │
 │                │                │   Generate JWT token           │
 │                │                │ (HS256, 24hr expiration)       │
 │                │                │                │               │
 │                │← Response (token) ←│                │               │
 │                │                │                │               │
 │                │ Store token in localStorage     │               │
 │                │                │                │               │
 │─ Click Create Task                                               │
 │                │─ POST /tasks (title, Authorization: Bearer token)─→│
 │                │                │                │               │
 │                │                │ JwtAuthenticationFilter         │
 │                │                │ Extract & validate token        │
 │                │                │                │               │
 │                │                │        Token valid?             │
 │                │                │ Create SecurityContext          │
 │                │                │                │               │
 │                │                │ TaskController.createTask()    │
 │                │                │                │               │
 │                │                │ TaskService.createTask()       │
 │                │                │                │               │
 │                │                │    Filter by user ID           │
 │                │                │                │               │
 │                │                │  Save task to database         │
 │                │                │                │← Save task ←  │
 │                │                │                │               │
 │                │← Task object ←│                │               │
 │                │                │                │               │
 │ Display task                     │                │               │
 │                │                │                │               │
```

---

## 3. Request Handling Pipeline

```
Incoming HTTP Request (JWT Token in Authorization Header)
       │
       ↓
   ┌─────────────────────────────────────────┐
   │ Spring Security Filter Chain            │
   ├─────────────────────────────────────────┤
   │ 1. CORS Filter                          │
   │    - Validate origin                    │
   │    - Add CORS headers                   │
   └─────────────────────────────────────────┘
       │
       ↓
   ┌─────────────────────────────────────────┐
   │ JwtAuthenticationFilter                 │
   ├─────────────────────────────────────────┤
   │ 1. Extract token from header            │
   │ 2. Validate token signature              │
   │ 3. Check expiration                      │
   │ 4. Load user details                     │
   │ 5. Create SecurityContext                │
   │ 6. Add authentication to context         │
   └─────────────────────────────────────────┘
       │
       ↓
   ┌─────────────────────────────────────────┐
   │ DispatcherServlet                       │
   ├─────────────────────────────────────────┤
   │ 1. Map request to controller            │
   │ 2. Resolve method parameters            │
   └─────────────────────────────────────────┘
       │
       ↓
   ┌─────────────────────────────────────────┐
   │ Controller Method                       │
   ├─────────────────────────────────────────┤
   │ Execute business logic                  │
   │ Call service layer                      │
   └─────────────────────────────────────────┘
       │
       ↓
   ┌─────────────────────────────────────────┐
   │ Service Layer                           │
   ├─────────────────────────────────────────┤
   │ 1. Validate input                       │
   │ 2. Enforce business rules               │
   │ 3. Check user authorization             │
   │ 4. Call repository                      │
   └─────────────────────────────────────────┘
       │
       ↓
   ┌─────────────────────────────────────────┐
   │ Repository (Spring Data JPA)             │
   ├─────────────────────────────────────────┤
   │ 1. Generate SQL query                   │
   │ 2. Execute database operation           │
   │ 3. Map results to entities              │
   └─────────────────────────────────────────┘
       │
       ↓
   ┌─────────────────────────────────────────┐
   │ Database (MySQL)                        │
   ├─────────────────────────────────────────┤
   │ Execute query and return results        │
   └─────────────────────────────────────────┘
       │
       ↓ (return up the chain)
   ┌─────────────────────────────────────────┐
   │ Response Handler                        │
   ├─────────────────────────────────────────┤
   │ 1. Convert entity to DTO                │
   │ 2. Set HTTP status code                 │
   │ 3. Serialize to JSON                    │
   │ 4. Add headers                          │
   └─────────────────────────────────────────┘
       │
       ↓
HTTP Response (JSON body + status code)
```

---

## 4. Data Model (ER Diagram)

```
┌─────────────────────────┐           ┌──────────────────────────┐
│        users            │           │      user_roles          │
├─────────────────────────┤           ├──────────────────────────┤
│ PK  id (BIGINT)         │           │ PK  user_id (FK, BIGINT) │
│ UQ  username (VARCHAR)  │←──1:M──→  │ PK  role (VARCHAR)       │
│ UQ  email (VARCHAR)     │           │                          │
│ NON password (VARCHAR)  │           │ Values: USER, ADMIN      │
│ NON created_at (TIME)   │           │                          │
│ NON updated_at (TIME)   │           │                          │
└─────────────────────────┘           └──────────────────────────┘
        │
        │ 1
        │
        ├─→ (owns many)
        │
        ∞
        │
┌───────────────────────────────────┐
│          tasks                    │
├───────────────────────────────────┤
│ PK  id (BIGINT)                   │
│ NON title (VARCHAR)               │
│ NON description (TEXT)            │
│ NON completed (BOOLEAN)           │
│ FK  user_id (BIGINT) ← references │
│ NON created_at (TIMESTAMP)        │
│ NON updated_at (TIMESTAMP)        │
│                                   │
│ Indexes:                          │
│ - idx_user_id                     │
│ - idx_completed                   │
└───────────────────────────────────┘

Legend:
PK = Primary Key
FK = Foreign Key
UQ = Unique
NON = NOT NULL
1:M = One-to-Many relationship
```

---

## 5. Security Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    SECURITY LAYERS                              │
└─────────────────────────────────────────────────────────────────┘

1. TRANSPORT LAYER
┌────────────────────────────────────────────────────────┐
│ HTTPS/TLS Encryption                                   │
│ - All data in transit encrypted                        │
│ - Certificate pinning (future)                         │
│ - Only HTTPS allowed in production                     │
└────────────────────────────────────────────────────────┘
            │
            ↓

2. REQUEST VALIDATION LAYER
┌────────────────────────────────────────────────────────┐
│ Input Validation & Sanitization                        │
│ - CORS checks                                          │
│ - Content-Type validation                              │
│ - Request size limits                                  │
│ - Rate limiting (future)                               │
└────────────────────────────────────────────────────────┘
            │
            ↓

3. AUTHENTICATION LAYER
┌────────────────────────────────────────────────────────┐
│ JWT Token Validation                                   │
│ - Extract token from Authorization header              │
│ - Verify signature: HMAC-SHA256                        │
│ - Check expiration: 24 hours                           │
│ - Load user details from SecurityContext              │
│ - Create Authentication object                        │
└────────────────────────────────────────────────────────┘
            │
            ↓

4. AUTHORIZATION LAYER
┌────────────────────────────────────────────────────────┐
│ Role-Based Access Control (RBAC)                       │
│ - User must have valid token                           │
│ - Check user roles (USER, ADMIN)                       │
│ - Verify resource ownership (for tasks)                │
│ - @PreAuthorize and @Secured annotations               │
│ - User filter queries by user ID                       │
└────────────────────────────────────────────────────────┘
            │
            ↓

5. DATA LAYER
┌────────────────────────────────────────────────────────┐
│ Database & Credential Security                         │
│ - SQL Injection prevention: Parameterized queries      │
│ - Password hashing: BCrypt (cost 10)                   │
│ - Never store plain passwords                          │
│ - Database connection pooling                          │
│ - Environment variables for credentials                │
│ - Encryption at rest (future)                          │
└────────────────────────────────────────────────────────┘
```

---

## 6. Frontend Component Structure

```
App (Root)
│
├─ AuthProvider (Context)
│  │
│  └─ AuthContext
│     ├─ user state
│     ├─ token state
│     ├─ login()
│     ├─ register()
│     └─ logout()
│
└─ Router (React Router v7)
   │
   ├─ Route: /login
   │  └─ Login Component
   │     ├─ Form (username/password)
   │     ├─ authService.login()
   │     └─ Redirect to /dashboard
   │
   ├─ Route: /register
   │  └─ Register Component
   │     ├─ Form (username/email/password)
   │     ├─ authService.register()
   │     ├─ Auto-login
   │     └─ Redirect to /dashboard
   │
   └─ Route: /dashboard (Protected)
      └─ Dashboard Component
         ├─ Task List Display
         │  ├─ taskService.getAllTasks()
         │  └─ Map to Task Items
         │
         ├─ Create Task Form
         │  ├─ Input validation
         │  ├─ taskService.createTask()
         │  └─ Update task list
         │
         ├─ Edit Task Form
         │  ├─ taskService.updateTask()
         │  └─ Update UI
         │
         └─ Delete Task
            ├─ Confirm dialog
            ├─ taskService.deleteTask()
            └─ Update UI
```

---

## 7. API Request/Response Examples

### User Registration
```
REQUEST:
POST /api/auth/register
Content-Type: application/json

{
  "username": "johndoe",
  "email": "john@example.com",
  "password": "SecurePass123!"
}

RESPONSE (201):
{
  "id": 1,
  "username": "johndoe",
  "email": "john@example.com",
  "roles": ["USER"]
}
```

### User Login
```
REQUEST:
POST /api/auth/login
Content-Type: application/json

{
  "username": "johndoe",
  "password": "SecurePass123!"
}

RESPONSE (200):
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c",
  "tokenType": "Bearer",
  "expiresIn": 86400000
}
```

### Create Task
```
REQUEST:
POST /api/tasks
Authorization: Bearer {token}
Content-Type: application/json

{
  "title": "Complete project",
  "description": "Finish the task management system",
  "completed": false
}

RESPONSE (201):
{
  "id": 1,
  "title": "Complete project",
  "description": "Finish the task management system",
  "completed": false,
  "userId": 1,
  "createdAt": "2026-04-06T10:30:00Z",
  "updatedAt": "2026-04-06T10:30:00Z"
}
```

### Get All Tasks
```
REQUEST:
GET /api/tasks
Authorization: Bearer {token}

RESPONSE (200):
[
  {
    "id": 1,
    "title": "Complete project",
    "description": "...",
    "completed": false,
    "userId": 1,
    "createdAt": "2026-04-06T10:30:00Z",
    "updatedAt": "2026-04-06T10:30:00Z"
  },
  {
    "id": 2,
    "title": "Review code",
    "description": null,
    "completed": true,
    "userId": 1,
    "createdAt": "2026-04-05T15:45:00Z",
    "updatedAt": "2026-04-06T11:00:00Z"
  }
]
```

---

## 8. Deployment Architecture

```
┌─────────────────────────────────────────────────────────┐
│               PRODUCTION ENVIRONMENT                    │
└─────────────────────────────────────────────────────────┘

                    INTERNET
                       ↓
            ┌──────────────────────┐
            │   Load Balancer      │
            │ (HTTPS Termination)  │
            └──────────────────────┘
                       ↓
      ┌────────────────┬────────────────┐
      ↓                ↓                ↓
┌──────────┐    ┌──────────┐    ┌──────────┐
│ CDN Layer│    │ Nginx #1 │    │ Nginx #2 │
│(Static   │    │(Caching) │    │(Caching) │
│ assets)  │    └──────────┘    └──────────┘
└──────────┘           ↓                ↓
                ┌──────────────────────┐
                │  API Gateway / LB    │
                └──────────────────────┘
                       ↓
      ┌────────────────┼────────────────┐
      ↓                ↓                ↓
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│Spring Boot #1│ │Spring Boot #2│ │Spring Boot #3│
│  (Port 8080) │ │  (Port 8080) │ │  (Port 8080) │
└──────────────┘ └──────────────┘ └──────────────┘
      ↓                ↓                ↓
                ┌──────────────────────┐
                │  Database LB         │
                └──────────────────────┘
                       ↓
┌───────────────────────┴───────────────────────┐
↓                                               ↓
████████████████████████████████████      ░░░░░░░░░░░░░░░░░░░░░░░░░░░░
Primary MySQL Instance              Replica MySQL Instance
(Master - Read/Write)               (Slave - Read-only)
████████████████████████████████████      ░░░░░░░░░░░░░░░░░░░░░░░░░░░░
        ↓                                       ↑
    Binary logs ───────────────────── → Replication
```

---

## 9. Technology Stack Matrix

```
┌────────────────┬─────────────────────┬──────────────┬─────────────┐
│ Layer          │ Technology          │ Version      │ Purpose     │
├────────────────┼─────────────────────┼──────────────┼─────────────┤
│ Web Browser    │ React               │ 19.2.4       │ UI          │
│ Build Tool     │ Vite                │ 8.0.4        │ Bundling    │
│ Routing        │ React Router        │ 7.14.0       │ Navigation  │
│ HTTP Client    │ Axios               │ 1.14.0       │ API Calls   │
│ Icons          │ Lucide React        │ 1.7.0        │ UI Elements │
├────────────────┼─────────────────────┼──────────────┼─────────────┤
│ Language       │ Java                │ 17 (LTS)     │ Backend     │
│ Framework      │ Spring Boot         │ 3.2.3        │ App Server  │
│ Web Server     │ Tomcat (embedded)   │ 10.1.x       │ HTTP Server │
│ Data Access    │ Spring Data JPA     │ 3.2.3        │ ORM         │
│ Security       │ Spring Security     │ 3.2.3        │ Auth/Authz  │
│ JWT            │ JJWT                │ 0.11.5       │ Tokens      │
│ Boilerplate    │ Lombok              │ 1.18.32      │ Code Gen    │
│ Build Tool     │ Maven               │ 3.9.14       │ Dependency  │
├────────────────┼─────────────────────┼──────────────┼─────────────┤
│ Database       │ MySQL               │ 8.0+         │ Data Store  │
│ Driver         │ MySQL Connector/J   │ Latest       │ JDBC Driver │
│ Connection Pool│ HikariCP            │ Default      │ Pooling     │
└────────────────┴─────────────────────┴──────────────┴─────────────┘
```

---

## 10. Development Workflow

```
Developer Workspace
    │
    ├─ Backend Development
    │  ├─ IDE: IntelliJ IDEA / Eclipse / VS Code
    │  ├─ Spring Boot Dev Server (Hot Reload)
    │  ├─ MySQL Local Instance
    │  ├─ Postman / Thunder Client for API testing
    │  └─ Maven for building
    │
    └─ Frontend Development
       ├─ IDE: VS Code
       ├─ Vite Dev Server (HMR)
       ├─ Chrome DevTools
       ├─ npm for dependencies
       └─ ESLint for linting

Version Control (Git)
    │
    ├─ main (Production)
    │  └─ Protected: PR reviews required
    │
    ├─ develop (Development)
    │  └─ Protected: PR reviews required
    │
    └─ feature/* (Feature branches)
       └─ Created from develop
       └─ Merged via PR back to develop

CI/CD Pipeline (Future)
    │
    ├─ GitHub Actions / Jenkins
    ├─ Automated testing
    ├─ Build & deploy to staging
    └─ Manual promotion to production
```

---

**Diagram Documentation**: All diagrams use ASCII art for clarity and version control compatibility.

Last Updated: April 6, 2026

