package com.group10.furniture_store.service.exception;

import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.OAuth2Error;

public class CustomOAuth2Exception extends OAuth2AuthenticationException {
    public CustomOAuth2Exception(String message) {
        super(new OAuth2Error("custom_error"), message);
    }
}
