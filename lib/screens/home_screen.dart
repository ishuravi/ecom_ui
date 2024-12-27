import 'dart:convert';
import 'package:ecommerce_vst/screens/product_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../widgets/app_bar.dart';
import '../widgets/image_slider.dart';
import '../widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentSlider = 0;
  int selectedIndex = 0; // To track selected category
  String? selectedCategoryId; // To store the selected category ID
  String? selectedSubcategoryId; // To store the selected subcategory ID
  List<dynamic> categories = [];
  List<dynamic> products = [];



  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response =
        await http.get(Uri.parse('http://103.61.224.178:8022/pcategory'));
    if (response.statusCode == 200) {
      setState(() {
        categories = json.decode(response.body);
        // Initially set the selected category ID if categories are available
        if (categories.isNotEmpty) {
          selectedCategoryId = categories[0]['_id'];
          selectedSubcategoryId = categories[0]['subcategories']?.first['_id'];
        }
        // Debugging the initial category and subcategory IDs
        print('Initial Category ID: $selectedCategoryId');
        print('Initial Subcategory ID: $selectedSubcategoryId');
      });
      // Fetch products after loading categories
      fetchProducts();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Function to fetch products based on category and subcategory IDs
  Future<void> fetchProducts() async {
    if (selectedCategoryId != null && selectedSubcategoryId != null) {
      final response = await http.get(Uri.parse(
          'http://103.61.224.178:8022/Products/products/$selectedCategoryId/$selectedSubcategoryId'));

      if (response.statusCode == 200) {
        setState(() {
          // Parse each product to a Product instance
          products = (json.decode(response.body)['products'] as List)
              .map((data) => Product.fromJson(data))
              .toList();
        });
        print('Fetched Products: $products');
      } else {
        throw Exception('Failed to load products');
      }
    }
  }


  // This function will be called whenever a new category is selected
  void onCategorySelected(int index) {
    setState(() {
      selectedIndex = index;
      selectedCategoryId = categories[index]['_id'];
      selectedSubcategoryId = categories[index]['subcategories']?.first['_id'];
    });
    // Debugging the selected category and subcategory IDs
    print('Selected Category ID: $selectedCategoryId');
    print('Selected Subcategory ID: $selectedSubcategoryId');
    fetchProducts(); // Fetch products when category changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 35),
              const CustomAppBar(),
              const SizedBox(height: 20),
              const MySearchBAR(),
              const SizedBox(height: 20),
              ImageSlider(
                currentSlide: currentSlider,
                onChange: (value) {
                  setState(() {
                    currentSlider = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Category Section
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return GestureDetector(
                      onTap: () => onCategorySelected(index),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: category['image'] != null
                                ? Image.network(
                                    'http://103.61.224.178:8022${category['image']}',
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey.shade300,
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            category['title'],
                            style: TextStyle(
                              color: selectedIndex == index
                                  ? Colors.blue
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Subcategory Section
              if (categories.isNotEmpty &&
                  categories[selectedIndex]['subcategories'] != null)
                Wrap(
                  spacing: 10,
                  children: List.generate(
                    categories[selectedIndex]['subcategories'].length,
                    (index) {
                      final subcategory =
                          categories[selectedIndex]['subcategories'][index];
                      return ChoiceChip(
                        label: Text(subcategory['title']),
                        selected: selectedSubcategoryId == subcategory['_id'],
                        onSelected: (bool selected) {
                          setState(() {
                            selectedSubcategoryId =
                                selected ? subcategory['_id'] : null;
                          });
                          // Debugging the selected subcategory ID
                          print(
                              'Selected Subcategory ID: $selectedSubcategoryId');
                          fetchProducts(); // Fetch products when subcategory changes
                        },
                      );
                    },
                  ),
                ),

              // Product Grid Section

              const SizedBox(height: 20),
              if (selectedIndex == 0)
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Special For You",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      "See all",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              // for shopping items
              const SizedBox(height: 10),

              if (products.isNotEmpty)
                GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: products[index], // Now each item is a Product
                    );
                  },
                )


            ],
          ),
        ),
      ),
    );
  }
}
