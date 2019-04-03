import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class Controllers {
  final TextEditingController ageController;
  final TextEditingController weightController;
  final TextEditingController heightController;

  Controllers()
      : ageController = TextEditingController(),
        weightController = TextEditingController(),
        heightController = TextEditingController();
}

class _MainPageState extends State<MainPage> {
  final _controllers = Controllers();
  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    void buttonPress() {
      setState(() {
        if (_key.currentState.validate()) {
          _showDialog(
              context,
              calculateBmi(double.parse(_controllers.heightController.text),
                  double.parse(_controllers.weightController.text)));
        }
      });
    }

    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(0, 60),
        child: MyAppBar(),
      ),
      body: GestureDetector(
        onTap: () {},
        child: Container(
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/measure.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.transparent.withOpacity(0.2), BlendMode.dstIn),
            ),
          ),
          child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    top: _height / 8, left: _width / 20, right: _width / 20),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                height: _height * 2 / 3,
                width: _width * 2 / 3,
                child: Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      MyTextBox(
                        controller: _controllers.ageController,
                        iconData: Icons.person,
                        labelText: 'Age',
                      ),
                      MyTextBox(
                        controller: _controllers.heightController,
                        iconData: Icons.insert_chart,
                        labelText: 'Height(0.0m)',
                      ),
                      MyTextBox(
                        controller: _controllers.weightController,
                        iconData: Icons.line_weight,
                        labelText: 'Weight(kg)',
                      ),
                      RaisedButton(
                        onPressed: () {
                          buttonPress();
                        },
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        color: Colors.blue.shade600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          'Calculate',
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'bmi calculator',
        style: TextStyle(
            color: Colors.white,
            fontSize: 50,
            letterSpacing: 3,
            wordSpacing: 4,
            fontWeight: FontWeight.w300,
            fontFamily: 'Bola'),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.blue.shade800,
      leading: Image.asset('images/calculate.png'),
      elevation: 0,
    );
  }
}

class MyTextBox extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData iconData;
  MyTextBox({this.controller, this.labelText, this.iconData});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value.isEmpty || !isNumeric(value)) {
            return 'Please enter a valid number.';
          }
        },
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: labelText,
          icon: Icon(
            iconData,
            size: 30,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.parse(s, (e) => null) != null;
}

void _showDialog(context, double bmi) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Your Body Index',
            style: TextStyle(fontSize: 30),
          ),
          content: RichText(
            text: TextSpan(
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
              children: <TextSpan>[
                TextSpan(text: 'Your body index is:  \t'),
                TextSpan(
                    text: '${bmi.toStringAsFixed(2)} \n',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                TextSpan(text: 'Your status :   \t'),
                TextSpan(
                    text: '${getStatus(bmi).toString().split('.').last}',
                    style: TextStyle(
                        color: getColor(getStatus(bmi)),
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Colors.green,
                child: Text(
                  'Okay',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ))
          ],
        );
      });
}

Color getColor(enStatus status) {
  if (status == enStatus.underweight || status == enStatus.obese) {
    return Colors.redAccent;
  } else if (status == enStatus.healthy) {
    return Colors.greenAccent;
  } else {
    return Colors.amber;
  }
}

enStatus getStatus(double bmi) {
  if (bmi < 18.5) {
    return enStatus.underweight;
  } else if (bmi < 25) {
    return enStatus.healthy;
  } else if (bmi < 30) {
    return enStatus.overweight;
  } else {
    return enStatus.obese;
  }
}

enum enStatus { underweight, healthy, overweight, obese }

double calculateBmi(double height, double weight) {
  return weight / (height * height);
}
