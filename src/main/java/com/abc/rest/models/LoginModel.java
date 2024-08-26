package com.abc.rest.models;

import com.google.gson.annotations.SerializedName;


public class LoginModel {

    @SerializedName("email")
    String email;

    @SerializedName("password")
    String password;


    public void setEmail(String email) {
        this.email = email;
    }
    public String getEmail() {
        return email;
    }

    public void setPassword(String password) {
        this.password = password;
    }
    public String getPassword() {
        return password;
    }

}
