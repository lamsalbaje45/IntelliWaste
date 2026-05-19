package com.intelliwaste.wastereport.model;

import java.time.LocalDateTime;

public class WasteReport {
    private int id;
    private int user_id;
    private int category_id;
    private String location;
    private String description;
    private String report_image;
    private String priority;
    private String status;
    private LocalDateTime created_at;
    private LocalDateTime updated_at;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUser_id() { return user_id; }
    public void setUser_id(int user_id) { this.user_id = user_id; }

    public int getCategory_id() { return category_id; }
    public void setCategory_id(int category_id) { this.category_id = category_id; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getReport_image() { return report_image; }
    public void setReport_image(String report_image) { this.report_image = report_image; }

    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreated_at() { return created_at; }
    public void setCreated_at(LocalDateTime created_at) { this.created_at = created_at; }

    public LocalDateTime getUpdated_at() { return updated_at; }
    public void setUpdated_at(LocalDateTime updated_at) { this.updated_at = updated_at; }

    public WasteReport(int user_id, int category_id, String location, String description,
                       String report_image, String priority) {
        this.user_id = user_id;
        this.category_id = category_id;
        this.location = location;
        this.description = description;
        this.report_image = report_image;
        this.priority = priority;
    }
}
