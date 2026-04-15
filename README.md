# Taskmgr - Task Management System

A full-stack web application for managing tasks with secure user authentication, role-based access control, and a modern REST API.

## Quick Links

📖 **[Complete Design Document](./DESIGN_DOCUMENT.md)** - Comprehensive specification for the entire project

## Project Overview

**Taskmgr** is a task management platform that enables users to:
- Register and authenticate securely
- Create, manage, and track tasks
- Get real-time updates
- Access tasks across devices

### Key Features
✅ User registration and authentication  
✅ JWT-based session management  
✅ Task CRUD operations  
✅ Role-based access control  
✅ Responsive web interface  
✅ Secure REST API  

---

## Technology Stack

### Backend
- **Java 17 (LTS)** - Language
- **Spring Boot 3.2.3** - Framework
- **Spring Data JPA** - Data access
- **Spring Security** - Authentication
- **MySQL 8.0+** - Database
- **JJWT 0.11.5** - JWT tokens
- **Maven 3.9.14** - Build tool

### Frontend
- **React 19.2.4** - UI framework
- **Vite 8.0.4** - Build tool
- **React Router 7.14.0** - Client routing
- **Axios 1.14.0** - HTTP client
- **Lucide React 1.7.0** - Icons

---

## Quick Start

### Prerequisites
- JDK 17+
- Node.js 18+
- MySQL 8.0+

### Backend Setup
```bash
cd backend

# Configure database in src/main/resources/application.properties
# Update spring.datasource.url, username, and password

# Run application
mvn spring-boot:run

# Application runs on http://localhost:8080
```

### Frontend Setup
```bash
cd frontend

# Install dependencies
npm install

# Start development server
npm run dev

# Application runs on http://localhost:5173
```

---

## API Base URL
```
http://localhost:8080/api
```

### Key Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/auth/register` | Create new user account |
| POST | `/auth/login` | Authenticate user |
| GET | `/tasks` | Get all user's tasks |
| POST | `/tasks` | Create new task |
| PUT | `/tasks/{id}` | Update task |
| DELETE | `/tasks/{id}` | Delete task |

**Authentication**: All endpoints except `/auth/*` require JWT token in `Authorization: Bearer {token}` header

---

## Project Structure

```
project-root/
├── backend/                          # Spring Boot API
│   ├── src/main/java/.../taskmgr/
│   │   ├── controller/              # REST controllers
│   │   ├── service/                 # Business logic
│   │   ├── repository/              # Data access
│   │   ├── model/                   # JPA entities
│   │   ├── security/                # Auth & security
│   │   ├── dto/                     # Data transfer objects
│   │   ├── config/                  # Configuration
│   │   └── exception/               # Exception handling
│   ├── src/main/resources/
│   │   └── application.properties   # Config file
│   └── pom.xml                      # Maven dependencies
│
├── frontend/                         # React SPA
│   ├── src/
│   │   ├── pages/                   # Route components
│   │   ├── services/                # API communication
│   │   ├── context/                 # State management
│   │   ├── App.jsx                  # Root component
│   │   └── ...
│   ├── package.json
│   ├── vite.config.js
│   └── index.html
│
└── DESIGN_DOCUMENT.md               # Full system design
```

---

## Database Schema

### Tables
- **users** - User accounts and credentials
- **user_roles** - User role assignments
- **tasks** - Task records per user

### ER Diagram
```
Users (1) ──→ (∞) Tasks
    └─→ User_Roles
```

<<<<<<< HEAD
=======
See [Database Design](./DESIGN_DOCUMENT.md#4-database-design) for full schema.
>>>>>>> 0cd7d3f (Initial commit: Prepare project for Render deployment)

---

## Security

### Authentication
- JWT tokens (HS256)
- 24-hour expiration
- BCrypt password hashing

### Authorization
- Role-Based Access Control (RBAC)
- User isolation (access only own tasks)
- CORS protection
- XSS prevention

<<<<<<< HEAD

=======
See [Security Design](./DESIGN_DOCUMENT.md#7-security-design) for details.
>>>>>>> 0cd7d3f (Initial commit: Prepare project for Render deployment)

---

## Development

### Build Commands

**Backend**
```bash
cd backend
mvn clean install          # Install and build
mvn spring-boot:run        # Run development server
mvn clean test             # Run tests
mvn clean package          # Build JAR
```

**Frontend**
```bash
cd frontend
npm install                # Install dependencies
npm run dev                # Development server
npm run build              # Production build
npm run lint               # Code linting
```

### Debugging

**Backend**: Use IDE debugger or attach to port 5005
**Frontend**: Chrome DevTools (F12) or VS Code debugger

<<<<<<< HEAD

=======
See [Development Guide](./DESIGN_DOCUMENT.md#9-development-guide) for more.
>>>>>>> 0cd7d3f (Initial commit: Prepare project for Render deployment)

---

## Deployment

### Production Checklist
- [ ] Environment variables configured
- [ ] Database backed up
- [ ] SSL/TLS enabled
- [ ] CORS origins whitelisted
- [ ] JWT secret secured
- [ ] Logging configured
- [ ] Monitoring set up

<<<<<<< HEAD
=======
See [Deployment Architecture](./DESIGN_DOCUMENT.md#8-deployment-architecture) for instructions.
>>>>>>> 0cd7d3f (Initial commit: Prepare project for Render deployment)

---

## Future Enhancements

- 🎯 Task categories and tags
- 📅 Due dates and reminders
- 👥 Team collaboration
- 📊 Analytics dashboard
- 📱 Mobile app
- 🔔 Notifications
- 🌙 Dark mode

<<<<<<< HEAD

=======
See [Future Enhancements](./DESIGN_DOCUMENT.md#10-future-enhancements) for complete roadmap.
>>>>>>> 0cd7d3f (Initial commit: Prepare project for Render deployment)

---

## Support

For detailed information on any aspect of the project:
1. Refer to [DESIGN_DOCUMENT.md](./DESIGN_DOCUMENT.md)
2. Check inline code comments
3. Review API documentation in design document

---

## Version

**Current**: 1.0.0-SNAPSHOT  
**Java**: 17 (upgrading to 21)  
**Status**: Active Development

---

## License

<<<<<<< HEAD

=======
[Add your license here]
>>>>>>> 0cd7d3f (Initial commit: Prepare project for Render deployment)

---

**Last Updated**: April 6, 2026  
<<<<<<< HEAD
**Project Lead**:
=======
**Project Lead**: [Add team info]
>>>>>>> 0cd7d3f (Initial commit: Prepare project for Render deployment)

