import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Day 1',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isFavorite = false;
  int _counter = 0;
  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void _tapBtn() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Day 1 收藏卡片'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: 140,
                  height: 140,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 48,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                      const SizedBox(height: 10),
                      Text(isFavorite ? '已收藏' : '未收藏'),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 120,
                        child: FilledButton(
                          onPressed: _toggleFavorite,
                          child: Text(isFavorite ? '取消收藏' : '收藏'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        FilledButton(
          onPressed: _tapBtn,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.add), Text('点击了$_counter次')],
          ),
        ),
      ],
    );
  }
}
