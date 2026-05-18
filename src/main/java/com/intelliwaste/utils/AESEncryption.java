package com.intelliwaste.utils;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

public class AESEncryption {

    private static final String ALGORITHM = "AES";
    private static final String KEY = "qwertyuiasdfghjk";

    public static String encrypt(String plainText) {
        String encryptedText = plainText;
        try {
            SecretKey keySpec = new SecretKeySpec(KEY.getBytes(StandardCharsets.UTF_8), ALGORITHM);
            Cipher cipher = Cipher.getInstance(ALGORITHM);
            cipher.init(Cipher.ENCRYPT_MODE, keySpec);
            byte[] cipherText = cipher.doFinal(Base64.getEncoder().encode(plainText.getBytes()));
            encryptedText = Base64.getEncoder().encodeToString(cipherText);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return encryptedText;
    }

    public static String decrypt(String cipherText) {
        String decryptedText = cipherText;
        try {
            SecretKey keySpec = new SecretKeySpec(KEY.getBytes(StandardCharsets.UTF_8), ALGORITHM);
            Cipher cipher = Cipher.getInstance(ALGORITHM);
            cipher.init(Cipher.DECRYPT_MODE, keySpec);
            byte[] cipherTextBytes = cipher.doFinal(Base64.getDecoder().decode(cipherText));
            decryptedText = new String(cipherTextBytes, StandardCharsets.UTF_8);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return decryptedText;
    }
}
