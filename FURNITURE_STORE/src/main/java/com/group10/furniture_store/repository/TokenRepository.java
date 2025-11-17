package com.group10.furniture_store.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.group10.furniture_store.domain.Token;

@Repository
public interface TokenRepository extends JpaRepository<Token, Long> {
    String findEmailByToken(String token);
}
