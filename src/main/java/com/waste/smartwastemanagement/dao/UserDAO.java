package com.waste.smartwastemanagement.dao;

import com.waste.smartwastemanagement.model.User;
import com.waste.smartwastemanagement.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

    //Register User
    public boolean registerUser(User user) {
        boolean success = false;

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getRole());

            int rows = ps.executeUpdate();

            if (rows > 0) {
                success = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return success;
    }

    //Login User
    public User loginUser(String email, String password) {
        User user = null;

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM users WHERE email = ? AND password = ?";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = new User();

                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }
}
