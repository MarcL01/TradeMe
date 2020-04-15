import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LoginBackgroundPainter(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              //logo
              Spacer(),
              Text(
                "TradeMe",
                style: TextStyle(fontSize: 35.0),
              ),
              Spacer(),
              Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                margin: EdgeInsets.all(40.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 30.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Login Account",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0,
                        ),
                      ),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration:
                            InputDecoration(labelText: "Username or E-mail"),
                      ),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(labelText: "Password"),
                      ),
                      MaterialButton(
                        child: Text("Login"),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        onPressed: () {
                          print("Pressed login");
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Text("Don't have an account?"),
              FlatButton(
                onPressed: () {
                  print("Pressed register");
                },
                child: Text("Register"),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;

    Paint paint = Paint();
    paint.color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);

    LinearGradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight, // 10% of the width, so there are ten blinds.
      colors: [
        const Color(0xFF00FFFF),
        const Color(0xFF85FF7A)
      ], // whitish to gray/ repeats the gradient over the canvas
    );

    Path circle = Path();
    circle.moveTo(0, 0);
    circle.lineTo(0, height * .45);
    circle.quadraticBezierTo(width * .5, height * .5, width, height * .45);
    circle.lineTo(width, 0);
    circle.close();
    Paint gPaint = Paint();
    gPaint.shader =
        gradient.createShader(Rect.fromLTWH(0, 0, width, height * .7));
    canvas.drawPath(circle, gPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
