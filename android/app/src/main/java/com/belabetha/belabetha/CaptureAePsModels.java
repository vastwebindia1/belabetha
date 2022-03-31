package com.belabetha.belabetha;

import com.jstpay.jstpay.CaptureResponse;
import com.jstpay.jstpay.CardnumberORUID;

public class CaptureAePsModels {
    String merchantTransactionId, languageCode, latitude,  longitude;
    String merchantTranId,  transactionAmount,  mobileNumber, requestRemarks,name,otpnum;
    String timestamp,  transactionType,  merchantUserName,  merchantPin;
    String subMerchantId;
    String paymentType = "B";
    com.jstpay.jstpay.CaptureResponse captureResponse;
    com.jstpay.jstpay.CardnumberORUID cardnumberORUID;
    public CaptureAePsModels(String merchantTransactionId, String languageCode, String latitude, String longitude,
                             String merchantTranId, String transactionAmount, String mobileNumber, String requestRemarks,
                             String timestamp, String transactionType, String merchantUserName, String merchantPin,
                             String subMerchantId, CaptureResponse captureResponse, CardnumberORUID cardnumberORUID , String name, String otpnum) {
        this.merchantTransactionId=merchantTransactionId;
        this.languageCode=languageCode;
        this.latitude=latitude;
        this.longitude=longitude;
        this.merchantTranId=merchantTranId;
        this.transactionAmount=transactionAmount;
        this.mobileNumber=mobileNumber;
        this.requestRemarks=requestRemarks;
        this.timestamp=timestamp;
        this.transactionType=transactionType;
        this.merchantUserName=merchantUserName;
        this.merchantPin=merchantPin;
        this.subMerchantId=subMerchantId;
        this.captureResponse = captureResponse;
        this.cardnumberORUID = cardnumberORUID;
        this.name = name;
        this.otpnum = otpnum;
    }

   /* public String getMerchantTransactionId() {
        return merchantTransactionId;
    }

    public void setMerchantTransactionId(String merchantTransactionId) {
        this.merchantTransactionId = merchantTransactionId;
    }

    public String getLanguageCode() {
        return languageCode;
    }

    public void setLanguageCode(String languageCode) {
        this.languageCode = languageCode;
    }

    public String getLatitude() {
        return latitude;
    }

    public void setLatitude(String latitude) {
        this.latitude = latitude;
    }

    public String getLongitude() {
        return longitude;
    }

    public void setLongitude(String longitude) {
        this.longitude = longitude;
    }

    public String getMerchantTranId() {
        return merchantTranId;
    }

    public void setMerchantTranId(String merchantTranId) {
        this.merchantTranId = merchantTranId;
    }

    public String getTransactionAmount() {
        return transactionAmount;
    }

    public void setTransactionAmount(String transactionAmount) {
        this.transactionAmount = transactionAmount;
    }

    public String getMobileNumber() {
        return mobileNumber;
    }

    public void setMobileNumber(String mobileNumber) {
        this.mobileNumber = mobileNumber;
    }

    public String getRequestRemarks() {
        return requestRemarks;
    }

    public void setRequestRemarks(String requestRemarks) {
        this.requestRemarks = requestRemarks;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    public String getTransactionType() {
        return transactionType;
    }

    public void setTransactionType(String transactionType) {
        this.transactionType = transactionType;
    }

    public String getMerchantUserName() {
        return merchantUserName;
    }

    public void setMerchantUserName(String merchantUserName) {
        this.merchantUserName = merchantUserName;
    }

    public String getMerchantPin() {
        return merchantPin;
    }

    public void setMerchantPin(String merchantPin) {
        this.merchantPin = merchantPin;
    }

    public String getSubMerchantId() {
        return subMerchantId;
    }

    public void setSubMerchantId(String subMerchantId) {
        this.subMerchantId = subMerchantId;
    }*/
}
