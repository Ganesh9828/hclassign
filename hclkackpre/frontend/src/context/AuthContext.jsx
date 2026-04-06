import React, { createContext, useState, useEffect } from 'react';
import authService from '../services/auth.service';

export const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [currentUser, setCurrentUser] = useState(null);

  useEffect(() => {
    const username = localStorage.getItem('username');
    const token = localStorage.getItem('token');
    if (username && token) {
      setCurrentUser({ username });
    }
  }, []);

  const login = async (username, password) => {
    await authService.login(username, password);
    setCurrentUser({ username });
  };

  const register = async (username, email, password) => {
    await authService.register(username, email, password);
  };

  const logout = () => {
    authService.logout();
    setCurrentUser(null);
  };

  return (
    <AuthContext.Provider value={{ currentUser, login, register, logout }}>
      {children}
    </AuthContext.Provider>
  );
};
