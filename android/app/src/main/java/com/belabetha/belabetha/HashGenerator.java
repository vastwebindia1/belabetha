package com.belabetha.belabetha;

import java.security.MessageDigest;
import java.security.Security;

public class HashGenerator {
    public byte[] generateSha256Hash(byte[] message) {
        Security.addProvider(new org.bouncycastle.jce.provider.BouncyCastleProvider());
        String algorithm = "SHA-256";
        String SECURITY_PROVIDER = "BC";

        byte[] hash = null;

        MessageDigest digest;
        try {
            digest = MessageDigest.getInstance(algorithm);
            digest.reset();
            hash = digest.digest(message);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return hash;
    }


}
