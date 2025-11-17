package com.group10.furniture_store.service;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.group10.furniture_store.domain.Role;
import com.group10.furniture_store.domain.User;
import com.group10.furniture_store.service.exception.CustomOAuth2Exception;

@Service
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final UserService userService;
    private final PasswordEncoder passwordEncoder;

    public CustomOAuth2UserService(UserService userService, PasswordEncoder passwordEncoder) {
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    @Transactional
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2User oAuth2User = super.loadUser(userRequest);
        return processOAuth2User(oAuth2User);
    }

    private OAuth2User processOAuth2User(OAuth2User oAuth2User) {
        Map<String, Object> attributes = oAuth2User.getAttributes();
        if (attributes == null) {
            throw new CustomOAuth2Exception("Không thể lấy thông tin tài khoản Google");
        }

        String email = (String) attributes.get("email");
        if (email == null || email.isBlank()) {
            throw new CustomOAuth2Exception("Google không cung cấp email. Vui lòng sử dụng tài khoản khác");
        }

        User user = userService.getUserByEmail(email);
        boolean isNewUser = false;

        if (user == null) {
            user = new User();
            user.setEmail(email);
            isNewUser = true;
        }

        Object fullName = attributes.get("name");
        if (fullName instanceof String name && !name.isBlank()) {
            user.setFullName(name);
        } else if (isNewUser && (user.getFullName() == null || user.getFullName().isBlank())) {
            user.setFullName(email);
        }

        Object picture = attributes.get("picture");
        if (picture instanceof String avatarUrl && !avatarUrl.isBlank()) {
            user.setAvatar(avatarUrl);
        }

        if (isNewUser) {
            Role userRole = userService.getRoleByName("USER");
            if (userRole == null) {
                throw new CustomOAuth2Exception(
                        "Không tìm thấy quyền USER. Vui lòng tạo quyền trước khi đăng nhập Google");
            }
            user.setRole(userRole);
            user.setPassword(passwordEncoder.encode(UUID.randomUUID().toString()));
        }

        User savedUser = userService.handleSaveUser(user);

        Map<String, Object> mappedAttributes = new HashMap<>(attributes);
        mappedAttributes.put("email", savedUser.getEmail());
        mappedAttributes.put("fullName", savedUser.getFullName());
        mappedAttributes.put("id", savedUser.getId());
        if (savedUser.getAvatar() != null) {
            mappedAttributes.put("avatar", savedUser.getAvatar());
        }

        return new DefaultOAuth2User(
                Set.of(new SimpleGrantedAuthority("ROLE_" + savedUser.getRole().getName())),
                mappedAttributes,
                "email");
    }
}
