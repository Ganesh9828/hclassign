package com.example.taskmgr.services;

import com.example.taskmgr.dto.TaskDto;
import com.example.taskmgr.exception.ResourceNotFoundException;
import com.example.taskmgr.model.Task;
import com.example.taskmgr.model.User;
import com.example.taskmgr.repository.TaskRepository;
import com.example.taskmgr.repository.UserRepository;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class TaskService {

    private final TaskRepository taskRepository;
    private final UserRepository userRepository;

    public TaskService(TaskRepository taskRepository, UserRepository userRepository) {
        this.taskRepository = taskRepository;
        this.userRepository = userRepository;
    }

    private User getCurrentUser() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
    }

    public TaskDto createTask(TaskDto taskDto) {
        User user = getCurrentUser();

        Task task = new Task();
        task.setTitle(taskDto.getTitle());
        task.setDescription(taskDto.getDescription());
        task.setCompleted(false);
        task.setUser(user);

        Task savedTask = taskRepository.save(task);
        return mapToDto(savedTask);
    }

    public List<TaskDto> getAllTasks() {
        User user = getCurrentUser();
        List<Task> tasks = taskRepository.findByUserId(user.getId());
        return tasks.stream().map(this::mapToDto).collect(Collectors.toList());
    }

    public TaskDto getTaskById(Long taskId) {
        User user = getCurrentUser();
        Task task = taskRepository.findById(taskId)
                .orElseThrow(() -> new ResourceNotFoundException("Task not found with id: " + taskId));

        if (!task.getUser().getId().equals(user.getId())) {
            throw new RuntimeException("Unauthorized to access this task");
        }

        return mapToDto(task);
    }

    public TaskDto updateTask(TaskDto taskDto, Long taskId) {
        User user = getCurrentUser();
        Task task = taskRepository.findById(taskId)
                .orElseThrow(() -> new ResourceNotFoundException("Task not found with id: " + taskId));

        if (!task.getUser().getId().equals(user.getId())) {
            throw new RuntimeException("Unauthorized to update this task");
        }

        task.setTitle(taskDto.getTitle());
        task.setDescription(taskDto.getDescription());
        task.setCompleted(taskDto.isCompleted());

        Task updatedTask = taskRepository.save(task);
        return mapToDto(updatedTask);
    }

    public void deleteTask(Long taskId) {
        User user = getCurrentUser();
        Task task = taskRepository.findById(taskId)
                .orElseThrow(() -> new ResourceNotFoundException("Task not found with id: " + taskId));

        if (!task.getUser().getId().equals(user.getId())) {
            throw new RuntimeException("Unauthorized to delete this task");
        }

        taskRepository.delete(task);
    }

    private TaskDto mapToDto(Task task) {
        return new TaskDto(
                task.getId(),
                task.getTitle(),
                task.getDescription(),
                task.isCompleted()
        );
    }
}
