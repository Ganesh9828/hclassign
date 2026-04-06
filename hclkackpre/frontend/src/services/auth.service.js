import api from './api';

const login = async (username, password) => {
  const response = await api.post('/auth/login', { username, password });
  if (response.data.accessToken) {
    localStorage.setItem('token', response.data.accessToken);
    localStorage.setItem('username', username);
  }
  return response.data;
};

const register = async (username, email, password) => {
  return api.post('/auth/register', { username, email, password });
};

const logout = () => {
  localStorage.removeItem('token');
  localStorage.removeItem('username');
};

const authService = {
  login,
  register,
  logout,
};

export default authService;
