package com.intelliwaste.assignment.model;

import java.time.LocalDateTime;

public class Assignment {
    private int id;
    private int report_id;
    private int worker_id;
    private int assigned_by;
    private String worker_notes;
    private String status;
    private LocalDateTime assigned_at;
    private LocalDateTime completed_at;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getReport_id() { return report_id; }
    public void setReport_id(int report_id) { this.report_id = report_id; }

    public int getWorker_id() { return worker_id; }
    public void setWorker_id(int worker_id) { this.worker_id = worker_id; }

    public int getAssigned_by() { return assigned_by; }
    public void setAssigned_by(int assigned_by) { this.assigned_by = assigned_by; }

    public String getWorker_notes() { return worker_notes; }
    public void setWorker_notes(String worker_notes) { this.worker_notes = worker_notes; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getAssigned_at() { return assigned_at; }
    public void setAssigned_at(LocalDateTime assigned_at) { this.assigned_at = assigned_at; }

    public LocalDateTime getCompleted_at() { return completed_at; }
    public void setCompleted_at(LocalDateTime completed_at) { this.completed_at = completed_at; }

    public Assignment(int report_id, int worker_id, int assigned_by) {
        this.report_id = report_id;
        this.worker_id = worker_id;
        this.assigned_by = assigned_by;
    }
}
