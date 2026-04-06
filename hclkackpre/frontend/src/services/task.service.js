import api from './api';

const getAllTasks = () => {
  return api.get('/tasks');
};

const createTask = (task) => {
  return api.post('/tasks', task);
};

const updateTask = (id, task) => {
  return api.put(`/tasks/${id}`, task);
};

const deleteTask = (id) => {
  return api.delete(`/tasks/${id}`);
};

const taskService = {
  getAllTasks,
  createTask,
  updateTask,
  deleteTask,
};

export default taskService;
