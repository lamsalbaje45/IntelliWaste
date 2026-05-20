package com.intelliwaste.category.model.dao;

import com.intelliwaste.category.model.Category;
import com.intelliwaste.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class CategoryDAO implements CategoryInterface {

    @Override
    public ArrayList<Category> viewAllCategories() {
        ArrayList<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM category ORDER BY name";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Category(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
