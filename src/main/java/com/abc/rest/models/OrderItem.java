package com.abc.rest.models;

import java.math.BigDecimal;

public class OrderItem {
    private int id;
    private int orderId;
    private String name;
    private int menuItemId;
    private int quantity;
    private BigDecimal price;
    private MenuItemModel menuItem; // Reference to the menu item

    // Constructors
    public OrderItem() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getMenuItemId() { return menuItemId; }
    public void setMenuItemId(int menuItemId) { this.menuItemId = menuItemId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public MenuItemModel getMenuItem() { return menuItem; }
    public void setMenuItem(MenuItemModel menuItem) { this.menuItem = menuItem; }

    public BigDecimal getTotalPrice() {
        return price.multiply(new BigDecimal(quantity));
    }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
}
