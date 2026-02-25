package com.app.order.model;

public class Order {
    private String orderId;
    private String userId;
    private String productId;

    public Order(String orderId, String userId, String productId) {
        this.orderId = orderId; this.userId = userId; this.productId = productId;
    }

    public String getOrderId() { return orderId; }
    public String getUserId() { return userId; }
    public String getProductId() { return productId; }
}
