import React, { useState, useEffect, useContext } from 'react';
import { AuthContext } from '../context/AuthContext';
import taskService from '../services/task.service';
import { useNavigate } from 'react-router-dom';
import { CheckCircle, Circle, Trash2, Plus, LogOut } from 'lucide-react';
import './Dashboard.css';

const Dashboard = () => {
  const { currentUser, logout } = useContext(AuthContext);
  const [tasks, setTasks] = useState([]);
  const [newTaskTitle, setNewTaskTitle] = useState('');
  const [newTaskDesc, setNewTaskDesc] = useState('');
  const navigate = useNavigate();

  useEffect(() => {
    if (!currentUser) {
      navigate('/login');
    } else {
      fetchTasks();
    }
  }, [currentUser, navigate]);

  const fetchTasks = async () => {
    try {
      const response = await taskService.getAllTasks();
      setTasks(response.data);
    } catch (error) {
      console.error('Failed to fetch tasks', error);
    }
  };

  const handleCreateTask = async (e) => {
    e.preventDefault();
    if (!newTaskTitle.trim()) return;
    try {
      await taskService.createTask({ title: newTaskTitle, description: newTaskDesc, completed: false });
      setNewTaskTitle('');
      setNewTaskDesc('');
      fetchTasks();
    } catch (error) {
      console.error('Failed to create task', error);
    }
  };

  const handleToggleComplete = async (task) => {
    try {
      await taskService.updateTask(task.id, { ...task, completed: !task.completed });
      fetchTasks();
    } catch (error) {
      console.error('Failed to update task', error);
    }
  };

  const handleDeleteTask = async (id) => {
    try {
      await taskService.deleteTask(id);
      fetchTasks();
    } catch (error) {
      console.error('Failed to delete task', error);
    }
  };

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  return (
    <div className="dashboard-container">
      <nav className="navbar">
        <div className="nav-brand">TaskGenius</div>
        <div className="nav-user">
          <span className="welcome-text">Welcome, {currentUser?.username}</span>
          <button className="btn-icon" onClick={handleLogout} title="Logout">
            <LogOut size={20} />
          </button>
        </div>
      </nav>

      <main className="main-content">
        <div className="task-creator glass-card">
          <h3>Create New Task</h3>
          <form onSubmit={handleCreateTask} className="create-task-form">
            <input
              type="text"
              placeholder="Task Title"
              value={newTaskTitle}
              onChange={(e) => setNewTaskTitle(e.target.value)}
              className="input-title"
              required
            />
            <textarea
              placeholder="Task Description (Optional)"
              value={newTaskDesc}
              onChange={(e) => setNewTaskDesc(e.target.value)}
              className="input-desc"
            />
            <button type="submit" className="btn-primary">
              <Plus size={20} /> Add Task
            </button>
          </form>
        </div>

        <div className="task-list">
          {tasks.length === 0 ? (
            <div className="empty-state">No tasks yet. Start creating!</div>
          ) : (
            tasks.map(task => (
              <div key={task.id} className={`task-card ${task.completed ? 'completed' : ''}`}>
                <div className="task-action" onClick={() => handleToggleComplete(task)}>
                  {task.completed ? <CheckCircle className="icon-completed" /> : <Circle className="icon-pending" />}
                </div>
                <div className="task-content">
                  <h4 className="task-title">{task.title}</h4>
                  {task.description && <p className="task-desc">{task.description}</p>}
                </div>
                <button className="btn-icon delete-btn" onClick={() => handleDeleteTask(task.id)}>
                  <Trash2 size={20} />
                </button>
              </div>
            ))
          )}
        </div>
      </main>
    </div>
  );
};

export default Dashboard;
