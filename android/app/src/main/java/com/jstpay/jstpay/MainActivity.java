package com.jstpay.jstpay;

import in.credopay.payment.sdk.Utils;
import io.flutter.embedding.android.FlutterActivity;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.core.content.ContextCompat;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodChannel;

import android.app.Activity;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.os.PowerManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
import android.os.SystemClock;
import android.text.TextUtils;
import android.util.Base64;
import android.util.Log;
import android.view.View;
import android.webkit.WebView;
import android.widget.Toast;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.zxing.integration.android.IntentIntegrator;
import com.google.zxing.integration.android.IntentResult;
import com.payu.base.models.CardType;
import com.payu.base.models.ErrorResponse;
import com.payu.base.models.PayUOfferDetails;
import com.payu.base.models.PayUPaymentParams;
import com.payu.base.models.PayUSIParams;
import com.payu.base.models.PaymentType;
import com.payu.checkoutpro.PayUCheckoutPro;
import com.payu.checkoutpro.models.PayUCheckoutProConfig;
import com.payu.checkoutpro.utils.PayUCheckoutProConstants;
import com.payu.ui.model.listeners.PayUCheckoutProListener;
import com.payu.ui.model.listeners.PayUHashGenerationListener;

import org.bouncycastle.crypto.InvalidCipherTextException;
import org.jetbrains.annotations.NotNull;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.XML;
import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;
import org.xmlpull.v1.XmlPullParserFactory;

import java.io.IOException;
import java.io.StringReader;
import java.security.Key;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Random;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import in.credopay.payment.sdk.CredopayPaymentConstants;
import in.credopay.payment.sdk.LoginActivity;
import in.credopay.payment.sdk.PaymentActivity;

public class MainActivity extends FlutterFragmentActivity {

    private static final String CHANNEL = "com.aasha/credoPay";
    private int paymentStatusCode;
    String uid,name,gender,yearOfBirth,careOf,villageTehsil,postOffice,district,state,postCode,number;
    String amount,password,loginId,uniqueid;
    boolean isPurchase = false;
    boolean ismicrostm = false;
    Boolean isNewLogin = false;
    boolean chhkbalance = false;
    Boolean ChangePassword;

    String merchantTransactionId, PidDatatype, Piddata, ci, dc, dpID, errCode, errInfo, fCount, fType, hmac, iCount, mc, mi,iType;
    String nmPoints, pCount, pType, qScore, rdsID, rdsVer, sessionKey, adhaarNumber, indicatorforUID, nationalBankIdentificationNumber;
    String languageCode, merchantTranId, transactionAmount, mobileNumber, requestRemarks, timestamp, transactionType;
    String merchantUserName, merchantPin, subMerchantId,otpnum,latitude,longitude;
    byte[] skey;
    String date1, date2;
    List list = null;
    private boolean isRDReady = false;
    private List<String> rdList = null;
    private int foundPackCount = 0;
    private String foundPackName = "";
    private int listCount = 0;
    String selectedPackage = "";
    String Messge,MyDevice,Devicesrno,name1,mobileNo;
    String aadhanum,consuname,bnkname,bnkidd,lat,longg,address,imeii,otp;


    String surl;
    String furl;
    String merchkey,merchsalt;
    String payamount,paymobile,payname,payemail;



    private long mLastClickTime;
    private final String testMerchantSecretKey = "<Please_add_your_merchant_secret_key>";
    View view;
    String paytype;

