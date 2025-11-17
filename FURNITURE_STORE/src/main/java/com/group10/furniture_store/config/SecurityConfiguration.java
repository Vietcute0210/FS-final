package com.group10.furniture_store.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.session.security.web.authentication.SpringSessionRememberMeServices;

import jakarta.servlet.DispatcherType;

import com.group10.furniture_store.service.CustomUserDetailsService;
import com.group10.furniture_store.service.CustomOAuth2UserService;
import com.group10.furniture_store.service.UserService;

@Configuration
@EnableMethodSecurity(securedEnabled = true)
public class SecurityConfiguration {
        @Bean
        public PasswordEncoder passwordEncoder() {
                return new BCryptPasswordEncoder();
        }

        @Bean
        public UserDetailsService userDetailsService(UserService userService) {
                return new CustomUserDetailsService(userService);
        }

        @Bean
        public DaoAuthenticationProvider authProvider(
                        PasswordEncoder passwordEncoder,
                        UserDetailsService userDetailsService) {

                DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
                authProvider.setUserDetailsService(userDetailsService);
                authProvider.setPasswordEncoder(passwordEncoder);
                authProvider.setHideUserNotFoundExceptions(false);

                return authProvider;
        }

        @Bean
        public AuthenticationSuccessHandler customSuccessHandler(UserService userService) {
                return new CustomSuccessHandler(userService);
        }

        @Bean
        public SpringSessionRememberMeServices rememberMeServices() {
                SpringSessionRememberMeServices rememberMeServices = new SpringSessionRememberMeServices();
                // optionally customize
                rememberMeServices.setAlwaysRemember(true);
                return rememberMeServices;
        }

        @Bean
        public SecurityFilterChain filterChain(
                        HttpSecurity http,
                        AuthenticationSuccessHandler customSuccessHandler,
                        CustomOAuth2UserService customOAuth2UserService,
                        CustomOAuth2AuthenticationFailureHandler oauth2AuthenticationFailureHandler) throws Exception {

                http
                                .authorizeHttpRequests(authorize -> authorize
                                                .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.INCLUDE)
                                                .permitAll()
                                                .requestMatchers(
                                                                "/", "/login", "/products/**", "/register",
                                                                "/reset-password", "/forgot-password",
                                                                "/client/**", "/css/**", "/js/**", "/images/**",
                                                                "/add-product-to-cart/**", "/product/**", "/api/**",
                                                                "/oauth2/**")
                                                .permitAll()
                                                .requestMatchers(
                                                                "/order/checkout", "/order/create",
                                                                "/order/create-vnpay", "/order/vnpay-callback",
                                                                "/order/failed", "/thankyou")
                                                .permitAll()
                                                .requestMatchers("/admin/**").hasRole("ADMIN")
                                                .anyRequest().authenticated())

                                .sessionManagement(session -> session
                                                .sessionCreationPolicy(SessionCreationPolicy.ALWAYS)
                                                .invalidSessionUrl("/logout?expired")
                                                .maximumSessions(1)
                                                .maxSessionsPreventsLogin(false))

                                .logout(logout -> logout
                                                .deleteCookies("JSESSIONID")
                                                .invalidateHttpSession(true))

                                .rememberMe(r -> r.rememberMeServices(rememberMeServices()))

                                .formLogin(form -> form
                                                .loginPage("/login")
                                                .failureUrl("/login?error")
                                                .successHandler(customSuccessHandler)
                                                .permitAll())

                                .oauth2Login(oauth2 -> oauth2
                                                .loginPage("/login")
                                                .userInfoEndpoint(userInfo -> userInfo
                                                                .userService(customOAuth2UserService))
                                                .successHandler(customSuccessHandler)
                                                .failureHandler(oauth2AuthenticationFailureHandler))

                                .exceptionHandling(ex -> ex.accessDeniedPage("/access-deny"));

                return http.build();
        }
}