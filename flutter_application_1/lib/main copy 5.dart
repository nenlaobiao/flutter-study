import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

// ============================================================
// 1. App
// ============================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '商品列表',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const ProductPage(),
    );
  }
}

// ============================================================
// 2. 商品数据模型
// ============================================================

class Product {
  final int id;
  final String name;
  final double price;
  final String description;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
  });
}

// ============================================================
// 3. Mock API
//
// 实际项目这里一般会变成：
//
// Future<ProductPageResult> getProducts(int page) async {
//   final response = await request.get('/products', params: {
//     'page': page,
//     'pageSize': 10,
//   });
//
//   return ProductPageResult.fromJson(response.data);
// }
//
// 现在我们先模拟网络请求。
// ============================================================
class ProductApi {
  // JSONPlaceholder 提供的测试接口
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  static const int pageSize = 10;

  static Future<List<Product>> getProducts(int page) async {
    // 页码从 1 开始
    final start = (page - 1) * pageSize;

    // 拼接请求地址
    final uri = Uri.parse('$baseUrl/posts?_start=$start&_limit=$pageSize');

    // 发起 GET 请求
    final response = await http.get(uri);

    // HTTP 状态码 200 表示请求成功
    if (response.statusCode != 200) {
      throw Exception('请求失败：${response.statusCode}');
    }

    // response.body 是服务器返回的 JSON 字符串
    final List<dynamic> jsonList = jsonDecode(response.body);

    // JSON → Product
    return jsonList.map((json) {
      return Product(
        id: json['id'],
        name: json['title'],
        price: 19.9,
        description: json['body'],
      );
    }).toList();
  }
}

// ============================================================
// 4. 商品列表页面
// ============================================================

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // ----------------------------------------------------------
  // 列表数据
  //
  // 实际项目中：
  // List<Product> 就相当于你 Vue/React 中的响应式列表数据。
  // ----------------------------------------------------------

  final List<Product> _products = [];

  // 当前页
  int _page = 1;

  // 是否正在刷新
  bool _refreshing = false;

  // 是否正在加载下一页
  bool _loadingMore = false;

  // 是否已经没有更多数据
  bool _hasMore = true;

  // ScrollController 用来监听列表滚动位置
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // 页面创建完成之后，监听滚动事件
    _scrollController.addListener(_onScroll);

    // 第一次进入页面，加载第一页
    _loadFirstPage();
  }

  // ==========================================================
  // 监听滚动
  // ==========================================================

  void _onScroll() {
    // 当前滚动位置
    final position = _scrollController.position;

    // position.maxScrollExtent：
    // 列表最多可以滚到哪里
    //
    // position.pixels：
    // 当前已经滚了多少
    //
    // 当距离底部只剩 200 像素时，
    // 就开始加载下一页。
    if (position.pixels >= position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  // ==========================================================
  // 第一次加载 / 下拉刷新
  // ==========================================================

  Future<void> _loadFirstPage() async {
    // 防止重复刷新
    if (_refreshing) {
      return;
    }

    setState(() {
      _refreshing = true;
    });

    try {
      final products = await ProductApi.getProducts(1);

      if (!mounted) {
        return;
      }

      setState(() {
        // 刷新时要把旧数据替换掉
        _products
          ..clear()
          ..addAll(products);

        _page = 1;

        // 第一页不足 pageSize，说明没有更多了
        _hasMore = products.length == ProductApi.pageSize;
      });
    } catch (e) {
      // 实际项目这里一般 Toast / SnackBar 提示错误
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('刷新失败：$e')));
    } finally {
      if (!mounted) {
        return;
      }

      setState(() {
        _refreshing = false;
      });
    }
  }

  // ==========================================================
  // 加载下一页
  // ==========================================================

  Future<void> _loadMore() async {
    // --------------------------------------------------------
    // 这几个判断非常重要
    //
    // 触底事件可能会连续触发很多次。
    //
    // 如果不判断 _loadingMore：
    //
    // page 2
    // page 2
    // page 2
    // page 2
    //
    // 可能同时发出去多个请求。
    // --------------------------------------------------------

    if (_loadingMore) {
      return;
    }

    // 已经没有更多数据了
    if (!_hasMore) {
      return;
    }

    setState(() {
      _loadingMore = true;
    });

    try {
      // 下一页
      final nextPage = _page + 1;

      final products = await ProductApi.getProducts(nextPage);

      if (!mounted) {
        return;
      }

      setState(() {
        // 触底加载：
        // 不是替换，而是追加
        _products.addAll(products);

        // 更新当前页
        _page = nextPage;

        // 如果返回数量小于 pageSize，
        // 通常说明已经到最后一页。
        if (products.length < ProductApi.pageSize) {
          _hasMore = false;
        }
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('加载失败：$e')));
    } finally {
      if (!mounted) {
        return;
      }

      setState(() {
        _loadingMore = false;
      });
    }
  }

  // ==========================================================
  // 页面销毁
  // ==========================================================

  @override
  void dispose() {
    // 不再使用 ScrollController 时一定要释放
    _scrollController.dispose();

    super.dispose();
  }

  // ==========================================================
  // UI
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('商品列表')),

      body: RefreshIndicator(
        // 下拉刷新触发的方法
        onRefresh: _loadFirstPage,

        // ------------------------------------------------------
        // AlwaysScrollableScrollPhysics 很重要
        //
        // 如果只有很少的数据，列表可能不足一屏。
        //
        // 普通 ListView 可能没有足够的滚动距离，
        // 这时候下拉刷新可能无法触发。
        //
        // AlwaysScrollableScrollPhysics：
        // 即使内容不足一屏，也允许进行滚动手势。
        // ------------------------------------------------------
        child: ListView.builder(
          controller: _scrollController,

          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),

          // ----------------------------------------------------
          // itemCount：
          //
          // 商品数量
          //
          // 如果正在加载下一页，
          // 我们额外增加一个 item 用来显示 Loading。
          // ----------------------------------------------------
          itemCount: _products.length + (_loadingMore ? 1 : 0),

          itemBuilder: (context, index) {
            // --------------------------------------------------
            // 最后一个 item 专门显示加载状态
            // --------------------------------------------------

            if (index == _products.length) {
              return _buildLoadMoreIndicator();
            }

            final product = _products[index];

            return _buildProductItem(product);
          },
        ),
      ),
    );
  }

  // ==========================================================
  // 商品 Item
  // ==========================================================

  Widget _buildProductItem(Product product) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 商品图片占位
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.shopping_bag,
                color: Colors.green[700],
                size: 32,
              ),
            ),

            const SizedBox(width: 12),

            // 商品信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    product.description,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '¥${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // 底部 Loading
  // ==========================================================

  Widget _buildLoadMoreIndicator() {
    // 还有更多数据
    if (_hasMore) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // 没有更多数据
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Text('没有更多数据了', style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}
