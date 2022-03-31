package com.jstpay.jstpay;

import android.content.Context;

import org.bouncycastle.crypto.InvalidCipherTextException;
import org.bouncycastle.crypto.engines.AESEngine;
import org.bouncycastle.crypto.paddings.PKCS7Padding;
import org.bouncycastle.crypto.paddings.PaddedBufferedBlockCipher;
import org.bouncycastle.crypto.params.KeyParameter;
import org.bouncycastle.jce.provider.BouncyCastleProvider;

import java.io.IOException;
import java.io.InputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.SecureRandom;
import java.security.Security;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.security.interfaces.RSAPublicKey;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;

public class EncrptionMethodV2 {

    private static final String JCE_PROVIDER = "BC";
    private static final int SYMMETRIC_KEY_SIZE = 128;

    static {
        Security.addProvider(new BouncyCastleProvider());
    }

    public static byte[] generateSessionKey() throws NoSuchAlgorithmException, NoSuchProviderException {
        KeyGenerator kgen = KeyGenerator.getInstance("AES");
        kgen.init(SYMMETRIC_KEY_SIZE);
        return kgen.generateKey().getEncoded();
    }

    public static String encryptUsingSessionKey(byte[] skey, byte[] data) throws InvalidCipherTextException {
        PaddedBufferedBlockCipher cipher = new PaddedBufferedBlockCipher(new AESEngine(), new PKCS7Padding());

        cipher.init(true, new KeyParameter(skey));

        int outputSize = cipher.getOutputSize(data.length);

        byte[] tempOP = new byte[outputSize];
        int processLen = cipher.processBytes(data, 0, data.length, tempOP, 0);
        int outputLen = cipher.doFinal(tempOP, processLen);

        byte[] result = new byte[processLen + outputLen];
        System.arraycopy(tempOP, 0, result, 0, result.length);
        //return Base64.encode(result).replace("\r\n", "");
        //return Base64.encode(result).replace("\r\n", "");
        return null;
    }

    public static String encryptUsingPublicKey(byte[] message, Context context) {

        byte[] ciphertextBytes = null;

        try {
            SecureRandom secureRandom = new SecureRandom();
            Security.addProvider(new BouncyCastleProvider());

            Cipher cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding");

            InputStream inStream = context.getAssets().open("fingpay_public_production.cer");
            CertificateFactory cf = CertificateFactory.getInstance("X.509");
            X509Certificate cert = (X509Certificate) cf.generateCertificate(inStream);
            inStream.close();

            RSAPublicKey pubkey = (RSAPublicKey) cert.getPublicKey();

            cipher.init(Cipher.ENCRYPT_MODE, pubkey, secureRandom);

            ciphertextBytes = cipher.doFinal(message);

            //return Base64.encode(ciphertextBytes).replace("\r\n", "");
            //return Base64.encodeBase64String(ciphertextBytes).replace("\r\n","");
            return null;
        } catch (IOException e) {
            System.out.println("IOException:" + e);
            e.printStackTrace();
        } catch (CertificateException e) {
            System.out.println("CertificateException:" + e);
            e.printStackTrace();
        } catch (NoSuchAlgorithmException e) {
            System.out.println("NoSuchAlgorithmException:" + e);
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("Exception:" + e);
            e.printStackTrace();
        }
        return null;
    }





    public static byte[] decryptUsingSessionKey(byte[] skey, byte[] data) throws InvalidCipherTextException {
        PaddedBufferedBlockCipher cipher = new PaddedBufferedBlockCipher(new AESEngine(), new PKCS7Padding());

        cipher.init(false, new KeyParameter(skey));

        int outputSize = cipher.getOutputSize(data.length);

        byte[] tempOP = new byte[outputSize];
        int processLen = cipher.processBytes(data, 0, data.length, tempOP, 0);
        int outputLen = cipher.doFinal(tempOP, processLen);

        byte[] result = new byte[processLen + outputLen];
        System.arraycopy(tempOP, 0, result, 0, result.length);
        return result;
    }

    public static  byte[] generateSha256Hash(byte[] message) {
        Security.addProvider(new BouncyCastleProvider());
        String algorithm = "SHA-256";
        String SECURITY_PROVIDER = "BC";

        byte[] hash = null;
        MessageDigest digest;
        try {
            digest = MessageDigest.getInstance(algorithm, SECURITY_PROVIDER);
            digest.reset();
            hash = digest.digest(message);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return hash;
    }
}
