import 'package:flutter/material.dart';


class Product {
  const Product({required this.id, required this.name, required this.price});

  final int id;
  final String name;
  final int price;
}

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => ProductListPageState();
}

class ProductListPageState extends State<ProductListPage> {
  // 模拟“服务端全量数据”，每次只展示前 10 条
  final List<Product> _allProducts = List.generate(
    50,
    (i) => Product(id: i + 1, name: '商品 ${i + 1}', price: 100 + i * 10),
  );
  List<Product> _products = [];
  bool _loading = false;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _products = _allProducts.take(10).toList();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _products = _allProducts.take(10).toList();
    });
  }

  void _loadMore() {
    if (_loading || _products.length >= _allProducts.length) return;
    setState(() => _loading = true);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        final next = _products.length + 10;
        _products = _allProducts.take(next).toList();
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('商品列表')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _products.length + (_loading ? 1 : 0),
          itemBuilder: (context, index) {
            // 最后一条是“加载中”的占位
            if (index >= _products.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final product = _products[index];
            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.shopping_bag)),
              title: Text(product.name),
              subtitle: Text('¥${product.price}'),
              trailing: const Icon(Icons.chevron_right),
            );
          },
        ),
      ),
    );
  }
}