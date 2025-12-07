import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skin_firts/core/constants/api_constants.dart';

// Models
class Medicine {
  final String medicineId;
  final String name;
  final String category;
  final String form;
  final double price;
  final int stockQuantity;
  final String status;

  Medicine({
    required this.medicineId,
    required this.name,
    required this.category,
    required this.form,
    required this.price,
    required this.stockQuantity,
    required this.status,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    // MongoDB field is 'medicineid' (lowercase)
    return Medicine(
      medicineId: json['medicineid'] ?? json['MedicineId'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      form: json['form'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      stockQuantity: json['stockQuantity'] ?? 0,
      status: json['status'] ?? '',
    );
  }
}

class OrderLineItem {
  final String medicineId;
  final String name;
  int quantity;
  final int unitQuantity;
  final double unitCost;

  OrderLineItem({
    required this.medicineId,
    required this.name,
    required this.quantity,
    this.unitQuantity = 1,
    required this.unitCost,
  });

  double get totalPrice => quantity * unitCost;

  Map<String, dynamic> toJson() => {
        'medicineId': medicineId,  // API expects 'medicineId'
        'name': name,
        'quantity': quantity,
        'unitQuantity': unitQuantity,
        'unitCost': unitCost,
      };
}

// API Service
class MedicineApiService {
  static const String baseUrl = ApiConstants.baseURL;

  static Future<Map<String, dynamic>> searchMedicines({
    String? searchTerm,
    String? category,
    String? form,
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = <String, String>{};
    if (searchTerm != null && searchTerm.isNotEmpty) queryParams['searchTerm'] = searchTerm;
    if (category != null && category.isNotEmpty) queryParams['category'] = category;
    if (form != null && form.isNotEmpty) queryParams['form'] = form;
    if (status != null && status.isNotEmpty) queryParams['status'] = status;
    queryParams['page'] = page.toString();
    queryParams['limit'] = limit.toString();

    final uri = Uri.parse('$baseUrl/medicines/search').replace(queryParameters: queryParams);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to search medicines: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> createOrder({
    required String patientName,
    required String contactNumber,
    required String shippingAddress,
    String? patientId,
    String? prescriptionRef,
    required List<OrderLineItem> items,
  }) async {
    final uri = Uri.parse('$baseUrl/medicine-orders');
    final body = {
      'patientName': patientName,
      'contactNumber': contactNumber,
      'shippingAddress': shippingAddress,
      if (patientId != null && patientId.isNotEmpty) 'patientId': patientId,
      if (prescriptionRef != null && prescriptionRef.isNotEmpty) 'prescriptionRef': prescriptionRef,
      'items': items.map((e) => e.toJson()).toList(),
    };

    // Debug: Print the request body
    debugPrint('Order Request Body: ${json.encode(body)}');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create order: ${response.body}');
    }
  }
}

// Main Page
class MedicineOrderPage extends StatefulWidget {
  const MedicineOrderPage({super.key});

  @override
  State<MedicineOrderPage> createState() => _MedicineOrderPageState();
}

class _MedicineOrderPageState extends State<MedicineOrderPage> {
  final _searchController = TextEditingController();
  final _patientNameController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();
  final _patientIdController = TextEditingController();
  final _prescriptionRefController = TextEditingController();

  List<Medicine> _searchResults = [];
  List<OrderLineItem> _cartItems = [];
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  int _currentPage = 1;
  int _totalPages = 1;

  @override
  void dispose() {
    _searchController.dispose();
    _patientNameController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    _patientIdController.dispose();
    _prescriptionRefController.dispose();
    super.dispose();
  }

  Future<void> _searchMedicines({bool resetPage = true}) async {
    if (resetPage) _currentPage = 1;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await MedicineApiService.searchMedicines(
        searchTerm: _searchController.text,
        page: _currentPage,
        limit: 20,
      );

      setState(() {
        _searchResults = (result['data'] as List).map((e) => Medicine.fromJson(e)).toList();
        final pagination = result['pagination'];
        _totalPages = pagination['totalPages'] ?? 1;
        _isLoading = false;
      });

      // Debug: Print parsed medicines
      for (var med in _searchResults) {
        debugPrint('Parsed Medicine - ID: ${med.medicineId}, Name: ${med.name}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _addToCart(Medicine medicine) {
    // Debug: Verify medicineId before adding
    debugPrint('Adding to cart - Medicine ID: ${medicine.medicineId}, Name: ${medicine.name}');

    if (medicine.medicineId.isEmpty) {
      _showError('Error: Medicine ID is missing');
      return;
    }

    final existingIndex = _cartItems.indexWhere((e) => e.medicineId == medicine.medicineId);
    
    setState(() {
      if (existingIndex >= 0) {
        _cartItems[existingIndex].quantity++;
      } else {
        _cartItems.add(OrderLineItem(
          medicineId: medicine.medicineId,
          name: medicine.name,
          quantity: 1,
          unitCost: medicine.price,
        ));
      }
    });

    // Debug: Print cart items
    debugPrint('Cart Items: ${_cartItems.map((e) => 'ID: ${e.medicineId}, Name: ${e.name}').toList()}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${medicine.name} added to cart'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _updateCartItemQuantity(int index, int delta) {
    setState(() {
      _cartItems[index].quantity += delta;
      if (_cartItems[index].quantity <= 0) {
        _cartItems.removeAt(index);
      }
    });
  }

  void _removeFromCart(int index) {
    setState(() => _cartItems.removeAt(index));
  }

  double get _totalAmount => _cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  Future<void> _submitOrder() async {
    if (_cartItems.isEmpty) {
      _showError('Please add at least one medicine to the order');
      return;
    }
    if (_patientNameController.text.isEmpty) {
      _showError('Patient name is required');
      return;
    }
    if (_contactController.text.isEmpty) {
      _showError('Contact number is required');
      return;
    }

    // Validate all cart items have medicineId
    for (var item in _cartItems) {
      if (item.medicineId.isEmpty) {
        _showError('Error: One or more items missing Medicine ID');
        return;
      }
    }

    setState(() => _isSubmitting = true);

    try {
      final result = await MedicineApiService.createOrder(
        patientName: _patientNameController.text,
        contactNumber: _contactController.text,
        shippingAddress: _addressController.text,
        patientId: _patientIdController.text,
        prescriptionRef: _prescriptionRefController.text,
        items: _cartItems,
      );

      if (mounted) {
        _showSuccessDialog(result);
        _clearForm();
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _clearForm() {
    setState(() {
      _cartItems.clear();
      _patientNameController.clear();
      _contactController.clear();
      _addressController.clear();
      _patientIdController.clear();
      _prescriptionRefController.clear();
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessDialog(Map<String, dynamic> result) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Order Created'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Receipt ID: ${result['data']['receiptId'] ?? result['data']['receiptid']}'),
            const SizedBox(height: 8),
            Text('Total: Rs. ${(result['data']['totalAmount'] ?? 0).toStringAsFixed(2)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Order'),
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => _showCartBottomSheet(),
              ),
              if (_cartItems.isNotEmpty)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${_cartItems.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchSection(),
          Expanded(child: _buildSearchResults()),
        ],
      ),
      floatingActionButton: _cartItems.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _showCartBottomSheet(),
              icon: const Icon(Icons.shopping_cart_checkout),
              label: Text('Rs. ${_totalAmount.toStringAsFixed(2)}'),
            )
          : null,
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search medicines...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: (_) => _searchMedicines(),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _isLoading ? null : () => _searchMedicines(),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Search', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(_errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _searchMedicines, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty && !_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medication_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Search for medicines to add to order', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _searchResults.length,
            itemBuilder: (ctx, i) => _buildMedicineCard(_searchResults[i]),
          ),
        ),
        if (_totalPages > 1) _buildPagination(),
      ],
    );
  }

  Widget _buildMedicineCard(Medicine medicine) {
    final isInCart = _cartItems.any((e) => e.medicineId == medicine.medicineId);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.medication, color: Colors.blue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(medicine.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  // Show medicine ID for debugging
                  Text('ID: ${medicine.medicineId}', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                  Text('${medicine.category} • ${medicine.form}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('Rs. ${medicine.price.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.green)),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: medicine.stockQuantity > 0 ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          medicine.stockQuantity > 0 ? 'In Stock: ${medicine.stockQuantity}' : 'Out of Stock',
                          style: TextStyle(fontSize: 12, color: medicine.stockQuantity > 0 ? Colors.green : Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: medicine.stockQuantity > 0 ? () => _addToCart(medicine) : null,
              icon: Icon(isInCart ? Icons.add_circle : Icons.add_circle_outline,
                  color: medicine.stockQuantity > 0 ? Colors.blue : Colors.grey),
              tooltip: 'Add to cart',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _currentPage > 1
                ? () {
                    _currentPage--;
                    _searchMedicines(resetPage: false);
                  }
                : null,
            icon: const Icon(Icons.chevron_left),
          ),
          Text('Page $_currentPage of $_totalPages'),
          IconButton(
            onPressed: _currentPage < _totalPages
                ? () {
                    _currentPage++;
                    _searchMedicines(resetPage: false);
                  }
                : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  void _showCartBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, controller) => _buildCartSheet(controller),
      ),
    );
  }

  Widget _buildCartSheet(ScrollController controller) {
    return StatefulBuilder(
      builder: (ctx, setSheetState) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shopping_cart),
                  const SizedBox(width: 12),
                  const Text('Order Cart', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(16),
                children: [
                  const Text('Patient Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  _buildTextField(_patientNameController, 'Patient Name *', Icons.person),
                  _buildTextField(_contactController, 'Contact Number *', Icons.phone),
                  _buildTextField(_addressController, 'Shipping Address', Icons.location_on),
                  _buildTextField(_patientIdController, 'Patient ID (Optional)', Icons.badge),
                  _buildTextField(_prescriptionRefController, 'Prescription Ref (Optional)', Icons.description),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text('Cart Items', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Spacer(),
                      Text('${_cartItems.length} items', style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_cartItems.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      child: const Column(
                        children: [
                          Icon(Icons.shopping_cart_outlined, size: 48, color: Colors.grey),
                          SizedBox(height: 12),
                          Text('Cart is empty', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  else
                    ..._cartItems.asMap().entries.map((e) => _buildCartItem(e.key, e.value, setSheetState)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(ctx).colorScheme.surface,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, -2))],
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Amount', style: TextStyle(fontSize: 16)),
                        Text('Rs. ${_totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting || _cartItems.isEmpty ? null : () {
                          Navigator.pop(ctx);
                          _submitOrder();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Place Order', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildCartItem(int index, OrderLineItem item, StateSetter setSheetState) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  // Show medicine ID in cart for verification
                  Text('ID: ${item.medicineId}', style: TextStyle(color: Colors.grey[500], fontSize: 10)),
                  const SizedBox(height: 2),
                  Text('Rs. ${item.unitCost.toStringAsFixed(2)} each', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    _updateCartItemQuantity(index, -1);
                    setSheetState(() {});
                    setState(() {});
                  },
                  icon: const Icon(Icons.remove_circle_outline),
                  iconSize: 20,
                ),
                Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () {
                    _updateCartItemQuantity(index, 1);
                    setSheetState(() {});
                    setState(() {});
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  iconSize: 20,
                ),
              ],
            ),
            const SizedBox(width: 8),
            Text('Rs. ${item.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            IconButton(
              onPressed: () {
                _removeFromCart(index);
                setSheetState(() {});
                setState(() {});
              },
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              iconSize: 20,
            ),
          ],
        ),
      ),
    );
  }
}