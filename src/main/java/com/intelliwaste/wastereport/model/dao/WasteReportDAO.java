package com.intelliwaste.wastereport.model.dao;

import com.intelliwaste.utils.DBConnection;
import com.intelliwaste.wastereport.model.WasteReport;
import com.intelliwaste.wastereport.model.dto.WasteReportDTO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class WasteReportDAO implements WasteReportInterface {

    private static final String JOINED_SELECT =
            "SELECT r.id, r.location, r.description, r.report_image, r.priority, r.status, r.created_at, " +
            "       r.user_id, u.name AS user_name, u.email AS user_email, " +
            "       r.category_id, c.name AS category_name " +
            "FROM waste_report r " +
            "JOIN user u     ON r.user_id     = u.id " +
            "JOIN category c ON r.category_id = c.id ";

    @Override
    public boolean insertReport(WasteReport report) {
        if (report.getLocation() == null || report.getLocation().trim().isEmpty()) return false;
        if (report.getDescription() == null || report.getDescription().trim().isEmpty()) return false;

        String sql = "INSERT INTO waste_report(user_id, category_id, location, description, report_image, priority, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, 'PENDING')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, report.getUser_id());
            ps.setInt(2, report.getCategory_id());
            ps.setString(3, report.getLocation());
            ps.setString(4, report.getDescription());
            ps.setString(5, report.getReport_image());
            ps.setString(6, report.getPriority());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public ArrayList<WasteReportDTO> viewAllReports() {
        ArrayList<WasteReportDTO> reports = new ArrayList<>();
        String sql = JOINED_SELECT + "ORDER BY r.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) reports.add(map(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return reports;
    }

    @Override
    public ArrayList<WasteReportDTO> viewReportsByUser(int userId) {
        ArrayList<WasteReportDTO> reports = new ArrayList<>();
        String sql = JOINED_SELECT + "WHERE r.user_id = ? ORDER BY r.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) reports.add(map(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return reports;
    }

    @Override
    public ArrayList<WasteReportDTO> viewReportsByStatus(String status) {
        ArrayList<WasteReportDTO> reports = new ArrayList<>();
        String sql = JOINED_SELECT + "WHERE r.status = ? ORDER BY r.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) reports.add(map(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return reports;
    }

    @Override
    public WasteReportDTO viewReportById(int reportId) {
        String sql = JOINED_SELECT + "WHERE r.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reportId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean updateStatus(int reportId, String status) {
        String sql = "UPDATE waste_report SET status = ?, updated_at = NOW() WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, reportId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteReport(int reportId, int userId) {
        String sql = "DELETE FROM waste_report WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reportId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /** Returns a map of status -> count for dashboards. */
    public Map<String, Integer> countByStatus() {
        Map<String, Integer> counts = new HashMap<>();
        counts.put("PENDING", 0);
        counts.put("ASSIGNED", 0);
        counts.put("IN_PROGRESS", 0);
        counts.put("COMPLETED", 0);
        counts.put("REJECTED", 0);

        String sql = "SELECT status, COUNT(*) AS c FROM waste_report GROUP BY status";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                counts.put(rs.getString("status"), rs.getInt("c"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return counts;
    }

    public Map<String, Integer> countByStatusForUser(int userId) {
        Map<String, Integer> counts = new HashMap<>();
        counts.put("PENDING", 0);
        counts.put("ASSIGNED", 0);
        counts.put("IN_PROGRESS", 0);
        counts.put("COMPLETED", 0);

        String sql = "SELECT status, COUNT(*) AS c FROM waste_report WHERE user_id = ? GROUP BY status";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                counts.put(rs.getString("status"), rs.getInt("c"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return counts;
    }

    private WasteReportDTO map(ResultSet rs) throws java.sql.SQLException {
        return new WasteReportDTO(
                rs.getInt("id"),
                rs.getString("location"),
                rs.getString("description"),
                rs.getString("report_image"),
                rs.getString("priority"),
                rs.getString("status"),
                rs.getTimestamp("created_at").toLocalDateTime(),
                rs.getInt("user_id"),
                rs.getString("user_name"),
                rs.getString("user_email"),
                rs.getInt("category_id"),
                rs.getString("category_name")
        );
    }
}
