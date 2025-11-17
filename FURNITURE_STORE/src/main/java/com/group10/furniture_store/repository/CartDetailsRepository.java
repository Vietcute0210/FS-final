package com.group10.furniture_store.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.group10.furniture_store.domain.Cart;
import com.group10.furniture_store.domain.CartDetails;
import com.group10.furniture_store.domain.Product;

@Repository
public interface CartDetailsRepository extends JpaRepository<CartDetails, Long> {
    boolean existsByCartAndProduct(Cart cart, Product product);

    CartDetails findByCartAndProduct(Cart cart, Product product);
}
