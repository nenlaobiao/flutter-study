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
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }
  String inputText = '你号';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('用户列表'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.all(10),
            child: TextField(
              controller: _controller, // 读写输入内容（下一节讲）
              keyboardType: TextInputType.emailAddress, // 键盘类型
              obscureText: false, // 密码：输入显示为 ••••
              maxLines: 1, // 行数
              onChanged: (text) {
                setState(() {
                  inputText = text;
                });
              }, // 每输入一个字符都触发
              onSubmitted: (text) {}, // 按回车触发
              decoration: InputDecoration(
                labelText: '账号', // 浮动标签
                hintText: '请输入账号', // 占位提示
                prefixIcon: Icon(Icons.account_box), // 左边图标
                border: OutlineInputBorder(), // 边框
                suffixIcon: _controller.text.isNotEmpty? IconButton(
                  icon:  Icon(Icons.clear),
                  onPressed: (){
                    _controller.clear();
                  },
                ):null,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: '邮箱'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '请输入邮箱';
                      }
                      if (!value.contains('@')) {
                        return '邮箱格式不正确';
                      }
                      return null; // null = 校验通过
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print('验证通过');
                      } else {
                        print('验证失败');
                      }
                    },
                    child: const Text('登录'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(230, 230, 230, .3)),
        padding: const EdgeInsets.all(10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          onPressed: () => {},
          child: Text(inputText != '' ? inputText : '等待输入'),
        ),
      ),
    );
  }
}
