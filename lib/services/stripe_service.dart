import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:workshop_management_system/Screens/const.dart';
import 'package:flutter/material.dart';

class StripeService {
  StripeService._();
  static final StripeService instance = StripeService._();

  // Main function to trigger the payment process
  Future<bool> makePayment({
    required double amount, // Accept in RM
    String currency = 'myr', // Default to MYR
  }) async {
    try {
      // Step 1: Create a payment intent
      String? clientSecret = await _createPaymentIntent(amount, currency);

      if (clientSecret == null) {
        print('❌ Failed to create payment intent.');
        return false;
      }

      // Step 2: Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'WMS',
          style: ThemeMode.light,
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              background: Color(0xFFF5F5F5),
              primary: Color(0xFF3D3455),
              componentBackground: Color(0xFFFFFFFF),
            ),
          ),
        ),
      );

      // Step 3: Present the payment sheet
      await Stripe.instance.presentPaymentSheet();

      print('✅ Payment successful!');
      return true;
    } on StripeException catch (e) {
      print('⚠ StripeException: ${e.error.localizedMessage}');
      return false;
    } catch (e) {
      print('🔥 Error during payment: $e');
      return false;
    }
  }

  // Create a payment intent using Stripe's API
  Future<String?> _createPaymentIntent(double amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount), // Convert RM → sen
        "currency": currency.toLowerCase(),
        "payment_method_types[]": "card",
      };

      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.data != null && response.data['client_secret'] != null) {
        return response.data['client_secret'];
      }
    } catch (e) {
      print("🔥 Error creating payment intent: $e");
    }

    return null;
  }

  // Convert RM to sen (Stripe requires smallest currency unit)
  String _calculateAmount(double amountInRM) {
    final int amountInSen = (amountInRM * 100).round();
    return amountInSen.toString();
  }
}
