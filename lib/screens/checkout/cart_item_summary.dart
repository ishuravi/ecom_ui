import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../constants.dart';
import '../../provider/cart_provider.dart';

class CartItemSummary extends StatelessWidget {
  const CartItemSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context);
    final cartItems = provider.cart; // Get the cart items from the provider

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Cart Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        // Display a message if the cart is empty
        if (cartItems.isEmpty)
          const Center(
            child: Text(
              'Your cart is empty.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return ListTile(
                leading: Icon(Icons.shopping_bag, color: kprimaryColor),
                title: Text(item.title), // Display the item's title
                subtitle: Text('Quantity: ${item.quantity}'),
                trailing: Text('\$${item.offerPrice * item.quantity}'),
              );
            },
          ),
      ],
    );
  }
}
