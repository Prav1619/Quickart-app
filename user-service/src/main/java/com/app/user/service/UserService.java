package com.app.user.service;

import com.app.user.model.User;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {
    public List<User> getUsers() {
        return List.of(
                new User("101", "Pravallikha"),
                new User("102", "sai")
        );
    }
}
