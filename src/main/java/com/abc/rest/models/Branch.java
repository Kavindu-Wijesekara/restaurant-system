package com.abc.rest.models;

import java.time.LocalDateTime;

public class Branch {
    private int branchId;
    private String branchName;
    private String location;
    private String contactNumber;

    // Default constructor
    public Branch() {
    }

    // Parameterized constructor
    public Branch(int branchId, String branchName, String location, String contactNumber) {
        this.branchId = branchId;
        this.branchName = branchName;
        this.location = location;
        this.contactNumber = contactNumber;
    }

    // Getters and Setters
    public int getBranchId() {
        return branchId;
    }

    public void setBranchId(int branchId) {
        this.branchId = branchId;
    }

    public String getBranchName() {
        return branchName;
    }

    public void setBranchName(String branchName) {
        this.branchName = branchName;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getContactNumber() {
        return contactNumber;
    }

    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }

    @Override
    public String toString() {
        return "Branch{" +
                "branchId=" + branchId +
                ", branchName='" + branchName + '\'' +
                ", location='" + location + '\'' +
                ", contactNumber='" + contactNumber + '\'' +
                '}';
    }
}
