import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navbar',
      home: const HomePage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('你好Flutter'),
        actions: [Icon(Icons.add)],
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: const [
                Expanded(child: Text('这是一个非常长的商品标题')),
                SizedBox(width: 8),
                Text('¥199'),
              ],
            ),
            Row(
              children: const [
                Flexible(child: Text('既不会撑爆，也不会被硬撑大')),
                SizedBox(width: 8),
                Text('¥199'),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '这是一个非常长的商品标题这是一个非常长的商品标题这是一个非常长的商品标题这是一个非常长的商品标题',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // 超出部分显示 …
                  ),
                ),
              ],
            ),

            Row(
              children: const [
                Expanded(flex: 2, child: Text('aaaaa')), // 占 2 份
                Expanded(flex: 1, child: Text('bbbbb')), // 占 1 份
              ],
            ),
          ],
        ),
      ),
    );
  }
}
