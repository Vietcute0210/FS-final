package com.group10.furniture_store.service;

import java.util.Optional;

import org.springframework.stereotype.Service;

import com.group10.furniture_store.domain.Cart;
import com.group10.furniture_store.domain.User;
import com.group10.furniture_store.repository.CartRepository;

@Service
public class CartService {
    private final CartRepository cartRepository;

    public CartService(CartRepository cartRepository) {
        this.cartRepository = cartRepository;
    }

    public Cart getCartById(long id) {
        Optional<Cart> optionalCart = this.cartRepository.findById(id);
        return optionalCart.isPresent() ? optionalCart.get() : null;
    }

    public Cart findByUser(User user) {
        return this.cartRepository.findByUser(user);
    }

    public Cart saveCart(Cart cart) {
        return this.cartRepository.save(cart);
    }
}
