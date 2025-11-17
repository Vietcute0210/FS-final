package com.group10.furniture_store;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

// @SpringBootApplication(exclude = org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration.class)
@SpringBootApplication
public class FurnitureStoreApplication {

	public static void main(String[] args) {
		SpringApplication.run(FurnitureStoreApplication.class, args);
	}
}
