# API Reference & Development Best Practices

## Table of Contents
1. [API Quick Reference](#api-quick-reference)
2. [API Testing Guide](#api-testing-guide)
3. [Error Handling Guide](#error-handling-guide)
4. [Code Examples](#code-examples)
5. [Best Practices](#best-practices)
6. [Troubleshooting](#troubleshooting)

---

## API Quick Reference

### Base Configuration
```
Base URL: http://localhost:8080/api
Protocol: HTTP (Development) / HTTPS (Production)
Content-Type: application/json
Authentication: JWT Bearer Token in Authorization header
```

---

## Authentication Endpoints

### 1. Register User
```http
POST /auth/register
Content-Type: application/json
No authentication required

Request Body:
{
  "username": "johndoe",
  "email": "john@example.com",
  "password": "SecurePass123!"
}

Response: 201 Created
{
  "id": 1,
  "username": "johndoe",
  "email": "john@example.com",
  "roles": ["USER"]
}

Validation Rules:
- username: Required, 3-50 characters, unique
- email: Required, valid email format, unique
- password: Required, min 8 characters, at least 1 uppercase, 1 digit, 1 special char
```

### 2. Login User
```http
POST /auth/login
Content-Type: application/json
No authentication required

Request Body:
{
  "username": "johndoe",
  "password": "SecurePass123!"
}

Response: 200 OK
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "tokenType": "Bearer",
  "expiresIn": 86400000
}

Error Responses:
400 Bad Request - Invalid credentials
401 Unauthorized - User not found
```

---

## Task Endpoints

All task endpoints require JWT authentication in Authorization header.

### 3. Get All Tasks
```http
GET /tasks
Authorization: Bearer {accessToken}

Query Parameters:
- page: (optional, future) Page number for pagination
- size: (optional, future) Items per page

Response: 200 OK
[
  {
    "id": 1,
    "title": "Complete project documentation",
    "description": "Write comprehensive design document",
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

Notes:
- Returns only tasks owned by authenticated user
- No pagination limitation in current version
```

### 4. Get Task by ID
```http
GET /tasks/{taskId}
Authorization: Bearer {accessToken}

Path Parameters:
- taskId: Long, required

Response: 200 OK
{
  "id": 1,
  "title": "Complete project documentation",
  "description": "Write comprehensive design document",
  "completed": false,
  "userId": 1,
  "createdAt": "2026-04-06T10:30:00Z",
  "updatedAt": "2026-04-06T10:30:00Z"
}

Response: 404 Not Found
{
  "timestamp": "2026-04-06T12:00:00Z",
  "status": 404,
  "error": "Not Found",
  "message": "Task with id 999 not found",
  "path": "/api/tasks/999"
}

Notes:
- Returns 404 if task doesn't exist
- Returns 403 Forbidden if task belongs to different user
```

### 5. Create Task
```http
POST /tasks
Authorization: Bearer {accessToken}
Content-Type: application/json

Request Body:
{
  "title": "New task",
  "description": "Optional task description",
  "completed": false
}

Response: 201 Created
{
  "id": 3,
  "title": "New task",
  "description": "Optional task description",
  "completed": false,
  "userId": 1,
  "createdAt": "2026-04-06T12:30:00Z",
  "updatedAt": "2026-04-06T12:30:00Z"
}

Validation Rules:
- title: Required, 1-255 characters
- description: Optional, max 2000 characters
- completed: Optional, defaults to false

Response: 400 Bad Request
{
  "timestamp": "2026-04-06T12:30:00Z",
  "status": 400,
  "error": "Bad Request",
  "message": "Title is required",
  "path": "/api/tasks"
}
```

### 6. Update Task
```http
PUT /tasks/{taskId}
Authorization: Bearer {accessToken}
Content-Type: application/json

Path Parameters:
- taskId: Long, required

Request Body:
{
  "title": "Updated task title",
  "description": "Updated description",
  "completed": true
}

Response: 200 OK
{
  "id": 1,
  "title": "Updated task title",
  "description": "Updated description",
  "completed": true,
  "userId": 1,
  "createdAt": "2026-04-06T10:30:00Z",
  "updatedAt": "2026-04-06T12:35:00Z"
}

Acceptable Update Combinations:
- Only title: allowed
- Only description: allowed
- Only completed: allowed
- Any combination: allowed
- Empty body: 400 Bad Request (at least one field required)

Response: 404 Not Found
- Task ID doesn't exist

Response: 403 Forbidden
- Attempting to update task of another user
```

### 7. Delete Task
```http
DELETE /tasks/{taskId}
Authorization: Bearer {accessToken}

Path Parameters:
- taskId: Long, required

Response: 204 No Content
(Empty body)

Response: 404 Not Found
- Task ID doesn't exist

Response: 403 Forbidden
- Attempting to delete task of another user
```

---

## API Testing Guide

### Using cURL

#### Register
```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "TestPass123!"
  }'
```

#### Login
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "TestPass123!"
  }'

# Save token to variable
TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

#### Create Task
```bash
curl -X POST http://localhost:8080/api/tasks \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "title": "My first task",
    "description": "Task description",
    "completed": false
  }'
```

#### Get All Tasks
```bash
curl -X GET http://localhost:8080/api/tasks \
  -H "Authorization: Bearer $TOKEN"
```

#### Update Task
```bash
curl -X PUT http://localhost:8080/api/tasks/1 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "title": "Updated task",
    "completed": true
  }'
```

#### Delete Task
```bash
curl -X DELETE http://localhost:8080/api/tasks/1 \
  -H "Authorization: Bearer $TOKEN"
```

### Using Postman

1. Create collection "Task Manager API"
2. Create environment with variable: `base_url=http://localhost:8080/api`
3. Add requests:

#### Register Request
```
Method: POST
URL: {{base_url}}/auth/register
Headers: Content-Type: application/json
Body (raw):
{
  "username": "test123",
  "email": "test@example.com",
  "password": "TestPass123!"
}
```

#### Login Request
```
Method: POST
URL: {{base_url}}/auth/login
Headers: Content-Type: application/json
Body (raw):
{
  "username": "test123",
  "password": "TestPass123!"
}

Tests (save token):
- var jsonData = pm.response.json();
  pm.environment.set("token", jsonData.accessToken);
```

#### Create Task Request
```
Method: POST
URL: {{base_url}}/tasks
Headers: 
  Content-Type: application/json
  Authorization: Bearer {{token}}
Body (raw):
{
  "title": "My task",
  "description": "Task description",
  "completed": false
}
```

---

## Error Handling Guide

### Standard Error Response Format
```json
{
  "timestamp": "2026-04-06T12:00:00Z",
  "status": 400,
  "error": "Bad Request",
  "message": "Validation failed: username must be unique",
  "path": "/api/auth/register"
}
```

### Common HTTP Status Codes

| Status | Meaning | When It Occurs |
|--------|---------|----------------|
| 200 | OK | Successful GET/PUT request |
| 201 | Created | Successful POST request |
| 204 | No Content | Successful DELETE, no body |
| 400 | Bad Request | Invalid input validation |
| 401 | Unauthorized | Missing/invalid JWT token |
| 403 | Forbidden | Valid token but no permission |
| 404 | Not Found | Resource doesn't exist |
| 409 | Conflict | Duplicate unique field |
| 500 | Server Error | Unexpected server error |

### Common Error Scenarios

#### Invalid Credentials
```
Request: POST /auth/login
Body: { "username": "nonexistent", "password": "wrong" }

Response: 401 Unauthorized
{
  "timestamp": "2026-04-06T12:00:00Z",
  "status": 401,
  "error": "Unauthorized",
  "message": "Bad credentials",
  "path": "/api/auth/login"
}
```

#### Duplicate Username
```
Request: POST /auth/register (username already taken)

Response: 409 Conflict
{
  "timestamp": "2026-04-06T12:00:00Z",
  "status": 409,
  "error": "Conflict",
  "message": "Username already exists",
  "path": "/api/auth/register"
}
```

#### Missing JWT Token
```
Request: GET /tasks (no Authorization header)

Response: 401 Unauthorized
{
  "timestamp": "2026-04-06T12:00:00Z",
  "status": 401,
  "error": "Unauthorized",
  "message": "Full authentication is required",
  "path": "/api/tasks"
}
```

#### Expired Token
```
Response: 401 Unauthorized
{
  "timestamp": "2026-04-06T12:00:00Z",
  "status": 401,
  "error": "Unauthorized",
  "message": "JWT token is expired",
  "path": "/api/tasks"
}
```

#### Access Denied (Different User's Task)
```
Request: DELETE /tasks/555 (owned by user 2, token is user 1)

Response: 403 Forbidden
{
  "timestamp": "2026-04-06T12:00:00Z",
  "status": 403,
  "error": "Forbidden",
  "message": "You don't have permission to access this resource",
  "path": "/api/tasks/555"
}
```

---

## Code Examples

### Backend - Spring Boot

#### Creating a Secured Endpoint
```java
@RestController
@RequestMapping("/api/tasks")
@RequiredArgsConstructor
public class TaskController {
    
    private final TaskService taskService;
    
    // Only authenticated users can access
    @GetMapping
    public ResponseEntity<List<TaskDto>> getAllTasks(
            @AuthenticationPrincipal UserDetails userDetails) {
        List<TaskDto> tasks = taskService.getUserTasks(userDetails.getUsername());
        return ResponseEntity.ok(tasks);
    }
}
```

#### Service Layer Implementation
```java
@Service
@RequiredArgsConstructor
@Transactional
public class TaskService {
    
    private final TaskRepository taskRepository;
    private final UserRepository userRepository;
    
    public TaskDto createTask(String username, CreateTaskRequest request) {
        User user = userRepository.findByUsername(username)
            .orElseThrow(() -> new ResourceNotFoundException("User not found"));
        
        Task task = new Task();
        task.setTitle(request.getTitle());
        task.setDescription(request.getDescription());
        task.setCompleted(false);
        task.setUser(user);
        
        Task savedTask = taskRepository.save(task);
        return TaskDto.fromEntity(savedTask);
    }
    
    public TaskDto updateTask(String username, Long taskId, UpdateTaskRequest request) {
        Task task = taskRepository.findById(taskId)
            .orElseThrow(() -> new ResourceNotFoundException("Task not found"));
        
        // Authorization check
        if (!task.getUser().getUsername().equals(username)) {
            throw new AccessDeniedException("You can only modify your own tasks");
        }
        
        if (request.getTitle() != null) {
            task.setTitle(request.getTitle());
        }
        if (request.getDescription() != null) {
            task.setDescription(request.getDescription());
        }
        if (request.getCompleted() != null) {
            task.setCompleted(request.getCompleted());
        }
        
        Task updatedTask = taskRepository.save(task);
        return TaskDto.fromEntity(updatedTask);
    }
}
```

### Frontend - React

#### API Service with Axios
```javascript
import axios from 'axios';

const API_BASE_URL = 'http://localhost:8080/api';

const api = axios.create({
  baseURL: API_BASE_URL
});

// Add token to every request
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Handle token expiration
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Token expired, clear and redirect to login
      localStorage.removeItem('token');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

export default api;
```

#### Using Task Service
```javascript
import api from './api';

export const taskService = {
  getAllTasks: async () => {
    try {
      const response = await api.get('/tasks');
      return response.data;
    } catch (error) {
      console.error('Error fetching tasks:', error);
      throw error;
    }
  },

  createTask: async (taskData) => {
    try {
      const response = await api.post('/tasks', taskData);
      return response.data;
    } catch (error) {
      console.error('Error creating task:', error);
      throw error;
    }
  },

  updateTask: async (taskId, taskData) => {
    try {
      const response = await api.put(`/tasks/${taskId}`, taskData);
      return response.data;
    } catch (error) {
      console.error('Error updating task:', error);
      throw error;
    }
  },

  deleteTask: async (taskId) => {
    try {
      await api.delete(`/tasks/${taskId}`);
    } catch (error) {
      console.error('Error deleting task:', error);
      throw error;
    }
  }
};
```

#### Using in React Component
```javascript
import { useState, useEffect } from 'react';
import { taskService } from '../services/task.service';

function TaskDashboard() {
  const [tasks, setTasks] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    loadTasks();
  }, []);

  const loadTasks = async () => {
    try {
      setLoading(true);
      const data = await taskService.getAllTasks();
      setTasks(data);
      setError(null);
    } catch (err) {
      setError('Failed to load tasks');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleCreateTask = async (taskData) => {
    try {
      const newTask = await taskService.createTask(taskData);
      setTasks([...tasks, newTask]);
    } catch (err) {
      setError('Failed to create task');
    }
  };

  const handleDeleteTask = async (taskId) => {
    try {
      await taskService.deleteTask(taskId);
      setTasks(tasks.filter(t => t.id !== taskId));
    } catch (err) {
      setError('Failed to delete task');
    }
  };

  if (loading) return <div>Loading...</div>;

  return (
    <div>
      {error && <div className="error">{error}</div>}
      {tasks.map(task => (
        <div key={task.id} className="task">
          <h3>{task.title}</h3>
          <p>{task.description}</p>
          <button onClick={() => handleDeleteTask(task.id)}>Delete</button>
        </div>
      ))}
    </div>
  );
}

export default TaskDashboard;
```

---

## Best Practices

### Backend Best Practices

#### 1. Authentication & Authorization
```java
// ✅ Good: Check user ownership
@DeleteMapping("/{taskId}")
public ResponseEntity<?> deleteTask(
        @PathVariable Long taskId,
        @AuthenticationPrincipal UserDetails userDetails) {
    taskService.deleteTask(taskId, userDetails.getUsername());
    return ResponseEntity.noContent().build();
}

// ❌ Bad: No ownership check
@DeleteMapping("/{taskId}")
public ResponseEntity<?> deleteTask(@PathVariable Long taskId) {
    taskRepository.deleteById(taskId);
    return ResponseEntity.noContent().build();
}
```

#### 2. Input Validation
```java
// ✅ Good: Validate before processing
@PostMapping
public ResponseEntity<TaskDto> createTask(@Valid @RequestBody CreateTaskRequest request) {
    if (request.getTitle() == null || request.getTitle().trim().isEmpty()) {
        throw new BadRequestException("Title cannot be empty");
    }
    // Process...
}

// ❌ Bad: Trust user input
@PostMapping
public ResponseEntity<TaskDto> createTask(@RequestBody CreateTaskRequest request) {
    Task task = new Task();
    task.setTitle(request.getTitle()); // What if null?
    // Save...
}
```

#### 3. Exception Handling
```java
// ✅ Good: Specific exception handling
@ExceptionHandler(ResourceNotFoundException.class)
public ResponseEntity<ErrorDetails> handleResourceNotFound(
        ResourceNotFoundException ex, HttpServletRequest req) {
    ErrorDetails errorDetails = new ErrorDetails(
        LocalDateTime.now(),
        HttpStatus.NOT_FOUND.value(),
        "Resource not found",
        ex.getMessage(),
        req.getRequestURI()
    );
    return new ResponseEntity<>(errorDetails, HttpStatus.NOT_FOUND);
}

// ❌ Bad: Generic exception handling only
@ExceptionHandler(Exception.class)
public ResponseEntity<?> handleException(Exception ex) {
    return ResponseEntity.status(500).body(ex.getMessage());
}
```

### Frontend Best Practices

#### 1. Authentication Management
```javascript
// ✅ Good: Persistent login with fallback
const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [token, setToken] = useState(localStorage.getItem('token'));

  useEffect(() => {
    if (token) {
      api.defaults.headers.common['Authorization'] = `Bearer ${token}`;
    }
  }, [token]);

  const logout = () => {
    localStorage.removeItem('token');
    setToken(null);
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ user, token, logout }}>
      {children}
    </AuthContext.Provider>
  );
};

// ❌ Bad: No token persistence
const login = (username, password) => {
  return api.post('/auth/login', { username, password })
    .then(res => res.data.accessToken);
    // Token not stored anywhere
};
```

#### 2. Error Handling
```javascript
// ✅ Good: User-friendly error messages
const handleCreateTask = async (taskData) => {
  try {
    const newTask = await taskService.createTask(taskData);
    setTasks([...tasks, newTask]);
    showSuccessMessage('Task created successfully');
  } catch (error) {
    if (error.response?.status === 400) {
      showError('Please fill in all required fields');
    } else if (error.response?.status === 401) {
      showError('Session expired, please login again');
    } else {
      showError('Failed to create task. Please try again.');
    }
  }
};

// ❌ Bad: Exposing technical errors
const handleCreateTask = async (taskData) => {
  const newTask = await taskService.createTask(taskData);
  setTasks([...tasks, newTask]);
  // Error will crash the app
};
```

#### 3. Form Validation
```javascript
// ✅ Good: Client-side validation before submission
const [errors, setErrors] = useState({});

const validateForm = (taskData) => {
  const newErrors = {};
  if (!taskData.title || taskData.title.trim() === '') {
    newErrors.title = 'Title is required';
  }
  if (taskData.title && taskData.title.length > 255) {
    newErrors.title = 'Title must be less than 255 characters';
  }
  return newErrors;
};

const handleSubmit = (e) => {
  e.preventDefault();
  const validationErrors = validateForm(taskData);
  if (Object.keys(validationErrors).length > 0) {
    setErrors(validationErrors);
    return;
  }
  // Submit...
};

// ❌ Bad: No validation, rely on server
const handleSubmit = (e) => {
  e.preventDefault();
  taskService.createTask(taskData);
};
```

---

## Troubleshooting

### Backend Issues

#### Issue: "Bad credentials" on login
**Solution**:
1. Verify username/password are correct
2. Check if user exists: `SELECT * FROM users WHERE username = 'x';`
3. Verify password was properly hashed with BCrypt

#### Issue: JWT token expired
**Symptoms**: 401 Unauthorized responses even with valid token
**Solution**:
1. Token expires after 24 hours
2. Log out and log in again to get fresh token
3. Implement token refresh endpoint (future enhancement)

#### Issue: 403 Forbidden when accessing a task
**Solution**:
1. Verify the task ID is correct
2. Check if task belongs to your user account
3. Verify JWT token is included and valid

#### Issue: CORS errors in browser console
**Solution**:
1. Verify backend CORS configuration allows frontend origin
2. Backend should allow: `http://localhost:5173` (dev) or production URL
3. Check `CorsConfig.java` for allowed origins

### Frontend Issues

#### Issue: Blank login/register page
**Solution**:
1. Check if backend is running on port 8080
2. Verify API base URL is correct in `api.js`
3. Check browser console for error messages

#### Issue: "Unauthorized" on every request
**Solution**:
1. Clear localStorage: `localStorage.clear()` in DevTools
2. Log in again to get fresh token
3. Verify token is being sent in Authorization header

#### Issue: Tasks not loading
**Solution**:
1. Log the API response: `console.log(response)`
2. Verify JWT token is in Authorization header
3. Check if backend /tasks endpoint is working (test with Postman)

#### Issue: Form submission not working
**Solution**:
1. Check console for JavaScript errors
2. Verify form inputs have correct names/IDs
3. Check network tab to see actual request/response
4. Verify backend returned 201/200 status

---

**Document Version**: 1.0  
**Last Updated**: April 6, 2026

