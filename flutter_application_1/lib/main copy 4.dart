import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List userList = [
    {'name': '张三', 'age': '18'},
    {'name': '李四', 'age': '28'},
    {'name': '王二', 'age': '18'},
    {'name': '麻子', 'age': '18'},
    {'name': '王五', 'age': '18'},
    {'name': '王六', 'age': '18'},
    {'name': '张柳', 'age': '18'},
    {'name': '小名', 'age': '18'},
    {'name': '小黄', 'age': '18'},
    {'name': '小明', 'age': '18'},
  ];
  List listA = [
    {'name': '胡图图', 'age': '18'},
    {'name': '胡英俊', 'age': '18'},
    {'name': '张小龙', 'age': '18'},
    {'name': '张晓丽', 'age': '18'},
    {'name': '壮壮妈', 'age': '18'},
    {'name': '李小龙', 'age': '18'},
    {'name': '鞋子', 'age': '18'},
    {'name': '铲子', 'age': '18'},
    {'name': '牛子', 'age': '18'},
    {'name': '奶子', 'age': '18'},
  ];
  Future<void> _refresh() async {
    // 模拟请求 1 秒
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // 重新拉取 / 重置数据
      userList = [...listA];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('用户列表'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 10.0),
          child: ListView.separated(
            physics: BouncingScrollPhysics(), // 滚动规则
            itemCount: userList.length,
            separatorBuilder: (context, index) => const Divider(
              color: Color(0xEEEEEEEE),
              indent: 10.0,
              endIndent: 10.0,
            ),
            itemBuilder: (context, index) {
              var data = userList[index];
              return Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(230, 230, 230, .3),
                  borderRadius: BorderRadius.all(Radius.elliptical(10, 5)),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text('用户 ${data['name']}  年龄: ${data['age']}'),
                  subtitle: Text('这是第 $index 个用户'),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(230, 230, 230, .3)),
        padding: const EdgeInsets.all(10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          onPressed: () => {
            setState(() {
              userList.addAll([...listA]);
            }),
          },
          child: Text('你好'),
        ),
      ),
    );
  }
}