    private static MethodChannel.Result result;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    MainActivity.result = result;
                    if (call.method.equals("payAmount")) {

                        ChangePassword = Boolean.parseBoolean(call.argument("isChangePassword").toString());
                        loginId = call.argument("loginid").toString();
                        uniqueid = call.argument("uniqid").toString();
                        password = call.argument("password").toString();
                        amount = call.argument("amount").toString();
                        isNewLogin = Boolean.parseBoolean(call.argument("newlogin").toString());
                        ismicrostm = Boolean.parseBoolean(call.argument("ismicroatm").toString());
                        isPurchase = Boolean.parseBoolean(call.argument("ispurchase").toString());
                        chhkbalance = Boolean.parseBoolean(call.argument("chkblnce").toString());

                        if (chhkbalance == true){

                            checkbalance();

                        }else{

                            payAmount(ChangePassword);

                        }

                    }else if (call.method.equals("aadhar")){

                        aadharscan();

                    }else if (call.method.equals("deviceconnect")){

                        selectedPackage = "";
                        ScanRDServices();

                    }else if (call.method.equals("scandevice")){

                        aadhanum = call.argument("aaadharnum").toString();
                        consuname = call.argument("mobilnum").toString();
                        mobileNo = call.argument("namee").toString();
                        bnkname = call.argument("banknam").toString();
                        bnkidd = call.argument("bankid").toString();

                        lat = call.argument("lat").toString();
                        longg = call.argument("long").toString();
                        address = call.argument("address").toString();
                        imeii = call.argument("imei").toString();
                        otp = call.argument("otp").toString();
                        date1 = call.argument("date").toString();

                        scaninger();

                    }else if (call.method.equals("ekycscandevice")){

                        aadhanum = call.argument("aaadharnum").toString();
                        consuname = call.argument("mobilnum").toString();
                        mobileNo = call.argument("namee").toString();
                        bnkname = call.argument("banknam").toString();
                        bnkidd = call.argument("bankid").toString();

                        lat = call.argument("lat").toString();
                        longg = call.argument("long").toString();
                        address = call.argument("address").toString();
                        imeii = call.argument("imei").toString();
                        otp = call.argument("otp").toString();
                        date1 = call.argument("date").toString();

                        ekycscaninger();

                    }else if (call.method.equals("paygatway")){

                        paytype = call.argument("type").toString();

                        merchkey = call.argument("pykey").toString();
                        merchsalt = call.argument("pysalt").toString();
                        surl = call.argument("pysurl").toString();
                        furl = call.argument("pyfurl").toString();
                        payamount = call.argument("pyamount").toString();

                        payname = call.argument("pyname").toString();
                        paymobile = call.argument("pymobile").toString();
                        payemail = call.argument("pyemail").toString();

                        startPayment(view);
                        //pay(upiamnt,upiid);

                    }

                });

    }

    public void payAmount(boolean isChangePassword) {
        if (!amount.isEmpty() && !amount.equals("0") && amount != "") {
            Intent intent = new Intent(MainActivity.this, PaymentActivity.class);
            intent.putExtra("TRANSACTION_TYPE", isPurchase ? CredopayPaymentConstants.PURCHASE :  ismicrostm ? CredopayPaymentConstants.MICROATM : CredopayPaymentConstants.CASH_AT_POS);
            intent.putExtra("DEBUG_MODE", true);
            intent.putExtra("CUSTOM_FIELD1", uniqueid);
            intent.putExtra("PRODUCTION", true);
            intent.putExtra("AMOUNT", Integer.valueOf(amount + "00"));
            intent.putExtra("LOGIN_ID", loginId);
            if (isChangePassword) {
                intent.putExtra("LOGIN_PASSWORD", "VwiCredo@123");
            } else {
                intent.putExtra("LOGIN_PASSWORD", isNewLogin ? password : "VwiCredo@123");
            }
            intent.putExtra("LOGO", Utils.getVariableImage(ContextCompat.getDrawable(getApplicationContext(), R.drawable.aashalogo)));
            startActivityForResult(intent, 1);
        } else {
            Toast.makeText(this, "Please enter the amount", Toast.LENGTH_SHORT).show();
        }
    }

    public void checkbalance(){

        Intent intent = new Intent(MainActivity.this, PaymentActivity.class);
        intent.putExtra("TRANSACTION_TYPE",CredopayPaymentConstants.BALANCE_ENQUIRY);
        intent.putExtra("DEBUG_MODE", true);
        intent.putExtra("PRODUCTION", true);
        intent.putExtra("AMOUNT", 1000);
        intent.putExtra("LOGIN_ID",loginId);
        intent.putExtra("LOGIN_PASSWORD", isNewLogin ? password : "VwiCredo@123");
        intent.putExtra("LOGO", Utils.getVariableImage(ContextCompat.getDrawable(getApplicationContext(), R.drawable.aashalogo)));
        startActivityForResult(intent, 1);

    }


    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == 1) {
            paymentStatusCode = resultCode;
            switch (resultCode) {
                case CredopayPaymentConstants.TRANSACTION_COMPLETED:
                    Toast.makeText(this, "Transaction Complete", Toast.LENGTH_LONG).show();
                    break;
                case CredopayPaymentConstants.TRANSACTION_CANCELLED:
                    Toast.makeText(this, "Transaction Cancelled", Toast.LENGTH_LONG).show();
                    break;
                case CredopayPaymentConstants.VOID_CANCELLED:
                    Toast.makeText(this, "VOID Cancelled", Toast.LENGTH_LONG).show();
                    break;
                case CredopayPaymentConstants.LOGIN_FAILED:
                    Toast.makeText(this, "LOGIN FAILED", Toast.LENGTH_LONG).show();
                    break;
                case CredopayPaymentConstants.CHANGE_PASSWORD:
                    // Toast.makeText(this, "CHANGE PASSWORD", Toast.LENGTH_LONG).show();
                    payAmount(true);
                    break;
                case CredopayPaymentConstants.CHANGE_PASSWORD_FAILED:
                    Toast.makeText(this, "CHANGE PASSWORD FAILED", Toast.LENGTH_LONG).show();
                    break;
                case CredopayPaymentConstants.CHANGE_PASSWORD_SUCCESS:
                    /*setChangePassword();*/
                    break;
                default:
                    if (data != null) {
                        Log.d("DEFAULT_RESULT", data.toString());
                    }

                    Toast.makeText(this, "ERROR WHILE LOGGING IN", Toast.LENGTH_LONG).show();
                    break;
            }
        }else if (requestCode == 49374){

            IntentResult scanningResult = IntentIntegrator.parseActivityResult(requestCode, resultCode, data);
            if (scanningResult != null) {
                //we have a result
                String scanContent = scanningResult.getContents();
                String scanFormat = scanningResult.getFormatName();
                // process received data
                processScannedData(scanContent);
            } else {
                Toast toast = Toast.makeText(getApplicationContext(), "No scan data received!", Toast.LENGTH_SHORT);
                toast.show();
            }
        }else{


            try {
                if (data == null) {
                    if (requestCode == 3) {
                        Log.d("No change in setting!", "Message");
                    } else if (resultCode == Activity.RESULT_OK) {
                        Log.d("Scan Data Missing!", "Message");
                        //btnAuthenticate.setEnabled(false);
                    } else if (resultCode == Activity.RESULT_CANCELED) {
                        //btnAuthenticate.setEnabled(false);
                        Log.d("Scan Failed/Aborted!", "Message");
                    }
                } else {
                    super.onActivityResult(requestCode, resultCode, data);
                    if (resultCode == Activity.RESULT_OK) {
                        if (requestCode == 9000) {
                            String rd_info1 = data.getStringExtra("RD_SERVICE_INFO");
                            if (rd_info1 != null && rd_info1.contains("NOTREADY")) {
                                isRDReady = false;
                                //check_device.setText("Not Ready");
                                //imageView.setImageResource(R.drawable.dislike);
                                //CALLBACK METHOD
                                AddIntoList(foundPackName);
                            } else if (rd_info1 != null && rd_info1.contains("READY")) {
                                isRDReady = true;
                                //CALLBACK METHOD
                                AddIntoList(foundPackName);
                            }

                            listCount = listCount + 1;
                            if (listCount < foundPackCount) {
                                Object rInfo = list.get(listCount);
                                final String packageName = ((ResolveInfo) rInfo).activityInfo.applicationInfo
                                        .packageName.trim();
                                foundPackName = packageName;
                                Intent intent1 = new Intent("in.gov.uidai.rdservice.fp.INFO", null);
                                intent1.setPackage(packageName);
                                startActivityForResult(intent1, 9000);
                            }
                        } else if (requestCode >= 100) {
                            String rd_info = data.getStringExtra("RD_SERVICE_INFO");
                            if (rd_info != null) {
                                Log.d(rd_info, "RD SERVICE INFO XML");
                            } else {
                                Log.d("NULL STRING RETURNED", "RD SERVICE INFO XML");
                            }

                            String dev_info = data.getStringExtra("DEVICE_INFO");
                            if (dev_info != null) {
                                Log.d(dev_info, "DEVICE INFO XML");
                            } else {
                                Log.d("NULL STRING RETURNED", "DEVICE INFO XML");
                            }
                        } else if (requestCode == 2) {
                            String pidDataXML = data.getStringExtra("PID_DATA");
                            //String pidDataXML="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><PidData>   <DeviceInfo dc=\"380d4e3a-d31e-459d-8734-3d73f083559d\" dpId=\"Morpho.SmartChip\" mc=\"MIIEBzCCAu+gAwIBAgIGAWer2Q/yMA0GCSqGSIb3DQEBCwUAMIGjMSEwHwYDVQQDExhEUyBTTUFSVCBDSElQIFBWVCBMVEQgMTIxHjAcBgNVBDMTFUQgMjE2IFNlY3RvciA2MyBOb2lkYTEOMAwGA1UECRMFTm9pZGExFjAUBgNVBAgTDVVUVEFSIFBSQURFU0gxDDAKBgNVBAsTA0RTQTEbMBkGA1UEChMSU01BUlQgQ0hJUCBQVlQgTFREMQswCQYDVQQGEwJJTjAeFw0xODEyMTQwODMzMDhaFw0xOTAxMTMwODMzMDhaMIHFMTcwNQYDVQQDDC5yZF9kZXZpY2VfMzgwZDRlM2EtZDMxZS00NTlkLTg3MzQtM2Q3M2YwODM1NTlkMQswCQYDVQQGEwJpbjEWMBQGA1UECBMNVXR0YXIgUHJhZGVzaDEOMAwGA1UEBxMFTm9pZGExMTAvBgkqhkiG9w0BCQEWInBhbmthai5hZ2Fyd2FsQHNtYXJ0Y2hpcG9ubGluZS5jb20xDDAKBgNVBAsTA0RTQTEUMBIGA1UEChMLTUFSUEhPUkRQT0MwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCX4WLCXAbUKhr0Z/LNfAYLl7MikW7FJdQZ4UeVko4ZBDasu/fq5eu4syNv1aFjAUngV1WOvlIAx9YgJsV9CyX+qbw4w2kMjqZ0qGk1cEoJeG1o7/mkr16zXSZOMqWoDu0HRksLQUgwTMAx0v8coSj3Z6ndQXg7g+XZDiFxBSlaEqWwItEYiAZN9EWFCaLjQv425olUdafhCGNgnWlxCKg+hBpwCkhxNRoUxDxxsyg6+7+jOUbUPhA0J1YBYH4y5ElHq6jZ6amHQtqqyEtI1sKB+lRHepHtg0rAB7RhEeHsw/OVovPlU3OTSLUGLn7mftFhbnwNr8CNx6IVqKkFcaZdAgMBAAGjHTAbMAwGA1UdEwQFMAMBAf8wCwYDVR0PBAQDAgGGMA0GCSqGSIb3DQEBCwUAA4IBAQA1rBkQKnAmFZUXF1MfMA9HdKuYECxVQ8rFHL1V0MEPIorLmKneYXiM+AlkFmOTfI/0v09CbA0YFzINGL4vpmLTgIj0q06q1TNblXgiN2ToCIZ3RnX4ZJEjwh87nLxBSYk9g4OONFQoP5pHpdeBrjJi6gwxYPH/ji6e0tVo1Uwh8ArTP3ZOCVDliY7GjrWy7V4NyPVcLgwe76M9YhhHog7Q61SUVg9nqg0cTIucjTSFLjgoKt1QvgAsISiShxxHaUAKGoGl5kczmi1x2wZ3YszHeWaRf5NlFS6GuYQapITiiWl8IZTZ+QIuWQLVTSB1hAV+9M664PtIsP7Os3dMYepT\" mi=\"MSO1300E2L0SW\" rdsId=\"SCPL.AND.001\" rdsVer=\"1.1.1\"/>   <Data type=\"X\">MjAxOC0xMi0xNFQxNDowNzowMiCP2CIVK2SlycheekTzxdFTl0VRhdvR06nTJYEdHqCbnN+6czW5BuAgtFb1OG3GXBxTRMIjeWZ2Kziu4yNc7BtAxGg3Chhr6tOUQvf6KYoFBZgGqHOLnqiZ9nKZeixKf8YF2ObbL0b6rdS28NmJizmYRjCFjl5Xbpy7JBXH59YUn+mQsNO3CFwCGu32O1KPn2k48EWJLUiUVcpM9l9MDEWJbqaBNJEomj7kFQgTJ6frtbarGwzp1bfaXypb5sRW+TWLmlysIImfYmSxjfjJ4w8VjDRJx+tmRVK/Lc0cKnVx5v5StgvU6E1UL43uZZnOgKeweWOsvKN+1KueKhUPOa6mo4L5sL2GstANNOf7iYAt2CPO0YC/9PrU1yxDAsGg1oX91bx5XqtGQvAq/mOGou1QckXHI8Y/5keKnTzeoe1OclNzjHlc5rEEokEzfRpzXw2pkCAjLPrhn2RL1qzbyIbyA9JpshaZ4f8o4ej17HIs8fsgz8MHUQ9dEGthRoKdpaFW5pPLHr762JbsYnMwXwPA/6Vm30pEDWghQ6iSlijkteerpKar9/BxhhyPus4OzUh8olup8jKvq57gQk+zm30B8zwh7+ByMhWkQpWI5BfEsWpdl6PylrsdUoeg3bWICGy9cBHf/kN7Wn9nPS99qXxp5YhaLdzCO7NAWxkm6eXhdHdAM8Oj+Yj83P4BS4n663j0Z/cKUgYJQIn93i/fuXDRhfiXgzynaH67jv9fv+BL81DHGTKw6JDXBHHB7yyzJRfdu891Nv6tqrU30wHM4pWSS6HxFCnPvnnRcjxGuLp3ZkSIWta3TWQGDpDOUPy4YfUFAjERLSCU3Sh+Hg/ub8B5/pogjJeY3H4+wagfoYh1Zg4pLfEsbCESiGZj+4+SPHY7aXOUmVKAErRQEIZVjsb3lOKdnt4PuHfQoM7T+Ac5+MZfIs0UYDKVUd7p5r296cDYFDRyMzdykH+TNCLT4/MaR78aJcSaOtCzsj0ln8peoLumUkxNYHy/u8AyDYv4X2UuqAjEa1LoyQuBLjaLQTGSP+152YrT5FGU0N4FcihZpQsi3x7dOUuCfmwdSKzNCyhzfhK30Rwf3AwiwKRXcGI8a6lVEb1sZpCePs0io3VTXB7VXUVlybjye+HCUJrW+83yJbxkfdlulUbF7TXhpLeF2eN1WrFB2cwmOKWoc7xHHGZPSmt+hZdJH4Ouqe5jSE0vxRP8WhPR3uyPCqyyRlqY7gVf1Q2tzG+JcCkA7OdIhsEy7UUsbVAC0XfOgD3sh0ufAZObQmTH7fAOLaNLDEX7iOBm</Data>   <Skey ci=\"20191230\">UmzkRsWxlcidNaXWHoDy5OEQ6PP6nUoyIwCR6WDQ4O7p29VwuOEI/pXP3Rzo7owVTgrFYfhKpix7BpGe+5s+TPHg0kBIHcCKthgoGs0YTY4sQRHM48MtoJ77JphO2McXyW6qp/fEakeFXqtHWoPYZIPCHK/AY9ZGHqxOVx6P1thmEZ5e6jpCA1o/pmfimEgK0pC0vOJu8iO1/CjtDOkqxzuAkKfxoWylTimkok/Hi4aAPMi6zSQggQiIfPU4egc197Vs9ZLXkQSw+j6ELGOezGS7nVWgOANTL5UChiZ502bViiTWnT2my9kt3iqY0kLZIX/oc9lzK/RM5uNxaqlQOQ==</Skey>   <Hmac>GtMT0xF7E6ACStP6um7cnJbLAz4d4ckpHXPxeVJIzl+rCzp5Nqw4bkhYvAf4YZzp</Hmac>   <Resp errCode=\"0\" fCount=\"1\" fType=\"0\" iCount=\"0\" iType=\"0\" nmPoints=\"44\" pCount=\"0\" pType=\"\" qScore=\"49\"/></PidData>\n";
                            Messge = data.getStringExtra("PID_DATA");


                         /*File tarjeta = Environment.getExternalStorageDirectory();
                        File logFile = new File(tarjeta.getAbsolutePath() + "/", "pidDataXML.txt");
                        if (!logFile.exists()) {
                            try {
                                logFile.createNewFile();
                            } catch (IOException e) {
                                //TODO Auto-generated catch block
                                e.printStackTrace();
                            }
                        }
                        try {
                            //BufferedWriter for performance, true to set append to file flag
                            BufferedWriter buf = new BufferedWriter(new FileWriter(logFile, true));
                            buf.append(pidDataXML);
                            buf.newLine();
                            buf.close();
                        } catch (IOException e) {
                            // TODO Auto-generated catch block
                            e.printStackTrace();
                        }*/

                            JSONObject jsonObj = null;
                            //String pidDataXML = dd;
                            if (pidDataXML != null) {
                                try {
                                    if (MyDevice.equalsIgnoreCase("com.mantra.rdservice")){

                                        jsonObj = XML.toJSONObject(pidDataXML);
                                        //jsonObj=new JSONObject(dd);
                                        JSONObject jsonObject = jsonObj.getJSONObject("PidData");
                                        JSONObject jdata = jsonObject.getJSONObject("Data");
                                        PidDatatype = jdata.getString("type");
                                        Piddata = jdata.getString("content");

                                        JSONObject DeviceInfo = jsonObject.getJSONObject("DeviceInfo");
                                        dc = DeviceInfo.getString("dc");
                                        dpID = DeviceInfo.getString("dpId");
                                        mc = DeviceInfo.getString("mc");
                                        mi = DeviceInfo.getString("mi");
                                        rdsID = DeviceInfo.getString("rdsId");
                                        rdsVer = DeviceInfo.getString("rdsVer");

                                        hmac = jsonObject.getString("Hmac");

                                        JSONObject addinfooo = DeviceInfo.getJSONObject("additional_info");

                                        JSONArray jsonArray = addinfooo.getJSONArray("Param");

                                        for (int d = 0; d < jsonArray.length(); d++) {

                                            JSONObject param = jsonArray.getJSONObject(d);
                                            String name = param.getString("name");

                                            if (name.equalsIgnoreCase("srno")){

                                                Devicesrno = param.getString("value");

                                            }

                                        }

                                        JSONObject response = jsonObject.getJSONObject("Resp");
                                        errCode = response.getString("errCode");

                                        errInfo = response.getString("errInfo");
                                        fCount = response.getString("fCount");
                                        fType = response.getString("fType");
                                        iCount = response.getString("iCount");
                                        //iType = response.getString("iType");
                                        nmPoints = response.getString("nmPoints");
                                        pCount = response.getString("pCount");
                                        pType = response.getString("pType");
                                        qScore = response.getString("qScore");

                                        JSONObject Skey = jsonObject.getJSONObject("Skey");
                                        ci = Skey.getString("ci");
                                        sessionKey = Skey.getString("content");


                                    }else if (MyDevice.equalsIgnoreCase("com.acpl.registersdk")){
                                        jsonObj = XML.toJSONObject(pidDataXML);
                                        //jsonObj=new JSONObject(dd);
                                        JSONObject jsonObject = jsonObj.getJSONObject("PidData");
                                        JSONObject jdata = jsonObject.getJSONObject("Data");
                                        PidDatatype = jdata.getString("type");
                                        Piddata = jdata.getString("content");

                                        JSONObject DeviceInfo = jsonObject.getJSONObject("DeviceInfo");
                                        dc = DeviceInfo.getString("dc");
                                        dpID = DeviceInfo.getString("dpId");
                                        mc = DeviceInfo.getString("mc");
                                        mi = DeviceInfo.getString("mi");
                                        rdsID = DeviceInfo.getString("rdsId");
                                        rdsVer = DeviceInfo.getString("rdsVer");

                                        hmac = jsonObject.getString("Hmac");

                                        JSONObject response = jsonObject.getJSONObject("Resp");
                                        errCode = response.getString("errCode");

                                        errInfo = response.getString("errInfo");
                                        fCount = response.getString("fCount");
                                        fType = response.getString("fType");
                                        //iCount = response.getString("iCount");
                                        //iType = response.getString("iType");
                                        nmPoints = response.getString("nmPoints");
                                        //pCount = response.getString("pCount");
                                        //pType = response.getString("pType");
                                        qScore = response.getString("qScore");

                                        JSONObject Skey = jsonObject.getJSONObject("Skey");
                                        ci = Skey.getString("ci");
                                        sessionKey = Skey.getString("content");

                                    }else if (MyDevice.equalsIgnoreCase("com.scl.rdservice")){
                                        jsonObj = XML.toJSONObject(pidDataXML);
                                        //jsonObj=new JSONObject(dd);
                                        JSONObject jsonObject = jsonObj.getJSONObject("PidData");
                                        JSONObject jdata = jsonObject.getJSONObject("Data");
                                        PidDatatype = jdata.getString("type");
                                        Piddata = jdata.getString("content");

                                        JSONObject DeviceInfo = jsonObject.getJSONObject("DeviceInfo");
                                        dc = DeviceInfo.getString("dc");
                                        dpID = DeviceInfo.getString("dpId");
                                        mc = DeviceInfo.getString("mc");
                                        mi = DeviceInfo.getString("mi");
                                        rdsID = DeviceInfo.getString("rdsId");
                                        rdsVer = DeviceInfo.getString("rdsVer");

                                        hmac = jsonObject.getString("Hmac");

                                        JSONObject addinfooo = DeviceInfo.getJSONObject("additional_info");

                                        JSONArray jsonArray = addinfooo.getJSONArray("Param");

                                        for (int d = 0; d < jsonArray.length(); d++) {

                                            JSONObject param = jsonArray.getJSONObject(d);
                                            String name = param.getString("name");

                                            if (name.equalsIgnoreCase("srno")){

                                                Devicesrno = param.getString("value");

                                            }

                                        }

                                        JSONObject response = jsonObject.getJSONObject("Resp");
                                        errCode = response.getString("errCode");

                                        //errInfo = response.getString("errInfo");
                                        fCount = response.getString("fCount");
                                        fType = response.getString("fType");
                                        iCount = response.getString("iCount");
                                        iType = response.getString("iType");
                                        nmPoints = response.getString("nmPoints");

                                        pCount = response.getString("pCount");
                                        pType = response.getString("pType");
                                        qScore = response.getString("qScore");

                                        JSONObject Skey = jsonObject.getJSONObject("Skey");
                                        ci = Skey.getString("ci");
                                        sessionKey = Skey.getString("content");
                                    }
                                } catch (JSONException e) {
                                    Log.e("JSON exception", e.getMessage());
                                    e.printStackTrace();
                                }

                                Log.d("XML", pidDataXML);

                                Log.d("JSON", jsonObj.toString());

                                //CommonUtils.showSuccessDialog(RdserviceActivity.this, jsonObj.toString());
                                RdserviceResponse();
                            }


                            if (pidDataXML != null) {
                                //Log.d(pidDataXML, "PID DATA XML");
                            } else {
                                Log.d("NULL STRING RETURNED", "PID DATA XML");
                            }

                        } else if (requestCode == 3) {
                            //CAPTURE ONLY
                        } else if (requestCode == 13) {
                            String value = data.getStringExtra("CLAIM");
                            if (value != null) {
                                Log.d(value, "INTERFACE CLAIM RESULT");
                            }
                        } else if (requestCode == 14) {
                            String value = data.getStringExtra("RELEASE");
                            if (value != null) {
                                Log.d(value, "INTERFACE RELEASE RESULT");
                            }
                        } else if (requestCode == 15) {
                            String value = data.getStringExtra("SET_REG");
                            if (value != null) {
                                Log.d(value, "REGISTRATION FLAG SET RESULT");
                            }
                        } else if (requestCode == 16) {
                            String value = data.getStringExtra("GET_REG");
                            if (value != null) {
                                Log.d(value, "REGISTRATION FLAG GET RESULT");
                            }
                        } else if (requestCode == 17) {
                            String value = data.getStringExtra("REVOKEREG");
                            if (value != null) {
                                Log.d(value, "REGISTRATION FLAG REVOKE RESULT");
                            }
                        } else if (requestCode == 19) {
                            String value = data.getStringExtra("SETLINKS");
                            if (value != null) {
                                Log.d(value, "SET LINK RESULT");
                            }
                        } else {

                        }
                    } else if (resultCode == Activity.RESULT_CANCELED) {
                        //btnAuthenticate.setEnabled(false);
                        Log.d("Scan Failed/Aborted!", "CAPTURE RESULT");
                    }
                }
            } catch (Exception ex) {
                Log.d("Error:-" + ex.getMessage(), "EXCEPTION");
                ex.printStackTrace();
            }

        }
    }

