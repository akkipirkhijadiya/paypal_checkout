# PayPal Checkout for Flutter

This Flutter package integrates PayPal payments using WebView, allowing users to pay via PayPal or directly using a debit/credit card.

## Features
- Supports PayPal and Card payments.
- Uses WebView for payment processing.
- Handles success, error, and cancellation scenarios.
- Works in both Sandbox and Live modes.

## Installation
Add this package to your Flutter project:
```yaml
dependencies:
  paypal_checkout:
```

## Usage
### Import the package
```dart
import 'package:paypal_checkout/paypal_checkout.dart';
```

### Example Implementation
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => PayPalPaymentScreen(
    sandboxMode: true, // Set to false for live mode
    checkOutType: CheckOutType.paypal, // paypal or card
    clientId: 'YOUR_CLIENT_ID',
    secretKey: 'YOUR_SECRET_KEY',
    currency: "USD",
    amount: "10.00",
    returnURL: "https://example.com/success",
    cancelURL: "https://example.com/cancel",
    onSuccess: (data) {
      print("Payment Success: \$data");
    },
    onError: (error) {
      print("Payment Error: \$error");
    },
    onCancel: () {
      print("Payment Cancelled");
    },
  )),
);
```

## Parameters
| Parameter     | Type     | Description |
|--------------|---------|-------------|
| `sandboxMode` | `bool` | Enable sandbox mode for testing |
| `checkOutType` | `CheckOutType` | Choose between `paypal` or `card` checkout |
| `clientId` | `String` | Your PayPal client ID |
| `secretKey` | `String` | Your PayPal secret key |
| `currency` | `String` | Currency code (e.g., "USD") |
| `amount` | `String` | Payment amount |
| `returnURL` | `String` | URL to redirect upon successful payment |
| `cancelURL` | `String` | URL to redirect upon cancellation |
| `onSuccess` | `Function(Map<String, dynamic>)` | Callback for successful payment |
| `onError` | `Function(String)` | Callback for payment errors |
| `onCancel` | `Function()` | Callback when payment is canceled |

## PayPal API Integration
The package interacts with the PayPal API to:
1. Obtain an Access Token.
2. Create an order.
3. Process payment via WebView.
4. Capture the payment upon completion.

## Notes
- Ensure that you replace `YOUR_CLIENT_ID` and `YOUR_SECRET_KEY` with actual PayPal credentials.
- For production, disable sandbox mode.

## License
This package is open-source. You are free to modify and use it in your projects.
