package com.app.order.service;

import com.app.order.model.Order;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class OrderService {
    public List<Order> getOrders() {
        return List.of(
                new Order("6001", "101", "1"),
                new Order("6002", "102", "2")
        );
    }
}
