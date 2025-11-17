package com.group10.furniture_store.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.group10.furniture_store.domain.User;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    User findUserById(long id);

    User save(User x);

    boolean existsByEmail(String email);

    User findByEmail(String email);

    Page<User> findAll(Pageable pageable);
}
