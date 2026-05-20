package com.intelliwaste.user.model.dao;

import com.intelliwaste.user.model.User;
import java.util.ArrayList;

public interface UserInterface {
    boolean registerUser(User user);

    User login(String email, String password);

    ArrayList<User> getUsersByRole(String role);

    ArrayList<User> getAllUsers();

    User findById(int id);

    boolean deleteUser(int id);

    boolean updateUserRole(int id, String role);
}
