package com.abc.rest.models;

import com.google.gson.annotations.SerializedName;

public class UserModel {
    @SerializedName("id")
    private int id;

    @SerializedName("full_name")
    private String fullName;

    @SerializedName("phone")
    private String phoneNumber;

    @SerializedName("address")
    private String address;

    @SerializedName("email")
    private String email;

    @SerializedName("password")
    private String password;

    @SerializedName("confirmPassword")
    private String confirmPassword;

    @SerializedName("role")
    private String role;

    @SerializedName("created_at")
    private String createdAt;

    @SerializedName("branch_id")
    private int branch_id;

    private String branch_name;

    public UserModel(int id, String fullName, String phone, String address, String email, String password, String role, int branch_id) {
        this.id = id;
        this.fullName = fullName;
        this.phoneNumber = phone;
        this.address = address;
        this.email = email;
        this.password = password;
        this.role = role;
        this.branch_id = branch_id;
    }
    public UserModel(int id, String fullName, String phone, String address, String email, String role, int branch_id) {
        this.id = id;
        this.fullName = fullName;
        this.phoneNumber = phone;
        this.address = address;
        this.email = email;
        this.role = role;
        this.branch_id = branch_id;
    }

    public UserModel(int id, String fullName, String email, String phoneNumber, String branch_name ) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.branch_name = branch_name;
    }
    public UserModel( String fullName, String email, String phoneNumber, String address, int branch_id, String password ) {
        this.fullName = fullName;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.address = address;
        this.branch_id = branch_id;
        this.password = password;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getConfirmPassword() {
        return confirmPassword;
    }

    public void setConfirmPassword(String confirmPassword) {
        this.confirmPassword = confirmPassword;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public int getBranch_id() {
        return branch_id;
    }

    public void setBranch_id(int branch_id) {
        this.branch_id = branch_id;
    }

    public String getBranchName() {
        return branch_name;
    }

    public void setBranchName(String branch_name) {
        this.branch_name = branch_name;
    }
}
