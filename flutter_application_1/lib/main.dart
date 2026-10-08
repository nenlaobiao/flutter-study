import 'package:flutter/material.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: ShopApp()));
}

final cartProvider = NotifierProvider<CartNotifier, Map<int, int>>(
  CartNotifier.new,
);

class CartNotifier extends Notifier<Map<int, int>> {
  @override
  Map<int, int> build() => {};
  void add(int productId) {
    state = {...state, productId: (state[productId] ?? 0) + 1};
  }
}

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '商城 Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const MainTabsPage(),
    );
  }
}

class Product {
  const Product({required this.id, required this.name, required this.price});

  final int id;
  final String name;
  final int price;
}

// 主框架：底部三个 tab，用 IndexedStack 保持各页状态
class MainTabsPage extends ConsumerStatefulWidget {
  const MainTabsPage({super.key});

  @override
  ConsumerState<MainTabsPage> createState() => _MainTabsPageState();
}

class _MainTabsPageState extends ConsumerState<MainTabsPage> {
  int _currentIndex = 0;

  static const List<Widget> _pages = [
    ProductListPage(),
    CartPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final totalCount = cart.values.fold(0, (sum, count) => sum + count);
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(
            icon: Badge(label: Text('$totalCount'),child:  Icon(Icons.shopping_cart),),
            label: '购物车',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
        ],
      ),
    );
  }
}

// 首页：商品列表，点击进详情
class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  static const List<Product> products = [
    Product(id: 1, name: '无线蓝牙耳机', price: 199),
    Product(id: 2, name: '机械键盘', price: 459),
    Product(id: 3, name: '智能手表', price: 899),
    Product(id: 4, name: '便携充电宝', price: 129),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('商品列表')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.shopping_bag)),
            title: Text(product.name),
            subtitle: Text('¥${product.price}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              // 跳转并等待详情页带回的结果
              final result = await Navigator.push<String>(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(product: product),
                ),
              );
              if (result != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product.name} $result')),
                );
              }
            },
          );
        },
      ),
    );
  }
}

// 详情页：接收 Product，点按钮 pop 带回结果
class DetailPage extends ConsumerWidget {
  const DetailPage({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('商品 ID:${product.id}'),
            const SizedBox(height: 8),
            Text(
              product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '¥${product.price}',
              style: const TextStyle(color: Colors.red, fontSize: 20),
            ),
            Text(
              cart.containsKey(product.id) && cart[product.id] != 0
                  ? '已经加入购物车'
                  : '未添加购物车',
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () {
                ref.read(cartProvider.notifier).add(product.id);
                // Navigator.pop(context, '已加入购物车');
              },
              child: const Text('加入购物车'),
            ),
          ],
        ),
      ),
    );
  }
}

// 购物车 tab：Day 5 会接入全局状态，今天先占位
class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});
  @override
  ConsumerState<CartPage> createState() => _CartPageStatre();
}

class _CartPageStatre extends ConsumerState<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final totalCount = cart.values.fold(0, (sum, count) => sum + count);
    return Scaffold(
      appBar: AppBar(title: Text('购物车')),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('购物车总数$totalCount'), Text('购物车（Day 5 接入状态管理）')],
        ),
      ),
    );
  }
}

// 我的 tab：占位
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('我的'),
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              child: const Text('登录'),
            ),
          ],
        ),
      ),
    );
  }
}
