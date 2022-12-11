import 'package:denlee_app/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/user_controller.dart';
import '../models/api_response.dart';
import '../models/user.dart';

class Login extends StatefulWidget{
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPwd = TextEditingController();
  bool loading = false;

  Future<void> _loginUser() async {
    ApiResponse response = await login(txtEmail.text, txtPwd.text);

    if(response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Dashboard()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final double height= MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Color(0xFF10ac84),
        body: Container(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Form(
            key: formkey, //key for form
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height:height*0.04),
                Text("Welcome to Denlee App", style: TextStyle(fontSize: 30, color:Colors.white),),
                Text("Please Login !", style: TextStyle(fontSize: 30, color:Colors.white),),
                SizedBox(height: height*0.05,),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: txtEmail,
                  validator: (val) => val!.isEmpty ? 'Invalid email address' : null,
                  decoration: InputDecoration(
                    labelText: "Email",
                    contentPadding: EdgeInsets.all(25),
                    border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black)),
                    prefixIcon: Icon(Icons.mail),
                    enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none),
                    fillColor: Color(0xFF218c74),
                    filled: true,
                  ),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: height*.05,),
                TextFormField(
                  controller: txtPwd,
                  obscureText: true,
                  validator: (val) => val!.length < 6 ? 'Password is required' : null,
                  decoration: InputDecoration(
                    labelText: "Password",
                    contentPadding: EdgeInsets.all(25),
                    border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.white)),
                    prefixIcon: Icon(Icons.lock),
                    enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none),
                    fillColor: Color(0xFF218c74),
                    filled: true,
                  ),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: height*.05,),
                  ElevatedButton(
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                          _loginUser();
                        });
                      }

                      // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Dashboard()), (route) => false);
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 24),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: StadiumBorder(),
                      backgroundColor: Color(0xFF218c74),
                    ),
                )
              ],
            ),
          ),
        )
    );
  }
}