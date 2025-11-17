package com.group10.furniture_store.service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.stereotype.Service;

import com.group10.furniture_store.domain.PasswordResetToken;
import com.group10.furniture_store.domain.User;
import com.group10.furniture_store.repository.PasswordResetTokenRepository;
import com.group10.furniture_store.repository.UserRepository;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TokenService {
    private final UserRepository userRepository;
    private final PasswordResetTokenRepository passwordResetTokenRepository;

    public boolean resetPassword(String email, String newPassword) {
        User user = this.userRepository.findByEmail(email);
        if (user == null) {
            return false;
        }
        user.setPassword(newPassword);
        this.userRepository.save(user);
        return true;
    }

    // Tạo token để reset password
    @Transactional
    public String createPasswordResetToken(User user) {
        // Xóa token cũ nếu có
        Optional<PasswordResetToken> existingToken = passwordResetTokenRepository.findByUser(user);
        existingToken.ifPresent(token -> passwordResetTokenRepository.delete(token));

        // Tạo token mới
        String token = UUID.randomUUID().toString();
        PasswordResetToken resetToken = new PasswordResetToken(token, user);
        passwordResetTokenRepository.save(resetToken);

        return token;
    }

    // Validate token
    public PasswordResetToken validatePasswordResetToken(String token) {

        Optional<PasswordResetToken> resetToken = passwordResetTokenRepository.findByToken(token);

        if (resetToken.isEmpty()) {
            return null;
        }

        PasswordResetToken passwordResetToken = resetToken.get();

        // Kiểm tra token đã được sử dụng chưa
        if (passwordResetToken.isUsed()) {
            return null;
        }

        // Kiểm tra token đã hết hạn chưa
        if (passwordResetToken.isExpired()) {
            return null;
        }

        return passwordResetToken;
    }

    // Đổi mật khẩu thông qua token
    @Transactional
    public boolean changePasswordWithToken(String token, String newPassword) {
        PasswordResetToken resetToken = validatePasswordResetToken(token);

        if (resetToken == null) {
            return false;
        }

        User user = resetToken.getUser();
        user.setPassword(newPassword);
        userRepository.save(user);

        // Đánh dấu token đã được sử dụng
        resetToken.setUsed(true);
        passwordResetTokenRepository.save(resetToken);

        return true;
    }

    // Xóa tất cả token hết hạn
    @Transactional
    public void deleteExpiredTokens() {
        List<PasswordResetToken> allTokens = passwordResetTokenRepository.findAll();
        for (PasswordResetToken token : allTokens) {
            if (token.isExpired()) {
                passwordResetTokenRepository.delete(token);
            }
        }
    }
}
