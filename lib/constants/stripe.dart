import 'package:flutter_dotenv/flutter_dotenv.dart';

// Use empty string as fallback if environment variables are not found
String publishablekey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
String secretkey = dotenv.env['STRIPE_SECRET_KEY'] ?? '';

// Add a function to check if Stripe is properly configured
bool isStripeConfigured() {
  return publishablekey.isNotEmpty && secretkey.isNotEmpty;
}
