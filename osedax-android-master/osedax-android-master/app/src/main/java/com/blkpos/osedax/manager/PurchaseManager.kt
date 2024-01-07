package com.blkpos.osedax.manager

import android.app.Activity
import android.util.Log
import com.android.billingclient.api.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class PurchaseManager(private val activity: Activity, private val onPurchase: () -> Unit ) {

    private val purchaseUpdateListener =
        PurchasesUpdatedListener { billingResult, purchases ->

            if (billingResult.responseCode == BillingClient.BillingResponseCode.OK && purchases != null) {
                for (purchase in purchases) {
                    handlePurchase(purchase)
                }
            } else if (billingResult.responseCode == BillingClient.BillingResponseCode.USER_CANCELED) {
                // Handle an error caused by a user cancelling the purchase flow.
            } else {
                // Handle any other error codes.
            }
        }

    private var billingClient = BillingClient.newBuilder(activity)
        .setListener(purchaseUpdateListener)
        .enablePendingPurchases()
        .build()


    fun purchase(sku: String){

        billingClient.startConnection(object : BillingClientStateListener {
            override fun onBillingSetupFinished(billingResult: BillingResult) {
                if (billingResult.responseCode ==  BillingClient.BillingResponseCode.OK) {
                    // The BillingClient is ready. You can query purchases here.
                    querySkuDetails(sku)
                }
            }
            override fun onBillingServiceDisconnected() {
                // Try to restart the connection on the next request to
                // Google Play by calling the startConnection() method.
            }
        })
    }
    fun querySkuDetails(sku: String) {
        val skuList = ArrayList<String>()
        skuList.add(sku)
        val params = SkuDetailsParams.newBuilder()
        params.setSkusList(skuList).setType(BillingClient.SkuType.INAPP)
        params.setType(BillingClient.SkuType.INAPP)
        billingClient.querySkuDetailsAsync(params.build()
        ) { _, list ->

            if (list != null) for (sku in list) {

                val flowParams = BillingFlowParams.newBuilder()
                    .setSkuDetails(sku)
                    .build()
                val responseCode =
                    billingClient.launchBillingFlow(activity, flowParams).responseCode

            }
        }
        // Process the result.
    }

    private fun handlePurchase(purchase: Purchase) {

        if (purchase.purchaseState === Purchase.PurchaseState.PURCHASED) {
            if (!purchase.isAcknowledged) {
                val acknowledgePurchaseParams = AcknowledgePurchaseParams.newBuilder()
                    .setPurchaseToken(purchase.purchaseToken)
//                val ackPurchaseResult = billingClient.acknowledgePurchase(acknowledgePurchaseParams.build(), object: AcknowledgePurchaseResponseListener {
//                    override fun onAcknowledgePurchaseResponse(p0: BillingResult) {
//                        onPurchase()
//                    }
//
//                })

                val consumeParams =
                    ConsumeParams.newBuilder()
                        .setPurchaseToken(purchase.purchaseToken)
                        .build()

                billingClient.consumeAsync(consumeParams) { billingResult, _ ->
                    if (billingResult.responseCode == BillingClient.BillingResponseCode.OK) {
                        onPurchase()
                    }
                }

            }
        }


        // Purchase retrieved from BillingClient#queryPurchases or your PurchasesUpdatedListener.

        // Verify the purchase.
        // Ensure entitlement was not already granted for this purchaseToken.
        // Grant entitlement to the user.

//        val consumeParams =
//            ConsumeParams.newBuilder()
//                .setPurchaseToken(purchase.getPurchaseToken())
//                .build()
//
//        billingClient.consumeAsync(consumeParams) { billingResult, outToken ->
//            if (billingResult.responseCode == BillingClient.BillingResponseCode.OK) {
//                // Handle the success of the consume operation.
//            }
//        }
    }

}