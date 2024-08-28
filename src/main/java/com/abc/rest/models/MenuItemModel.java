package com.abc.rest.models;

import java.math.BigDecimal;

public class MenuItemModel {
    private final int id;
    private final String item_name;
    private final String item_description;
    private final BigDecimal price;
    private final String item_type;

    public MenuItemModel(int id, String item_name, String item_description, BigDecimal price, String item_type) {
        this.id = id;
        this.item_name = item_name;
        this.item_description = item_description;
        this.price = price;
        this.item_type = item_type;
    }

    // Getters and setters
    public int getId() { return id; }
    public String getItem_name() { return item_name; }
    public String getItem_description() { return item_description; }
    public BigDecimal getPrice() { return price; }
    public String getItem_type() { return item_type; }
}
