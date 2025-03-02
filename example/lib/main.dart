import 'package:flutter/material.dart';
import 'package:paypal_checkout/paypal_checkout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const PaypalPaymentExample(),
    );
  }
}

class PaypalPaymentExample extends StatefulWidget {
  const PaypalPaymentExample({super.key});

  @override
  State<PaypalPaymentExample> createState() => _PaypalPaymentExampleState();
}

class _PaypalPaymentExampleState extends State<PaypalPaymentExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: Text('Paypal Checkout'),backgroundColor: Colors.indigo.shade100,),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey)

            ),
            child: ListTile(leading: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQeyP_0YtjGAPJnOyzHmO-qQ82oXl_v4nIoFw&s',height: 40,),title: Text('Paypal'),onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PayPalPaymentScreen(
                    sandboxMode: false, // Set to false for live mode
                    checkOutType: CheckOutType.paypal,//paypal login to checkout
                    clientId: 'Aa0QFoaeNwbM7XG-VSKqcYLY8k85govWyQSZSrA-UjGfDs5-B55jW1cRHgJInN29KNq247zSB2DLWpwe',
                    secretKey: 'EIsyGnUM0OJQmNzC4Y7_-gy9hzlZTB3_JwKi5hsvIefJANeJQ5CMTPME56FOVqaCuAAO4-gskRWGRAPo',
                    currency: "USD",
                    amount: "10.00",
                    returnURL: "https://example.com/success",
                    cancelURL: "https://example.com/cancel",
                    onSuccess: (data) {
                      print("Payment Success: $data");
                    },
                    onError: (error) {
                      print("Payment Error: $error");
                    },
                    onCancel: () {
                      print("Payment Cancelled");
                    },
                  )));
            },),
          ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey)

            ),
            child: ListTile(leading: Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/Credit-cards.jpg/220px-Credit-cards.jpg',height: 40,),title: Text('Debit or Credit card to pay'),onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PayPalPaymentScreen(
                sandboxMode: false, // Set to false for live mode
                    checkOutType: CheckOutType.card,//direct card to checkout
                    clientId: 'Aa0QFoaeNwbM7XG-VSKqcYLY8k85govWyQSZSrA-UjGfDs5-B55jW1cRHgJInN29KNq247zSB2DLWpwe',
                    secretKey: 'EIsyGnUM0OJQmNzC4Y7_-gy9hzlZTB3_JwKi5hsvIefJANeJQ5CMTPME56FOVqaCuAAO4-gskRWGRAPo',
                currency: "USD",
                amount: "10.00",
                returnURL: "https://example.com/success",
                cancelURL: "https://example.com/cancel",
                onSuccess: (data) {
                  print("Payment Success: $data");
                },
                onError: (error) {
                  print("Payment Error: $error");
                },
                onCancel: () {
                  print("Payment Cancelled");
                },
              )));
            },),
          )
        ],
      ),
    );
  }
}
