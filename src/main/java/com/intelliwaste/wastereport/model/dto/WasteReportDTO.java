package com.intelliwaste.wastereport.model.dto;

import java.time.LocalDateTime;

public class WasteReportDTO {
    private int report_id;
    private String location;
    private String description;
    private String report_image;
    private String priority;
    private String status;
    private LocalDateTime created_at;
    private int user_id;
    private String user_name;
    private String user_email;
    private int category_id;
    private String category_name;

    public int getReport_id() { return report_id; }
    public String getLocation() { return location; }
    public String getDescription() { return description; }
    public String getReport_image() { return report_image; }
    public String getPriority() { return priority; }
    public String getStatus() { return status; }
    public LocalDateTime getCreated_at() { return created_at; }
    public int getUser_id() { return user_id; }
    public String getUser_name() { return user_name; }
    public String getUser_email() { return user_email; }
    public int getCategory_id() { return category_id; }
    public String getCategory_name() { return category_name; }

    public WasteReportDTO(int report_id, String location, String description, String report_image,
                          String priority, String status, LocalDateTime created_at,
                          int user_id, String user_name, String user_email,
                          int category_id, String category_name) {
        this.report_id = report_id;
        this.location = location;
        this.description = description;
        this.report_image = report_image;
        this.priority = priority;
        this.status = status;
        this.created_at = created_at;
        this.user_id = user_id;
        this.user_name = user_name;
        this.user_email = user_email;
        this.category_id = category_id;
        this.category_name = category_name;
    }
}
