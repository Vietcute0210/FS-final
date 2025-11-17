package com.group10.furniture_store.utils;

import java.util.*;

public class AppUtil {
    public static final String getRandomOTP() {
        Random random = new Random();
        int num = random.nextInt(999999);
        return String.format("%06d", num);
    }
}
