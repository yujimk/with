import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../services/screenAdaper.dart';
import '../../config/service_method.dart';
import '../widget/toast.dart';
import '../../services/storage.dart';
import '../bottom_tab/bottom.dart';
import '../../pages/widget/dialog.dart';



class SetpasswordPage extends StatefulWidget {
  @override
  _SetpasswordPageState createState() => _SetpasswordPageState();
}

class _SetpasswordPageState extends State<SetpasswordPage> {

  String _password = '';
  String _passwords = '';

  FocusNode _commentFocus = FocusNode();
  FocusNode _commentFocus1 = FocusNode();

  @override
  void initState() { 
    super.initState();
    
  }

  Timer time;
  void setpasswords() async{
    _commentFocus.unfocus();    // 失去焦点
    _commentFocus1.unfocus();    // 失去焦点
    RegExp reg = RegExp(r"^(?:(?=.*[a-zA-Z])(?=.*[0-9])).{6,30}$");
    if(reg.hasMatch(_password)){
      if(_password == _passwords){
        ProgressDialog.showProgress(context);
        var userinfo = await Storage.getString('userinfo');
        var _phone = json.decode(userinfo);
        print(_phone['Mobile']);
        apiMethod('setpwd', 'post', {'Account': _phone['Mobile'], 'Pwd': _password}).then((res){
          ProgressDialog.dismiss(context);
          if(res.data['IsSuccess']){
            // toast('设置成功！');
            // time = Timer(Duration(milliseconds:2000), (){
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => BottomPage()), (route) => route == null);
            // });
          }else{
            toast(res.data['Message']);
          }
          print(res);
        });
      }else{
        toast('两次密码输入不一致！');
      }
    }else{
      toast('密码至少6个字符，最多16个字符；必须包含数字和字母！');
    }
  }

  @override
  Widget build(BuildContext context) {

    ScreenAdaper.init(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Color(0xffFFFFFF),
        child: Stack(
          children: <Widget>[
            // 底部图片
            Positioned(
              bottom: 0.0, left: 0.0,
              child: Container(
                width: ScreenAdaper.width(750), height: ScreenAdaper.height(440),
                child: Image.asset('images/login_image01.png', fit: BoxFit.fill,),
              ),
            ),
            Container(
              padding: EdgeInsetsDirectional.fromSTEB(ScreenAdaper.width(60), 0, ScreenAdaper.width(60), 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: ScreenAdaper.height(98)),
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: ScreenAdaper.width(41), height: ScreenAdaper.width(35),
                      child: Image.asset('images/login_image05.png'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsetsDirectional.fromSTEB(0, ScreenAdaper.height(90), 0, ScreenAdaper.height(25)),
                    child: Text('设置密码', style: TextStyle(fontSize: ScreenAdaper.size(48), fontWeight: FontWeight.bold),),
                  ),
                  Text('完成密码设置即可注册成功啦！', style: TextStyle(fontSize: ScreenAdaper.size(24), color: Color(0xff7F7F7F)),),
                  SizedBox(height: ScreenAdaper.height(70),),
                  TextField(
                    focusNode: _commentFocus,
                    obscureText: true,
                    maxLength: 16, 
                    decoration: InputDecoration(
                      hintText: '请设置6〜16位密码',
                      contentPadding: EdgeInsetsDirectional.fromSTEB(0, ScreenAdaper.height(32), 0, ScreenAdaper.height(32)),
                    ),
                    onChanged: (value){
                      setState(() {
                        _password = value;
                      });
                    },
                  ),
                  TextField(
                    focusNode: _commentFocus1,
                    obscureText: true,
                    maxLength: 16,
                    decoration: InputDecoration(
                      hintText: '请再次输入密码',
                      contentPadding: EdgeInsetsDirectional.fromSTEB(0, ScreenAdaper.height(32), 0, ScreenAdaper.height(32)),
                    ),
                    onChanged: (value){
                      setState(() {
                        _passwords = value;
                      });
                    },
                  ),
                  SizedBox(height: ScreenAdaper.height(70),),
                  Opacity(
                    opacity: _password!='' && _passwords!='' ? 1 : 0.6,
                    child: InkWell(
                      onTap: setpasswords,
                      child: Container(
                        width: double.infinity, height: ScreenAdaper.height(96),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xffFF8636), Color(0xffFDAB29)]
                          ),
                          borderRadius: BorderRadius.circular(ScreenAdaper.width(60))
                        ),
                        child: Center(
                          child: Text('注册', style: TextStyle(fontSize: ScreenAdaper.size(32), color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
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
}
