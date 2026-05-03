package com.waste.smartwastemanagement.model;

public class Waste {

    private int id;
    private String location;
    private String type;
    private String description;
    private String status;
    private int userId;

    public Waste() {

    }

    //Constructor without ID (Reporting Waste)
    public Waste(String location, String type, String description, String status, int userId) {
        this.location = location;
        this.type = type;
        this.description = description;
        this.status = status;
        this.userId = userId;
    }

    //Constructor with ID (Fetching from Database)
    public Waste(int id, String location, String type, String description, String status, int userId) {
        this.id = id;
        this.location = location;
        this.type = type;
        this.description = description;
        this.status = status;
        this.userId = userId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
}
