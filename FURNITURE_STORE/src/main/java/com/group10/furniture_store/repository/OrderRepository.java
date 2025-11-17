package com.group10.furniture_store.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.group10.furniture_store.domain.Order;
import com.group10.furniture_store.domain.User;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {
    long count();

    @Query("SELECT DISTINCT o FROM Order o " +
            "LEFT JOIN FETCH o.OrderDetails od " +
            "LEFT JOIN FETCH od.product " +
            "WHERE o.user = :user " +
            "ORDER BY o.id DESC")
    List<Order> findByUserWithDetails(@Param("user") User user);

    List<Order> findByUser(User user);

    Page<Order> findAll(Pageable pageable);

    Order findByPaymentRef(String paymentRef);
}
