package com.gestionframeword.madific.model;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
 
public class PasswordModifier
{
    public static String SecurePassword(String pass)
    {
        return calcSHA256(pass);
    }   
    
    private static String calcSHA256(String text)
    {
        try 
        {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] encodedHash = digest.digest(text.getBytes(StandardCharsets.UTF_8));
            return bytesToHex(encodedHash);
        } catch(NoSuchAlgorithmException e)
        {
            throw new RuntimeException(e);
        }
    }
    
    private static String bytesToHex(byte[] hash)
    {
        StringBuilder hexString = new StringBuilder(2 * hash.length);
        for (byte b: hash)
        {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1)
            {
                hexString.append('0');
            }
            hexString.append(hex);
        }
        
        return hexString.toString();
    }
}
