package com.intelliwaste.assignment.model.dto;

import java.time.LocalDateTime;

public class AssignmentDTO {
    private int assignment_id;
    private int report_id;
    private String report_location;
    private String report_description;
    private String report_priority;
    private String report_category;
    private int worker_id;
    private String worker_name;
    private String worker_email;
    private String worker_notes;
    private String status;
    private LocalDateTime assigned_at;
    private LocalDateTime completed_at;

    public int getAssignment_id() { return assignment_id; }
    public int getReport_id() { return report_id; }
    public String getReport_location() { return report_location; }
    public String getReport_description() { return report_description; }
    public String getReport_priority() { return report_priority; }
    public String getReport_category() { return report_category; }
    public int getWorker_id() { return worker_id; }
    public String getWorker_name() { return worker_name; }
    public String getWorker_email() { return worker_email; }
    public String getWorker_notes() { return worker_notes; }
    public String getStatus() { return status; }
    public LocalDateTime getAssigned_at() { return assigned_at; }
    public LocalDateTime getCompleted_at() { return completed_at; }

    public AssignmentDTO(int assignment_id, int report_id, String report_location,
                         String report_description, String report_priority, String report_category,
                         int worker_id, String worker_name, String worker_email,
                         String worker_notes, String status,
                         LocalDateTime assigned_at, LocalDateTime completed_at) {
        this.assignment_id = assignment_id;
        this.report_id = report_id;
        this.report_location = report_location;
        this.report_description = report_description;
        this.report_priority = report_priority;
        this.report_category = report_category;
        this.worker_id = worker_id;
        this.worker_name = worker_name;
        this.worker_email = worker_email;
        this.worker_notes = worker_notes;
        this.status = status;
        this.assigned_at = assigned_at;
        this.completed_at = completed_at;
    }
}
