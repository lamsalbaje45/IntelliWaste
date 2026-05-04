package com.waste.smartwastemanagement.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;

import com.waste.smartwastemanagement.model.Waste;
import com.waste.smartwastemanagement.utils.DBConnection;

public class WasteDAO {

    // 🔹 Add Waste Report
    public boolean addWasteReport(Waste waste) {

        boolean status = false;

        try {
            Connection conn = DBConnection.getConnection();

            String query = "INSERT INTO waste_reports (user_id, location, type, description) VALUES (?, ?, ?, ?)";

            PreparedStatement ps = conn.prepareStatement(query);

            ps.setInt(1, waste.getUserId());
            ps.setString(2, waste.getLocation());
            ps.setString(3, waste.getType());
            ps.setString(4, waste.getDescription());

            int rows = ps.executeUpdate();

            if (rows > 0) {
                status = true;
            }

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }
}