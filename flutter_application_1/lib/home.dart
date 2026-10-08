import 'package:flutter/material.dart';
import 'package:flutter_application_1/goodslist.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class FormData {
  final String account;
  final String password;

  FormData({required this.account, required this.password});

  Map<String, dynamic> toJson() {
    return {'account': account, 'password': password};
  }

  @override
  String toString() {
    return 'FormData:{account: $account, password: $password}';
  }
}

class _LoginPageState extends State<LoginPage> {
  final _fromKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  bool _obscure = true;

  String? _account;
  String? _password;
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('登录')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _fromKey,
          child: Column(
            children: [
              FormField<String>(
                initialValue: '',
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return '账号至少为6位';
                  }
                  return null;
                },
                onSaved: (newValue) => _account = newValue,
                builder: (field) {
                  return TextField(
                    controller: _textController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '账号',
                      hintText: '请输入您的账号',
                      prefixIcon: Icon(Icons.account_box),
                      errorText: field.errorText,
                      suffixIcon: field.value!.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                field.didChange('');
                                _textController.clear();
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) => field.didChange(value),
                  );
                },
              ),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 8),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '密码',
                    hintText: '请输入您的密码',
                    prefixIcon: Icon(Icons.password),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscure = !_obscure;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return '密码至少为6位';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _password = newValue,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (!_fromKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.redAccent,
                        content: Text('请在完成表单后再次重试'),
                      ),
                    );
                    return;
                  }
                  _fromKey.currentState!.save(); 
                  FormData formData = FormData(
                    account: _account!,
                    password: _password!,
                  );
                  print('表单提交===>$formData');
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductListPage()));
                },
                child: SizedBox(
                  width: 100,
                  child: Text('提交', textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
