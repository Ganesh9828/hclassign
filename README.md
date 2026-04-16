# Task Manager Application

A full-stack task management application built with Spring Boot (Java) backend and React frontend. This application allows users to register, login, and manage their tasks with JWT authentication.

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Installation](#installation)
- [Running the Application](#running-the-application)
- [API Endpoints](#api-endpoints)
- [Configuration](#configuration)
- [Contributing](#contributing)
- [License](#license)

## Features

- **User Authentication**: Secure user registration and login with JWT tokens
- **Task Management**: Create, read, update, and delete tasks
- **Role-Based Access**: Support for different user roles
- **CORS Support**: Configured CORS for frontend-backend communication
- **Real-time Updates**: Seamless task management experience
- **Responsive UI**: Modern React frontend with Vite

## Tech Stack

### Backend
- **Framework**: Spring Boot 3.2.3
- **Language**: Java 21
- **Database**: MySQL
- **Authentication**: JWT (JSON Web Tokens)
- **Build Tool**: Maven
- **Dependencies**:
  - Spring Data JPA
  - Spring Security
  - Spring Web
  - MySQL Connector
  - JWT (JJWT)

### Frontend
- **Library**: React 19.2.4
- **Build Tool**: Vite 8.0.4
- **Routing**: React Router DOM 7.14.0
- **HTTP Client**: Axios 1.14.0
- **Styling**: CSS

## Prerequisites

Before you begin, ensure you have the following installed:
- **Java 21** or higher
- **Maven** (for backend build)
- **Node.js** (v16 or higher) and npm
- **MySQL Server** (running on localhost:3306)

## Project Structure

```
hclkackpre/
├── backend/                          # Spring Boot Application
│   ├── src/main/java/com/example/taskmgr/
│   │   ├── config/                  # Configuration classes
│   │   ├── controller/              # REST API Controllers
│   │   ├── dto/                     # Data Transfer Objects
│   │   ├── exception/               # Custom Exceptions
│   │   ├── model/                   # Entity Models
│   │   ├── repository/              # JPA Repositories
│   │   ├── security/                # Security & JWT Logic
│   │   ├── services/                # Business Logic
│   │   └── TaskmgrApplication.java  # Main Application Class
│   ├── src/main/resources/
│   │   └── application.properties    # Configuration File
│   └── pom.xml                       # Maven Dependencies
│
└── frontend/                         # React Application
    ├── src/
    │   ├── pages/                   # Page Components
    │   ├── services/                # API Services
    │   ├── context/                 # React Context (Auth)
    │   ├── App.jsx                  # Main App Component
    │   └── main.jsx                 # Entry Point
    ├── package.json                 # NPM Dependencies
    ├── vite.config.js               # Vite Configuration
    └── index.html                   # HTML Template
```

## Installation

### Backend Setup

1. **Navigate to backend directory**:
```bash
cd hclkackpre/backend
```

2. **Update Database Configuration**:
   Edit `src/main/resources/application.properties` with your MySQL credentials:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/task_db?createDatabaseIfNotExist=true&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=your_password
```

3. **Build the Project**:
```bash
mvn clean install
```

### Frontend Setup

1. **Navigate to frontend directory**:
```bash
cd hclkackpre/frontend
```

2. **Install Dependencies**:
```bash
npm install
```

## Running the Application

### Start Backend Server

```bash
cd hclkackpre/backend
mvn spring-boot:run
```

The backend will start on `http://localhost:8080`

### Start Frontend Development Server

```bash
cd hclkackpre/frontend
npm run dev
```

The frontend will start on `http://localhost:5173`

### Production Build

Frontend production build:
```bash
npm run build
```

## API Endpoints

### Authentication
- **POST** `/api/auth/register` - Register a new user
- **POST** `/api/auth/login` - Login user and get JWT token

### Tasks
- **GET** `/api/tasks` - Get all tasks for the logged-in user
- **POST** `/api/tasks` - Create a new task
- **GET** `/api/tasks/{id}` - Get a specific task
- **PUT** `/api/tasks/{id}` - Update a task
- **DELETE** `/api/tasks/{id}` - Delete a task

## Configuration

### JWT Configuration
Edit `application.properties` to modify JWT settings:
```properties
jwt.secret=your_secret_key_here
jwt.expiration=86400000  # 24 hours in milliseconds
```

### Database Configuration
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/task_db?createDatabaseIfNotExist=true
spring.datasource.username=root
spring.datasource.password=your_password
spring.jpa.hibernate.ddl-auto=update
```

### Server Port
```properties
server.port=8080
```

## Usage

1. **Access the Application**: Open `http://localhost:5173` in your browser
2. **Register**: Create a new account with email and password
3. **Login**: Login with your credentials
4. **Manage Tasks**: Add, edit, and delete tasks in the dashboard

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support, email support@taskmgr.com or open an issue in the repository.

---

**Last Updated**: April 16, 2026

**Repository**: https://github.com/Ganesh9828/hclassign
