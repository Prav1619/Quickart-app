package com.app.product.service;

import com.app.product.model.Product;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductService {

    public List<Product> getProducts() {
        return List.of(
                new Product("1", "Laptop", 60000),
                new Product("2", "Keyboard", 2500),
                new Product("3", "Mouse", 800)
        );
    }
}
