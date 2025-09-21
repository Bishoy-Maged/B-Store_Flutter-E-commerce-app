import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import '../../../Services/auth_service.dart';
import '../../../Services/product_service.dart';
import '../login_screen.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final _authService = AuthService();
  final _productService = ProductService();

  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;

  final List<String> featuredImages = [
    'https://marketplace.canva.com/EAFED4mfw94/1/0/1600w/canva-yellow-white-modern-special-discount-banner-0J53SvmhoiY.jpg',
    'https://static.vecteezy.com/system/resources/previews/014/029/929/original/new-year-sale-banner-with-podium-and-shopping-bag-in-red-orange-and-white-business-promotion-banner-in-new-year-day-suitable-for-banner-poster-web-banner-social-media-etc-illustration-vector.jpg',
    'https://img.freepik.com/premium-vector/black-friday-shop-template-banner_616643-185.jpg',
  ];

  final List<Map<String, dynamic>> hotOffers = [
    {
      'image':
      'https://img.freepik.com/premium-vector/limited-time-special-offer-limited-time-discount-vector-sale-banner-template-big-discount_619470-376.jpg?w=2000',
      'description': 'Special discount on electronics - Limited time offer!'
    },
    {
      'image':
      'https://img.freepik.com/premium-vector/buy-2-get-1-free-banner-special-offer-banner-big-sale-sale-banner-banner-design-template_334050-3482.jpg',
      'description': 'Buy 2 Get 1 Free on selected items'
    },
    {
      'image': 'https://img.freepik.com/premium-vector/flash-sale-banner-promotion_131000-379.jpg',
      'description': 'Flash sale: Up to 50% off on fashion items'
    },
    {
      'image':
      'https://tse3.mm.bing.net/th/id/OIP.9HGePsF2oDoKP1AJAjy4UAHaE7?rs=1&pid=ImgDetMain&o=7&rm=3',
      'description': 'New arrivals with exclusive pricing'
    },
    {
      'image':
      'https://img.freepik.com/premium-vector/weekend-special-sale-tag-banner-design-template-marketing-special-offer-promotion-retail_680598-322.jpg?w=2000',
      'description': 'Weekend special: Free shipping on all orders'
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      setState(() => _isLoading = true);
      // Debug print
      print('Loading products...');
      final products = await _productService.getAllProducts();
      print('Products loaded: ${products.length}');
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading products: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              // localized with placeholder
              'error_loading_products'.tr(namedArgs: {'error': e.toString()}),
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('our_products'.tr()),
        centerTitle: true,
        leading: Image.asset(
          "assets/logos/BS Logo.png",
          height: 30,
          width: 30,
          fit: BoxFit.cover,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProducts,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              if (!mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Featured Products PageView
              SizedBox(
                height: 200,
                child: PageView.builder(
                  itemCount: featuredImages.length,
                  controller: PageController(viewportFraction: 0.9),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: featuredImages[index],
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Products GridView
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _products.isEmpty
                  ? Center(
                child: Column(
                  children: [
                    const Icon(Icons.inventory_2_outlined, size: 60, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'no_products'.tr(),
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              )
                  : GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.75,
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  final originalPrice = product['price']?.toDouble() ?? 0.0;
                  final discount = product['discount']?.toDouble() ?? 0.0;
                  final discountedPrice = originalPrice - (originalPrice * discount / 100);

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: product['imageData'] != null
                                  ? Image.memory(
                                base64Decode(product['imageData']),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error),
                              )
                                  : Container(
                                color: Colors.grey[200],
                                child: const Icon(Icons.image, size: 40, color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product['name'] ?? 'Unknown Product',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (discount > 0) ...[
                                      Text(
                                        '\$${originalPrice.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                      Text(
                                        '\$${discountedPrice.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ] else
                                      Text(
                                        '\$${originalPrice.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                          fontSize: 14,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_shopping_cart, size: 20),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('item_added_to_cart'.tr()),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          if (discount > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '-${discount.toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Hot Offers Section
              Text(
                'hot_offers'.tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: hotOffers.length,
                itemBuilder: (context, index) {
                  final offer = hotOffers[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: offer['image'],
                                  height: 80,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 3,
                              child: Text(
                                offer['description'],
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
