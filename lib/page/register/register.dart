import 'package:circle_coffee/page/login/login.dart';
import 'package:circle_coffee/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Register extends StatefulWidget {
  const Register({ Key? key }) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isLoading = false;
  final _namaController = TextEditingController();
  final _noTelpController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _isHidden = true;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bgsplash.png'),
            fit: BoxFit.fitHeight
            ) 
          ),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon : const Icon(
                CupertinoIcons.chevron_left_circle, 
                color: Color(0xFFFFC107),
              ),
              onPressed: (){
                Navigator.pop(context);
              },
              iconSize: 30,
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _namaController,
                  style: const TextStyle(fontFamily: 'sans serif'),
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                    prefixIcon: Icon(CupertinoIcons.person),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0x99FFC107)),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0x99FFC107)),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                    ),
                  ),
                ),
                const SizedBox(height: 16,),
                TextFormField(
                  controller: _noTelpController,
                  style: const TextStyle(fontFamily: 'sans serif'),
                  decoration: const InputDecoration(
                    labelText: 'No Telpon',
                    prefixIcon: Icon(CupertinoIcons.phone),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0x99FFC107)),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0x99FFC107)),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                    ),
                  ),
                ),
                const SizedBox(height: 16,),
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(fontFamily: 'sans serif'),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(CupertinoIcons.mail),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0x99FFC107)),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0x99FFC107)),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                    ),
                  ),
                ),
                const SizedBox(height: 16,),
                TextFormField(
                  controller: _passController,
                  style: const TextStyle(fontFamily: 'sans serif'),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(CupertinoIcons.lock),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0x99FFC107)),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0x99FFC107)),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                    ),
                    suffixIcon: InkWell(
                      onTap: _togglePasswordView,
                      child: Icon(
                        _isHidden ?
                        CupertinoIcons.eye_fill :
                        CupertinoIcons.eye_slash
                        )
                    )
                  ),
                  obscureText: _isHidden,
                ),
                const SizedBox(height: 16,),
                SizedBox(
                  width: double.infinity,
                  child: isLoading ? const Center(child: CircularProgressIndicator(),) : TextButton(
                    style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(20),
                            backgroundColor: const Color(0x44FFC107),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Color(0xFF000000),
                                width: 1,
                                style: BorderStyle.solid
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            // shape: StadiumBorder()
                          ),
                    onPressed: () async{  
                      setState(() {
                        isLoading = true;
                      });                   
                      final res = await ApiService().register(
                      nama: _namaController.text,
                      noTelp: _noTelpController.text,
                      email: _emailController.text,
                      password: _passController.text
                    );
                    
                    if (res['success']) {
                      Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Login())
                      );
                      Fluttertoast.showToast(
                        msg: res[
                            'message']);
                    }else{
                      setState(() {
                        isLoading = false;
                      });
                      Fluttertoast.showToast(
                        msg: res[
                            'message']);
                    }
                        
                    }, 
                    child: const Text(
                      "DAFTAR", 
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black
                      ),
                    )
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}