import 'package:flutter/material.dart';

void main() {
  runApp(const ShoppingApp());
}

class ShoppingApp extends StatelessWidget {
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '商城首页',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('商城首页'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 顶部分类导航：Row + spaceAround
          const CategoryBar(),
          // 商品网格：Expanded 撑满剩余高度，GridView 自身可滚动
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(12),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: const [
                ProductCard(title: '无线蓝牙耳机', price: 199, color: Colors.blue),
                ProductCard(title: '机械键盘', price: 459, color: Colors.green),
                ProductCard(title: '智能手表', price: 899, color: Colors.orange),
                ProductCard(title: '便携充电宝', price: 129, color: Colors.purple),
                ProductCard(title: '降噪头戴耳机', price: 1299, color: Colors.teal),
                ProductCard(title: '4K 显示器', price: 1999, color: Colors.indigo),
                ProductCard(title: '4K 显示器1', price: 1999, color: Colors.indigo),
                ProductCard(title: '4K 显示器2', price: 1999, color: Colors.indigo),
                ProductCard(title: '4K 显示器3', price: 1999, color: Colors.indigo),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryBar extends StatelessWidget {
  const CategoryBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      color: Colors.white,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('推荐'),
          Text('手机'),
          Text('电脑'),
          Text('家电'),
          Text('更多'),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.color,
  });

  final String title;
  final int price;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 商品图区域：Expanded 撑满卡片上方剩余空间 + Stack 叠角标
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(color: color),
                const Positioned(
                  top: 8,
                  right: 8,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        '热卖',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 标题 + 价格：Row + Expanded + ellipsis 处理超长标题
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '¥$price',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}