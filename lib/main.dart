
import 'package:flutter/material.dart';

void main() {
  runApp(const MyStoreSeller());
}

class MyStoreSeller extends StatelessWidget {
  const MyStoreSeller({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyStore Seller',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2563EB),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),
      home: const SellerHome(),
    );
  }
}

class Product {
  String name;
  String description;
  double price;
  int quantity;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
  });
}

class SellerHome extends StatefulWidget {
  const SellerHome({super.key});

  @override
  State<SellerHome> createState() => _SellerHomeState();
}

class _SellerHomeState extends State<SellerHome> {
  int selectedIndex = 0;
  final List<Product> products = [];
  final List<Map<String, String>> orders = [];

  void addProduct(Product product) {
    setState(() => products.add(product));
  }

  void deleteProduct(int index) {
    setState(() => products.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'MyStore Seller',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none),
            ),
          ],
        ),
        body: IndexedStack(
          index: selectedIndex,
          children: [
            dashboard(),
            productsPage(),
            ordersPage(),
          ],
        ),
        floatingActionButton: selectedIndex == 1
            ? FloatingActionButton.extended(
                onPressed: openAddProduct,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'إضافة منتج',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: const Color(0xFF2563EB),
              )
            : null,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            setState(() => selectedIndex = index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.inventory_2_outlined),
              label: 'المنتجات',
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_bag_outlined),
              label: 'الطلبات',
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboard() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text(
          'مرحباً بك في متجرك 👋',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'إليك ملخص متجرك اليوم',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: statCard(
                'المنتجات',
                '${products.length}',
                Icons.inventory_2,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: statCard(
                'الطلبات',
                '${orders.length}',
                Icons.shopping_bag,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
        const Text(
          'الوصول السريع',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 14),
        quickButton(
          'إضافة منتج جديد',
          Icons.add_box_outlined,
          () {
            setState(() => selectedIndex = 1);
            openAddProduct();
          },
        ),
        const SizedBox(height: 12),
        quickButton(
          'مشاهدة المنتجات',
          Icons.storefront_outlined,
          () => setState(() => selectedIndex = 1),
        ),
        const SizedBox(height: 12),
        quickButton(
          'مشاهدة الطلبات',
          Icons.receipt_long_outlined,
          () => setState(() => selectedIndex = 2),
        ),
      ],
    );
  }

  Widget statCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 15),
          Text(
            value,
            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget quickButton(
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF2563EB)),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget productsPage() {
    if (products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 65, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'لا توجد منتجات حالياً',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Text('اضغط على إضافة منتج لبدء متجرك'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];

        return Card(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFE8F0FF),
              child: Icon(Icons.shopping_bag, color: Colors.blue),
            ),
            title: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${product.price.toStringAsFixed(2)} د.ت  •  الكمية: ${product.quantity}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => deleteProduct(index),
            ),
          ),
        );
      },
    );
  }

  Widget ordersPage() {
    if (orders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 65, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'لا توجد طلبات حتى الآن',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];

        return Card(
          color: Colors.white,
          child: ListTile(
            leading: const Icon(Icons.receipt_long),
            title: Text(order['name'] ?? ''),
            subtitle: Text(order['phone'] ?? ''),
          ),
        );
      },
    );
  }

  void openAddProduct() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('إضافة منتج جديد'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'اسم المنتج',
                      prefixIcon: Icon(Icons.shopping_bag),
                    ),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'وصف المنتج',
                      prefixIcon: Icon(Icons.description),
                    ),
                  ),
                  TextField(
                    controller: priceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'السعر بالدينار',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                  TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'الكمية',
                      prefixIcon: Icon(Icons.numbers),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  final price = double.tryParse(priceController.text);
                  final quantity = int.tryParse(quantityController.text);

                  if (name.isEmpty ||
                      price == null ||
                      price < 0 ||
                      quantity == null ||
                      quantity < 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تحقق من الاسم والسعر والكمية'),
                      ),
                    );
                    return;
                  }

                  addProduct(
                    Product(
                      name: name,
                      description: descriptionController.text.trim(),
                      price: price,
                      quantity: quantity,
                    ),
                  );

                  Navigator.pop(dialogContext);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تمت إضافة المنتج بنجاح'),
                    ),
                  );
                },
                child: const Text('حفظ المنتج'),
              ),
            ],
          ),
        );
      },
    );
  }
}
