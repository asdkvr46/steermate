package com.steermate.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    private PasswordUtil() {}

    public static String hashPassword(String plainText) {
        return BCrypt.hashpw(plainText, BCrypt.gensalt(10));
    }

    public static boolean checkPassword(String plainText, String hashed) {
        if (plainText == null || hashed == null) return false;
        return BCrypt.checkpw(plainText, hashed);
    }
}
