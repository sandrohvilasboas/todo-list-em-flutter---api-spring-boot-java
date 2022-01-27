package com.todo.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.todo.model.Todo;
import com.todo.repository.TodoRepository;

@RestController
@RequestMapping("/api")
public class TodoController {
	
	@Autowired
	private TodoRepository todoRepository;
	
	@GetMapping("/todos")
	public List<Todo> getAllTodos() {
		return todoRepository.findAll();
	}
	
	@GetMapping("/todos/{id}")
	public Optional<Todo> getTodo(@PathVariable(value="id") long id) {
		return todoRepository.findById(id);
	}
	
	@PostMapping("/todos")
	@ResponseStatus(HttpStatus.CREATED)
	public Todo insertTodo(@RequestBody Todo todo) {
		return todoRepository.save(todo);
	}
	
	@PutMapping("/todos")
	public Todo updateTodo(@RequestBody Todo todo) {
		return todoRepository.save(todo);	
	}
	
	@DeleteMapping("/todos")
	public void deleteTodo(@RequestBody Todo todo) {
		todoRepository.delete(todo);
	}
	
	
}
