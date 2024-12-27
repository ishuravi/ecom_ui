import 'package:ecommerce_vst/screens/checkout/payment_method_selector.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'address_selector.dart';
import 'cart_item_summary.dart';
import 'check_box.dart';


class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout',style: TextStyle(color: Colors.white),),
        backgroundColor: kprimaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            CartItemSummary(),
            SizedBox(height: 20),
            AddressSelector(),
            SizedBox(height: 20),
            PaymentMethodSelector(),
            SizedBox(height: 20),
            CheckOutBox1(),
          ],
        ),
      ),
    );
  }
}
