import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import '../../../../Services/product_service.dart';

class AddItems extends StatefulWidget {
  const AddItems({super.key});

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  
  final ProductService _productService = ProductService();
  final ImagePicker _picker = ImagePicker();
  
  String? selectedCategory;
  bool _isLoading = false;
  File? _selectedImage;
  
  final List<String> categories = [
    'Electronics',
    'Clothing',
    'Home & Garden',
    'Sports',
    'Books',
    'Beauty',
    'Toys',
    'Automotive',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _sizeController.dispose();
    _colorController.dispose();
    _discountController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image selected successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        selectedCategory == null ||
        _sizeController.text.isEmpty ||
        _colorController.text.isEmpty ||
        _discountController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select an image')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Convert the selected image to base64 for storage
      final imageBytes = await _selectedImage!.readAsBytes();
      final imageBase64 = base64Encode(imageBytes);
      
      await _productService.addProduct(
        name: _nameController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        category: selectedCategory!,
        size: _sizeController.text.trim(),
        color: _colorController.text.trim(),
        discount: double.parse(_discountController.text.trim()),
        description: _descriptionController.text.trim(),
        quantity: int.parse(_quantityController.text.trim()),
        imageData: imageBase64,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully!')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding product: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add New Items"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Image Upload Section
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[100],
                      ),
                      child: _selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image),
                              ),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey),
                                SizedBox(height: 8),
                                Text('Tap to add image', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Product Name
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Product Name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.shopping_bag),
                  ),
                ),
                const SizedBox(height: 15),

                // Price
                TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Price (\$)",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                ),
                const SizedBox(height: 15),

                // Category Dropdown
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: "Category",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                ),
                const SizedBox(height: 15),

                // Size
                TextField(
                  controller: _sizeController,
                  decoration: const InputDecoration(
                    labelText: "Size (comma separated)",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.straighten),
                    hintText: "e.g., S, M, L, XL",
                  ),
                ),
                const SizedBox(height: 15),

                // Color
                TextField(
                  controller: _colorController,
                  decoration: const InputDecoration(
                    labelText: "Color (comma separated)",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.palette),
                    hintText: "e.g., Red, Blue, Green",
                  ),
                ),
                const SizedBox(height: 15),

                // Discount
                TextField(
                  controller: _discountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Discount Percentage (%)",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.discount),
                  ),
                ),
                const SizedBox(height: 15),

                // Description
                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                ),
                const SizedBox(height: 15),

                // Quantity
                TextField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Quantity",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.inventory),
                  ),
                ),
                const SizedBox(height: 30),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Add Product',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
