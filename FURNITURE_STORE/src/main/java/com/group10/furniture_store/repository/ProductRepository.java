package com.group10.furniture_store.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.group10.furniture_store.domain.Product;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    Optional<Product> findById(Long id);

    Page<Product> findAll(Specification<Product> specs, Pageable pageable);

    Page<Product> findAll(Pageable pageable);

    List<Product> findByNameContainingIgnoreCaseOrderByIdDesc(String name);
}
