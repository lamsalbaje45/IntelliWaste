package com.intelliwaste.assignment.model.dao;

import com.intelliwaste.assignment.model.Assignment;
import com.intelliwaste.assignment.model.dto.AssignmentDTO;
import com.intelliwaste.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;

public class AssignmentDAO implements AssignmentInterface {

    private static final String JOINED_SELECT =
            "SELECT a.id AS assignment_id, a.status, a.worker_notes, a.assigned_at, a.completed_at, " +
            "       r.id AS report_id, r.location, r.description, r.priority, " +
            "       c.name AS category_name, " +
            "       u.id AS worker_id, u.name AS worker_name, u.email AS worker_email " +
            "FROM assignment a " +
            "JOIN waste_report r ON a.report_id = r.id " +
            "JOIN category    c ON r.category_id = c.id " +
            "JOIN user        u ON a.worker_id = u.id ";

    @Override
    public boolean assignReport(Assignment assignment) {
        String insertSql = "INSERT INTO assignment(report_id, worker_id, assigned_by) VALUES (?, ?, ?)";
        String updateSql = "UPDATE waste_report SET status = 'ASSIGNED', updated_at = NOW() WHERE id = ?";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ins = conn.prepareStatement(insertSql);
                 PreparedStatement upd = conn.prepareStatement(updateSql)) {
                ins.setInt(1, assignment.getReport_id());
                ins.setInt(2, assignment.getWorker_id());
                ins.setInt(3, assignment.getAssigned_by());
                ins.executeUpdate();

                upd.setInt(1, assignment.getReport_id());
                upd.executeUpdate();

                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (Exception ignored) {}
            }
        }
    }

    @Override
    public ArrayList<AssignmentDTO> viewAssignmentsByWorker(int workerId) {
        ArrayList<AssignmentDTO> list = new ArrayList<>();
        String sql = JOINED_SELECT + "WHERE a.worker_id = ? ORDER BY a.assigned_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, workerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public ArrayList<AssignmentDTO> viewAllAssignments() {
        ArrayList<AssignmentDTO> list = new ArrayList<>();
        String sql = JOINED_SELECT + "ORDER BY a.assigned_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean updateAssignmentStatus(int assignmentId, String status, String workerNotes) {
        String aSql = "UPDATE assignment SET status = ?, worker_notes = ?, " +
                      "completed_at = CASE WHEN ? = 'COMPLETED' THEN NOW() ELSE completed_at END " +
                      "WHERE id = ?";
        String rSql = "UPDATE waste_report SET status = ?, updated_at = NOW() " +
                      "WHERE id = (SELECT report_id FROM assignment WHERE id = ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement aPs = conn.prepareStatement(aSql);
                 PreparedStatement rPs = conn.prepareStatement(rSql)) {
                aPs.setString(1, status);
                aPs.setString(2, workerNotes);
                aPs.setString(3, status);
                aPs.setInt(4, assignmentId);
                aPs.executeUpdate();

                // Mirror the appropriate report status
                String reportStatus;
                switch (status) {
                    case "ACCEPTED":  reportStatus = "IN_PROGRESS"; break;
                    case "COMPLETED": reportStatus = "COMPLETED";   break;
                    case "REJECTED":  reportStatus = "PENDING";     break;
                    default:          reportStatus = "ASSIGNED";    break;
                }
                rPs.setString(1, reportStatus);
                rPs.setInt(2, assignmentId);
                rPs.executeUpdate();

                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (Exception ignored) {}
            }
        }
    }

    private AssignmentDTO map(ResultSet rs) throws java.sql.SQLException {
        Timestamp completedTs = rs.getTimestamp("completed_at");
        return new AssignmentDTO(
                rs.getInt("assignment_id"),
                rs.getInt("report_id"),
                rs.getString("location"),
                rs.getString("description"),
                rs.getString("priority"),
                rs.getString("category_name"),
                rs.getInt("worker_id"),
                rs.getString("worker_name"),
                rs.getString("worker_email"),
                rs.getString("worker_notes"),
                rs.getString("status"),
                rs.getTimestamp("assigned_at").toLocalDateTime(),
                completedTs == null ? null : completedTs.toLocalDateTime()
        );
    }
}
