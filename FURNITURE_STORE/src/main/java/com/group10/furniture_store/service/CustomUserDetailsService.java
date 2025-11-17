package com.group10.furniture_store.service;

import org.springframework.stereotype.Service;
import java.util.Collections;

import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UserService userService;

    public CustomUserDetailsService(UserService userService) {
        this.userService = userService;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        com.group10.furniture_store.domain.User user = this.userService.getUserByEmail(username);
        // import tránh nhầm lẫn với User của Spring Security phía sau
        if (user == null) {
            throw new UsernameNotFoundException("User not found with email: " + username);
        }
        return new User(user.getEmail(), user.getPassword(),
                Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + user.getRole().getName())));
        // đây là User() của Spring Security
    }

}