/**********************************Aadhar Scan**************************************/

   public void aadharscan(){

    IntentIntegrator integrator = new IntentIntegrator(MainActivity.this);
    integrator.setDesiredBarcodeFormats(IntentIntegrator.QR_CODE_TYPES);
    integrator.setPrompt("Scan a Aadharcard QR Code");
    integrator.setResultDisplayDuration(250);
    integrator.setCameraId(0); // Use a specific camera of the device
    integrator.initiateScan();

}

    protected void processScannedData(String scanData){
        Log.d("Rajdeol",scanData);
        XmlPullParserFactory pullParserFactory;
        try {
            // init the parserfactory
            pullParserFactory = XmlPullParserFactory.newInstance();
            // get the parser
            XmlPullParser parser = pullParserFactory.newPullParser();
            parser.setFeature(XmlPullParser.FEATURE_PROCESS_NAMESPACES, false);
            parser.setInput(new StringReader(scanData));
            // parse the XML
            int eventType = parser.getEventType();
            while (eventType != XmlPullParser.END_DOCUMENT) {
                if(eventType == XmlPullParser.START_DOCUMENT) {
                    Log.d("Rajdeol","Start document");
                } else if(eventType == XmlPullParser.START_TAG &&      DataAttributes.AADHAAR_DATA_TAG.equals(parser.getName())) {
                    // extract data from tag
                    //uid
                    uid = parser.getAttributeValue(null,DataAttributes.AADHAR_UID_ATTR);
                    //name
                    name = parser.getAttributeValue(null,DataAttributes.AADHAR_NAME_ATTR);
                    //gender
                    gender = parser.getAttributeValue(null,DataAttributes.AADHAR_GENDER_ATTR);
                    // year of birth
                    yearOfBirth = parser.getAttributeValue(null,DataAttributes.AADHAR_DOB_ATTR);
                    // care of
                    careOf = parser.getAttributeValue(null,DataAttributes.AADHAR_CO_ATTR);
                    // village Tehsil
                    villageTehsil = parser.getAttributeValue(null,DataAttributes.AADHAR_VTC_ATTR);
                    // Post Office
                    postOffice = parser.getAttributeValue(null,DataAttributes.AADHAR_PO_ATTR);
                    // district
                    district = parser.getAttributeValue(null,DataAttributes.AADHAR_DIST_ATTR);
                    // state
                    state = parser.getAttributeValue(null,DataAttributes.AADHAR_STATE_ATTR);
                    // Post Code
                    postCode = parser.getAttributeValue(null,DataAttributes.AADHAR_PC_ATTR);
                    Log.d("aadhnamee2",postCode);
                    number = parser.getAttributeValue(null,DataAttributes.AADHAR_MOBILE_ATTR);
                } else if(eventType == XmlPullParser.END_TAG) {
                    Log.d("Rajdeol","End tag "+parser.getName());
                } else if(eventType == XmlPullParser.TEXT) {
                    Log.d("Rajdeol","Text "+parser.getText());
                }
                // update eventType
                eventType = parser.next();
            }
            // display the data on screen
            displayScannedData();
        } catch (XmlPullParserException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }// EO

    public HashMap<String, String> displayScannedData(){

        HashMap<String, String> hash_map = new HashMap<String, String>();


        hash_map.put("1",name);
        hash_map.put("2",state);
        hash_map.put("3",district);
        hash_map.put("4",postCode);
        hash_map.put("5",uid);

        result.success(hash_map);

        return hash_map;


    }


    /**********************************Aeps**************************************/


    public void ekycscaninger(){

        try {

            MyDevice=selectedPackage;

            Log.d("MyDevice",MyDevice);
            Log.d("selectedPackage",selectedPackage);

            Intent intent1 = new Intent("in.gov.uidai.rdservice.fp.CAPTURE", null);

            //String pidOptXML  = createPidOptXML();

            if (MyDevice.equalsIgnoreCase("com.mantra.rdservice")){

                //================================================ Mantra Pid Option =======================================================
                intent1.putExtra("PID_OPTIONS", "<?xml version=\"1.0\"?> <PidOptions ver=\"1.0\"> <Opts fCount=\"1\" fType=\"0\" iCount=\"0\" pCount=\"0\" pgCount=\"2\" format=\"0\"   pidVer=\"2.0\" timeout=\"10000\" pTimeout=\"20000\" wadh=\"E0jzJ/P8UopUHAieZn8CKqS4WPMi5ZSYXgfnlfkWjrc=\" posh=\"UNKNOWN\" env=\"P\" /> <CustOpts><Param name=\"mantrakey\" value=\"\" /></CustOpts> </PidOptions>");

            }else if (MyDevice.equalsIgnoreCase("com.acpl.registersdk")){

                //================================================ Startek Pid Option =======================================================
                intent1.putExtra("PID_OPTIONS","<PidOptions><Opts fCount=\"1\" fType=\"0\" iCount=\"0\" iType=\"\" pCount=\"0\" pType=\"\" format=\"0\" pidVer=\"2.0\" timeout=\"20000\" otp=\"\" env=\"P\" wadh=\"E0jzJ/P8UopUHAieZn8CKqS4WPMi5ZSYXgfnlfkWjrc=\" posh=\"UNKNOWN\"/><Demo/> <CustOpts><Param name=\"\" value=\"\"/></CustOpts> </PidOptions>");
                //Startek :<PidOptions><Opts fCount="1" fType="0" iCount="0" iType="" pCount="0" pType="" format="0" pidVer="2.0" timeout="20000" otp="" env="P" wadh="" posh="UNKNOWN"/><Demo/><CustOpts><Param name="" value=""/></CustOpts></PidOptions>

            }else if (MyDevice.equalsIgnoreCase("com.scl.rdservice")) {

                //============================================ Morpho Pid Option =======================================================
                intent1.putExtra("PID_OPTIONS", "<PidOptions ver=\"1.0\">\" + \"<Opts env=\"P\" fCount=\"1\" fType=\"0\" iCount=\"0\" iType=\"\" pCount=\"0\" pType=\"\" format=\"0\" pidVer=\"2.0\" timeout=\"20000\" wadh=\"E0jzJ/P8UopUHAieZn8CKqS4WPMi5ZSYXgfnlfkWjrc=\" posh=\"UNKNOWN\" />\" + \"<Demo></Demo>\" + \"<CustOpts>\" + \"<Param name=\"\" value=\"\" />\" + \"</CustOpts>\" + \"</PidOptions>");
                //Morpho: <PidOptions ver="1.0">" + "<Opts env=\"P\" fCount=\"1\" fType=\"0\" iCount=\"0\" iType=\"\" pCount=\"0\" pType=\"\" format=\"0\" pidVer=\"2.0\" timeout=\"200\" wadh=\"\" posh=\"UNKNOWN\" />" + "<Demo></Demo>" + "<CustOpts>" + "<Param name=\"\" value=\"\" />" + "</CustOpts>" + "</PidOptions>

                //==================================================== END =============================================================

            }

            intent1.setPackage(selectedPackage);

            startActivityForResult(intent1,2);

        } catch (Exception e) {
            Log.d( "device not connect" /*e.getMessage()*/, "ALERT!!");
        }

    }

    public void scaninger(){

        try {

            MyDevice=selectedPackage;

            Log.d("MyDevice",MyDevice);
            Log.d("selectedPackage",selectedPackage);

            Intent intent1 = new Intent("in.gov.uidai.rdservice.fp.CAPTURE", null);

            //String pidOptXML  = createPidOptXML();

            if (MyDevice.equalsIgnoreCase("com.mantra.rdservice")){

                //================================================ Mantra Pid Option =======================================================
                intent1.putExtra("PID_OPTIONS", "<?xml version=\"1.0\"?> <PidOptions ver=\"1.0\"> <Opts fCount=\"1\" fType=\"0\" iCount=\"0\" pCount=\"0\" pgCount=\"2\" format=\"0\"   pidVer=\"2.0\" timeout=\"10000\" pTimeout=\"20000\" posh=\"UNKNOWN\" env=\"P\" /> <CustOpts><Param name=\"mantrakey\" value=\"\" /></CustOpts> </PidOptions>");

            }else if (MyDevice.equalsIgnoreCase("com.acpl.registersdk")){

                //================================================ Startek Pid Option =======================================================
                intent1.putExtra("PID_OPTIONS","<PidOptions><Opts fCount=\"1\" fType=\"0\" iCount=\"0\" iType=\"\" pCount=\"0\" pType=\"\" format=\"0\" pidVer=\"2.0\" timeout=\"20000\" otp=\"\" env=\"P\" wadh=\"\" posh=\"UNKNOWN\"/><Demo/> <CustOpts><Param name=\"\" value=\"\"/></CustOpts> </PidOptions>");
                //Startek :<PidOptions><Opts fCount="1" fType="0" iCount="0" iType="" pCount="0" pType="" format="0" pidVer="2.0" timeout="20000" otp="" env="P" wadh="" posh="UNKNOWN"/><Demo/><CustOpts><Param name="" value=""/></CustOpts></PidOptions>

            }else if (MyDevice.equalsIgnoreCase("com.scl.rdservice")) {

                //============================================ Morpho Pid Option =======================================================
                intent1.putExtra("PID_OPTIONS", "<PidOptions ver=\"1.0\">\" + \"<Opts env=\"P\" fCount=\"1\" fType=\"0\" iCount=\"0\" iType=\"\" pCount=\"0\" pType=\"\" format=\"0\" pidVer=\"2.0\" timeout=\"20000\" wadh=\"\" posh=\"UNKNOWN\" />\" + \"<Demo></Demo>\" + \"<CustOpts>\" + \"<Param name=\"\" value=\"\" />\" + \"</CustOpts>\" + \"</PidOptions>");
                //Morpho: <PidOptions ver="1.0">" + "<Opts env=\"P\" fCount=\"1\" fType=\"0\" iCount=\"0\" iType=\"\" pCount=\"0\" pType=\"\" format=\"0\" pidVer=\"2.0\" timeout=\"200\" wadh=\"\" posh=\"UNKNOWN\" />" + "<Demo></Demo>" + "<CustOpts>" + "<Param name=\"\" value=\"\" />" + "</CustOpts>" + "</PidOptions>

                //==================================================== END =============================================================

            }

            intent1.setPackage(selectedPackage);

            startActivityForResult(intent1,2);

        } catch (Exception e) {
            Log.d( "device not connect" /*e.getMessage()*/, "ALERT!!");
        }

    }

    private void ScanRDServices() {
        PackageManager pm = this.getPackageManager();
        Intent intent = new Intent("in.gov.uidai.rdservice.fp.INFO", null);
        list = pm.queryIntentActivities(intent, PackageManager.PERMISSION_GRANTED);
        rdList = new ArrayList<>();
        foundPackCount = 0;
        foundPackName = "";
        listCount = 0;

        if (list.size() > 0) {

            boolean containsFm220Rd = false;
            for (Object rInfo : list) {

                final String tmpPackName = ((ResolveInfo) rInfo).activityInfo.applicationInfo.packageName.trim();

                if(tmpPackName.contains("com.mantra.rdservice")){
                    containsFm220Rd = true;
                    break;
                }/*else if (tmpPackName.contains("com.scl.rdservice")){
                    Toast.makeText(RdserviceActivity.this,"hii",Toast.LENGTH_LONG).show();
                    containsFm220Rd = true;
                    break;
                }*/
            }

            foundPackCount = list.size();
            //Toast.makeText(RdserviceActivity.this,foundPackCount,Toast.LENGTH_LONG).show();
            if (list.size() > 1) {
                Object rInfo = list.get(0);
                final String packageName = ((ResolveInfo) rInfo).activityInfo.applicationInfo
                        .packageName.trim();
                foundPackName = packageName;
                Intent intent1 = new Intent("in.gov.uidai.rdservice.fp.INFO", null);
                intent1.setPackage(packageName);
                startActivityForResult(intent1, 9000);

            } else {
                for (Object rInfo : list) {
                    final String packageName = ((ResolveInfo) rInfo).activityInfo.applicationInfo
                            .packageName.trim();
                    foundPackName = packageName;

                    Intent intent1 = new Intent("in.gov.uidai.rdservice.fp.INFO", null);
                    intent1.setPackage(packageName);
                    startActivityForResult(intent1, 9000);
                }
            }
        }else{

        }

    }

    private void AddIntoList(String argPackName) {
        if(foundPackCount > 1){
            if (isRDReady) {
                rdList.add(argPackName + ": READY");

                selectedPackage = argPackName;

                result.success(selectedPackage);
                /*result.success(selectedPackage);*/


            } else {

                //rdList.add(argPackName + ": NOTREADY");
                //imageView.setImageResource(R.drawable.dislike);
            }
        }else{
            if (isRDReady) {
                rdList.add(argPackName + ": READY");
                selectedPackage = argPackName;
                result.success(selectedPackage);


            } else {


                //rdList.add(argPackName + ": NOTREADY");
                // imageView.setImageResource(R.drawable.dislike);
            }
        }

    }


    public void RdserviceResponse() {
        Log.d("Tag12","insdie12");
        System.out.println(" ================ Start ================");

        String jsonDataString;

        merchantTransactionId = date1;
        adhaarNumber = aadhanum;
        indicatorforUID = "0";
        nationalBankIdentificationNumber = bnkidd;
        languageCode = "en";
        latitude = lat;
        longitude = longg;
        merchantTranId = date1;
        transactionAmount = "111";
        mobileNumber = mobileNo;
        name = consuname;
        requestRemarks = "TN3000CA0006532";
        timestamp = date2;
        otpnum = otp;
        transactionType = "BE";
        merchantUserName = "";
        merchantPin = "";
        subMerchantId = "A2zsuvidhaa";

        Log.d("Tag111","insdie1");
        CaptureResponse captureResponse = new CaptureResponse(PidDatatype, Piddata, ci, dc, dpID, errCode, errInfo==null?"":errInfo, fCount, fType,
                hmac, iCount==null?"0":iCount, mc, mi, nmPoints, pCount==null?"0":pCount,
                pType==null?"0":pType,qScore, rdsID, rdsVer, sessionKey,Devicesrno,iType==null?"0":iType);

        Log.d("Tag2","insdie1");
        CardnumberORUID cardnumberORUID = new CardnumberORUID(adhaarNumber, indicatorforUID, nationalBankIdentificationNumber);
        Log.d("Tag3","insdie1");
        CaptureAePsModels captureAePsModels = new CaptureAePsModels(merchantTransactionId, languageCode, latitude, longitude, merchantTranId,
                transactionAmount, mobileNumber, requestRemarks, timestamp, transactionType, merchantUserName, merchantPin, subMerchantId, captureResponse, cardnumberORUID,name,otpnum);

        Log.d("Tag4","insdie1");


        Log.d("json1", new Gson().toJson(captureAePsModels));
        jsonDataString = new Gson().toJson(captureAePsModels);
        String jsonDataString1 = new Gson().toJson(captureResponse);
        String cardnumberORUIDd = new Gson().toJson(cardnumberORUID);
        Log.d("Tag5","insdie1");

        JsonParser parser = new JsonParser();

        JsonObject requestJson11 = parser.parse(jsonDataString1).getAsJsonObject();

        JsonObject cardnumberOR = parser.parse(cardnumberORUIDd).getAsJsonObject();

        Log.d("jjjddd", String.valueOf(requestJson11));

        JsonObject requestJson = parser.parse(jsonDataString).getAsJsonObject();


        Log.d("jjj", String.valueOf(requestJson));
       /* WifiManager manager = (WifiManager) getApplicationContext().getSystemService(Context.WIFI_SERVICE);
        WifiInfo info = manager.getConnectionInfo();
        String address = info.getMacAddress();*/
        Log.d("Tag6","insdie1");
        EncrptionMethodV2 encrptionMethodV2 = new EncrptionMethodV2();

        Log.d("Tag7","insdie1");
        try {
            skey = encrptionMethodV2.generateSessionKey();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch (NoSuchProviderException e) {
            e.printStackTrace();
        }
        String encryptData = null;
        try {
            encryptData = EncrptionMethodV2.encryptUsingSessionKey(skey, requestJson.toString().getBytes());
        } catch (InvalidCipherTextException e) {
            e.printStackTrace();
        }

        Log.d("Tag8","insdie1");

        HashGenerator generator = new HashGenerator();
        String hash = new String(Base64.encode(generator.generateSha256Hash(requestJson.toString().getBytes()), 1));
        Log.d("Tag9","insdie1");

        /* String s = requestJson + "\n" + "Hash : " + hash;*/

        String encryptUsingPublicKeyData = EncrptionMethodV2.encryptUsingPublicKey(skey, this);

        Log.d("Tag10","insdie1");

        Context context = MainActivity.this;

        String Bank_name = "pnbbb";

        /*AEPSGetBalanceTask aepsGetBalanceTask = new AEPSGetBalanceTask(RdserviceActivity.this, sweetAlertDialog, encryptData,
                    encryptUsingPublicKeyData, hash, Imei, address, sessionKey, date2, requestJson, Bank_name,Devicesrno);
            aepsGetBalanceTask.execute();*/


        HashMap<String, String> hash_map = new HashMap<String, String>();

        hash_map.put("0",String.valueOf(requestJson11));
        hash_map.put("1",String.valueOf(cardnumberOR));

        result.success(hash_map);





    }


    /***********************************Payment Gatway*****************************************/


    private PayUPaymentParams preparePayUBizParams() {

        HashMap<String, Object> additionalParams = new HashMap<>();
        additionalParams.put(PayUCheckoutProConstants.CP_UDF1, "udf1");
        additionalParams.put(PayUCheckoutProConstants.CP_UDF2, "udf2");
        additionalParams.put(PayUCheckoutProConstants.CP_UDF3, "udf3");
        additionalParams.put(PayUCheckoutProConstants.CP_UDF4, "udf4");
        additionalParams.put(PayUCheckoutProConstants.CP_UDF5, "udf5");

        //Below params should be passed only when integrating Multi-currency support
        //TODO Please pass your own Merchant Access Key below as provided by your Key Account Manager at PayU.
//        additionalParams.put(PayUCheckoutProConstants.CP_MERCHANT_ACCESS_KEY, testMerchantAccessKey);
        PayUSIParams siDetails = null;
         /*if(binding.switchSiOnOff.isChecked()) {
            siDetails  = new PayUSIParams.Builder().setIsFreeTrial(binding.layoutSiDetails.spFreeTrial.isChecked())
                    .setBillingAmount(binding.layoutSiDetails.etBillingAmountValue.getText().toString())
                    .setBillingCycle(PayUBillingCycle.valueOf(binding.layoutSiDetails.etBillingCycleValue.getSelectedItem().toString()))
                    .setBillingInterval(Integer.parseInt(binding.layoutSiDetails.etBillingIntervalValue.getText().toString()))
                    .setPaymentStartDate(binding.layoutSiDetails.etPaymentStartDateValue.getText().toString())
                    .setPaymentEndDate(binding.layoutSiDetails.etPaymentEndDateValue.getText().toString())
                    .setRemarks(binding.layoutSiDetails.etRemarksValue.getText().toString())
                    .setBillingLimit(PayuBillingLimit.valueOf(binding.layoutSiDetails.etBillingLimitValue.getSelectedItem().toString()))
                    .setBillingRule(PayuBillingRule.valueOf(binding.layoutSiDetails.etBillingRuleValue.getSelectedItem().toString()))
                    .build();

        }*/

        PayUPaymentParams.Builder builder = new PayUPaymentParams.Builder();
        builder.setAmount(payamount)
                .setIsProduction(true)
                .setProductInfo("Macbook Pro")
                .setKey(merchkey)
                .setPhone(paymobile)
                .setTransactionId(String.valueOf(System.currentTimeMillis()))
                .setFirstName(payname)
                .setEmail(payemail)
                .setSurl(surl)
                .setFurl(furl)
                .setUserCredential(merchkey + ":john@yopmail.com")
                .setAdditionalParams(additionalParams)
                .setPayUSIParams(siDetails);
        PayUPaymentParams payUPaymentParams = builder.build();
        return payUPaymentParams;
    }

    public void startPayment(View view) {
        // Preventing multiple clicks, using threshold of 1 second
        if (SystemClock.elapsedRealtime() - mLastClickTime < 1000)
            return;
        mLastClickTime = SystemClock.elapsedRealtime();
        initUiSdk(preparePayUBizParams());

    }

    private void initUiSdk(PayUPaymentParams payUPaymentParams) {
        PayUCheckoutPro.open(
                this,
                payUPaymentParams,
                getCheckoutProConfig(),
                new PayUCheckoutProListener() {

                    @Override
                    public void onPaymentSuccess(Object response) {
                        showAlertDialog(response);
                        System.out.println(response);
                    }

                    @Override
                    public void onPaymentFailure(Object response) {
                        showAlertDialog(response);
                    }

                    @Override
                    public void onPaymentCancel(boolean isTxnInitiated) {

                        Toast.makeText(MainActivity.this, "Transaction Cancelled By User", Toast.LENGTH_LONG).show();
                        //showSnackBar(getResources().getString(R.string.transaction_cancelled_by_user));
                    }

                    @Override
                    public void onError(ErrorResponse errorResponse) {
                        String errorMessage = errorResponse.getErrorMessage();
                        if (TextUtils.isEmpty(errorMessage))
                            System.out.println(errorMessage);
                        //errorMessage = getResources().getString(R.string.some_error_occurred);
                        Toast.makeText(MainActivity.this, errorMessage, Toast.LENGTH_LONG).show();

                    }

                    @Override
                    public void setWebViewProperties(@Nullable WebView webView, @Nullable Object o) {
                        //For setting webview properties, if any. Check Customized Integration section for more details on this
                    }

                    @Override
                    public void generateHash(HashMap<String, String> valueMap, PayUHashGenerationListener hashGenerationListener) {
                        String hashName = valueMap.get(PayUCheckoutProConstants.CP_HASH_NAME);
                        String hashData = valueMap.get(PayUCheckoutProConstants.CP_HASH_STRING);
                        if (!TextUtils.isEmpty(hashName) && !TextUtils.isEmpty(hashData)) {
                            //Generate Hash from your backend here
                            String hash = null;
                            if (hashName.equalsIgnoreCase(PayUCheckoutProConstants.CP_LOOKUP_API_HASH)){
                                //Calculate HmacSHA1 HASH for calculating Lookup API Hash
                                ///Do not generate hash from local, it needs to be calculated from server side only. Here, hashString contains hash created from your server side.

                                hash = calculateHmacSHA1Hash(hashData, testMerchantSecretKey);
                            } else {

                                //Calculate SHA-512 Hash here
                                hash = calculateHash(hashData + merchsalt);
                            }

                            HashMap<String, String> dataMap = new HashMap<>();
                            dataMap.put(hashName, hash);
                            hashGenerationListener.onHashGenerated(dataMap);
                        }
                    }
                }
        );
    }

    private void showAlertDialog(Object response){
        HashMap<String,Object> result = (HashMap<String, Object>) response;
        new AlertDialog.Builder(this)
                .setCancelable(false)
                .setMessage(
                        "Payu's Data : " + result.get(PayUCheckoutProConstants.CP_PAYU_RESPONSE) + "\n\n\n Merchant's Data: " + result.get(
                                PayUCheckoutProConstants.CP_MERCHANT_RESPONSE
                        )
                )
                .setPositiveButton("Ok", new DialogInterface.OnClickListener(){
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        dialogInterface.dismiss();
                    }
                }).show();
    }

    private String calculateHmacSHA1Hash(String data, String key) {
        String HMAC_SHA1_ALGORITHM = "HmacSHA1";
        String result = null;

        try {
            Key signingKey = new SecretKeySpec(key.getBytes(), HMAC_SHA1_ALGORITHM);
            Mac mac = Mac.getInstance(HMAC_SHA1_ALGORITHM);
            mac.init(signingKey);
            byte[] rawHmac = mac.doFinal(data.getBytes());
            result = getHexString(rawHmac);
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    private String calculateHash(String hashString) {
        try {
            MessageDigest messageDigest = MessageDigest.getInstance("SHA-512");
            messageDigest.update(hashString.getBytes());
            byte[] mdbytes = messageDigest.digest();
            return getHexString(mdbytes);
        }catch (Exception e){
            e.printStackTrace();
            return "";
        }
    }

    private PayUCheckoutProConfig getCheckoutProConfig() {
        PayUCheckoutProConfig checkoutProConfig = new PayUCheckoutProConfig();
        //checkoutProConfig.setPaymentModesOrder(getCheckoutOrderList());
        checkoutProConfig.setOfferDetails(getOfferDetailsList());
        checkoutProConfig.setEnforcePaymentList(getEnforcePaymentList());
        //checkoutProConfig.setShowCbToolbar(!binding.switchHideCbToolBar.isChecked());
        //checkoutProConfig.setAutoSelectOtp(binding.switchAutoSelectOtp.isChecked());
        //checkoutProConfig.setAutoApprove(binding.switchAutoApprove.isChecked());
        //checkoutProConfig.setSurePayCount(Integer.parseInt(binding.etSurePayCount.getText().toString()));
        //checkoutProConfig.setShowExitConfirmationOnPaymentScreen(!binding.switchDiableCBDialog.isChecked());
        //checkoutProConfig.setShowExitConfirmationOnCheckoutScreen(!binding.switchDiableUiDialog.isChecked());
        checkoutProConfig.setMerchantName("Merchant Name");
        checkoutProConfig.setMerchantLogo(R.drawable.aashalogo);
        checkoutProConfig.setWaitingTime(30000);
        checkoutProConfig.setMerchantResponseTimeout(30000);
        //checkoutProConfig.setCustomNoteDetails(getCustomeNoteList());
        /*if (reviewOrderAdapter != null)
            checkoutProConfig.setCartDetails(reviewOrderAdapter.getOrderDetailsList());*/
        return checkoutProConfig;
    }

    private String getHexString(byte[] array){
        StringBuilder hash = new StringBuilder();
        for (byte hashByte : array) {
            hash.append(Integer.toString((hashByte & 0xff) + 0x100, 16).substring(1));
        }
        return hash.toString();
    }

    private ArrayList<PayUOfferDetails> getOfferDetailsList() {
        ArrayList<PayUOfferDetails> offerDetails = new ArrayList<>();
        PayUOfferDetails payUOfferDetails1 = new PayUOfferDetails();
        payUOfferDetails1.setOfferTitle("Instant discount of Rs.2");
        payUOfferDetails1.setOfferDescription("Get Instant dicount of Rs.2 on all Credit and Debit card transactions");
        payUOfferDetails1.setOfferKey("OfferKey@9227");

        ArrayList<PaymentType> offerPaymentTypes1 = new ArrayList<>();
        offerPaymentTypes1.add(PaymentType.CARD);
        payUOfferDetails1.setOfferPaymentTypes(offerPaymentTypes1);

        PayUOfferDetails payUOfferDetails2 = new PayUOfferDetails();
        payUOfferDetails2.setOfferTitle("Instant discount of Rs.2");
        payUOfferDetails2.setOfferDescription("Get Instant dicount of Rs.2 on all NetBanking transactions");
        payUOfferDetails2.setOfferKey("TestOffer100@9229");

        ArrayList<PaymentType> offerPaymentTypes2 = new ArrayList<>();
        offerPaymentTypes2.add(PaymentType.NB);
        payUOfferDetails2.setOfferPaymentTypes(offerPaymentTypes2);

        offerDetails.add(payUOfferDetails1);
        offerDetails.add(payUOfferDetails2);
        return offerDetails;
    }

    private ArrayList<HashMap<String, String>> getEnforcePaymentList() {
        ArrayList<HashMap<String, String>> enforceList = new ArrayList();
        HashMap<String, String> map1 = new HashMap<>();
        //For Card

        if (paytype.equalsIgnoreCase("CC")){

            map1.put(PayUCheckoutProConstants.CP_PAYMENT_TYPE, PaymentType.CARD.name());
            map1.put(PayUCheckoutProConstants.CP_CARD_TYPE, CardType.CC.name());
            enforceList.add(map1);

        }else if (paytype.equalsIgnoreCase("DC")){

            map1.put(PayUCheckoutProConstants.CP_PAYMENT_TYPE, PaymentType.CARD.name());
            map1.put(PayUCheckoutProConstants.CP_CARD_TYPE, CardType.DC.name());
            enforceList.add(map1);

        }else if (paytype.equalsIgnoreCase("WA")){

            //For Wallet
            HashMap<String, String> map3 = new HashMap<>();
            map3.put(PayUCheckoutProConstants.CP_PAYMENT_TYPE, PaymentType.WALLET.name());
            enforceList.add(map3);

        }else if (paytype.equalsIgnoreCase("NB")) {
            //FOr NetBanking
            HashMap<String, String> map2 = new HashMap<>();
            map2.put(PayUCheckoutProConstants.CP_PAYMENT_TYPE, PaymentType.NB.name());
            enforceList.add(map2);

        }else if (paytype.equalsIgnoreCase("UPI")){

            //For UPI
            HashMap<String, String> map4 = new HashMap<>();
            map4.put(PayUCheckoutProConstants.CP_PAYMENT_TYPE, PaymentType.UPI.name());
            enforceList.add(map4);

        }


        return enforceList;
    }

}