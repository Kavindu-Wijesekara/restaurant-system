package com.abc.rest.models;

import com.google.gson.JsonObject;
import java.util.Map;

public class CommonMessageModel {
    private final String message;
    private final boolean success;
    private Map<String, Object> data;

    public CommonMessageModel(String message, boolean success) {
        this.message = message;
        this.success = success;
    }

    public CommonMessageModel(String message, boolean success, Map<String, Object> data) {
        this.message = message;
        this.success = success;
        this.data = data;
    }

    public String getMessage() {
        return message;
    }

    public boolean isSuccess() {
        return success;
    }

    public Map<String, Object> getData() {
        return data;
    }

    public void setData(Map<String, Object> data) {
        this.data = data;
    }

    public JsonObject toJsonObject() {
        JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty("success", this.success);
        jsonObject.addProperty("message", this.message);

        if (this.data != null && !this.data.isEmpty()) {
            for (Map.Entry<String, Object> entry : this.data.entrySet()) {
                if (entry.getValue() instanceof String) {
                    jsonObject.addProperty(entry.getKey(), (String) entry.getValue());
                } else if (entry.getValue() instanceof Number) {
                    jsonObject.addProperty(entry.getKey(), (Number) entry.getValue());
                } else if (entry.getValue() instanceof Boolean) {
                    jsonObject.addProperty(entry.getKey(), (Boolean) entry.getValue());
                }
                // Add more type checks if needed
            }
        }

        return jsonObject;
    }
}