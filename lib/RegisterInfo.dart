import 'package:flutter/material.dart';
import 'api.dart';
import 'dart:convert';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'main.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _currentStep = 0;
  bool _passwordVisible1 = false;
  bool _passwordVisible2 = false;
  bool _isImperial = true;

  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _sexController = TextEditingController();
  // final _ageController = TextEditingController();
  final _dobmController = TextEditingController();
  final _dobyController = TextEditingController();
  final _majorController = TextEditingController();

  final _cmController = TextEditingController();
  final _feetController = TextEditingController();
  final _inchController = TextEditingController();
  final _kgController = TextEditingController();
  final _weightController = TextEditingController();

  final _racialBackgroundController = TextEditingController();
  final _firstGenController = TextEditingController();
  final _internationalController = TextEditingController();
  final _statusController = TextEditingController();
  final _yearController = TextEditingController();


  List<String> _selectedRacialBackgrounds = [];
  List<String> _selectedMajor = [];

  @override
  void initState() {
    super.initState();
    _emailController.text = '';
    _passwordController.text = '';
    _confirmPasswordController.text = '';
    _sexController.text = '';
    // _ageController.text = '';
    _dobmController.text = '';
    _dobyController.text = '';
    _majorController.text = '';

    _cmController.text = '';
    _feetController.text = '';
    _inchController.text = '';
    _kgController.text = '';
    _weightController.text = '';

    _racialBackgroundController.text = '';
    _firstGenController.text = '';
    _internationalController.text = '';
    _statusController.text = ''; 
    _yearController.text = '';   
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _sexController.dispose();
    // _ageController.dispose();
    _dobmController.dispose();
    _dobyController.dispose();
    _majorController.dispose();

    _cmController.dispose();
    _feetController.dispose();
    _inchController.dispose();
    _kgController.dispose();
    _weightController.dispose();

    _racialBackgroundController.dispose();
    _firstGenController.dispose();
    _internationalController.dispose();
    _statusController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _convertAndSubmit() {
    double heightInCm;
    double weightInKg;

    if (_isImperial) {
      // 将英尺和英寸转换为厘米
      double feet = double.tryParse(_feetController.text) ?? 0;
      double inches = double.tryParse(_inchController.text) ?? 0;
      heightInCm = (feet * 30.48) + (inches * 2.54);    

      _cmController.text = heightInCm.toStringAsFixed(2);

      // 将磅转换为公斤
      double weightLbs = double.tryParse(_weightController.text) ?? 0;
      weightInKg = weightLbs * 0.453592;
      _kgController.text = weightInKg.toStringAsFixed(2);
    }
    // } else {
    //   heightInCm = double.tryParse(_cmController.text) ?? 0;

    //   // 直接获取公斤的值
    //   weightInKg = double.tryParse(_kgController.text) ?? 0;
    // }
  }


  void _register() async {
    if (_formKeys[_currentStep].currentState?.validate() ?? false) {
      _convertAndSubmit();
      String email = _emailController.text;
      String password = _passwordController.text;
      String sex = _sexController.text;
      // int age = int.tryParse(_ageController.text) ?? 0;
      int dobm = int.tryParse(_dobmController.text) ?? 0;
      int doby = int.tryParse(_dobyController.text) ?? 0;
      // String major = _majorController.text;
      String major = _selectedMajor.join(',');
      double height = double.tryParse(_cmController.text) ?? 0;
      double weight = double.tryParse(_kgController.text) ?? 0;
      // double BMI = double.tryParse(_weightController.text) ?? 0.0;
      String racialBackground = _selectedRacialBackgrounds.join(',');
      // String racialBackground = _racialBackgroundController.text;
      String firstGen = _firstGenController.text;
      String international = _internationalController.text;
      // bool firstGen = _firstGenController.text.toLowerCase() == 'yes';
      // bool international = _internationalController.text.toLowerCase() == 'yes';
      String status = _statusController.text;
      String year = _yearController.text;

      double heightInMeters = height / 100.0; // 将身高转换为米
      double BMI = weight / (heightInMeters * heightInMeters); // 计算BMI

      final response = await Api.register(email, password, sex, dobm, doby, major, height, weight, BMI, 
          racialBackground, firstGen, international, status, year);

      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Registration Successful'),
            content: Text('Your account has been created successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => AuthPage()), // Replace with your main screen
                    (Route<dynamic> route) => false, // This removes all previous routes
                  );
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Handle registration error
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        String errorMessage = responseData['message'] ?? 'Unknown error';

        if (response.statusCode == 400 && errorMessage == 'Email already exists') {
          errorMessage = 'The email address is already in use. Please use a different email.';
        }

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Registration Failed'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }


  void _nextStep() {
    // if (_formKeys[_currentStep].currentState?.validate() ?? false) {
      setState(() {
        _currentStep += 1;
      });
      // print('Moved to step $_currentStep');
    // } else {
    //   print('Validation failed at step $_currentStep');
    // }
  }


  void _previousStep() {
    setState(() {
      _currentStep -= 1;
    });
    // print('Moved to step $_currentStep');
  }

  List<String> _getYearsBasedOnStatus(String status) {
    switch (status) {
      case 'Master':
        return ['1st year', '2nd year', 'Beyond 2nd year','N/A'];
      case 'Ph.D':
        return ['1st year', '2nd year', '3rd year', '4th year', '5th year', 'Beyond 5th year','N/A'];
      case 'Postdoc':
        return ['1st year', '2nd year', 'Beyond 2nd year','N/A'];
      case 'Others':
        return ['N/A'];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body:Column(
        children: [ 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0), // 水平和垂直方向分别设置
            child: Text(
              'All data will be used solely for research purposes and will not be disclosed or used for any other purposes.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          Expanded(
            child: 
            Stepper(
              type: StepperType.vertical,
              currentStep: _currentStep,

              onStepContinue: () {
                if (_currentStep == 2 || (_formKeys[_currentStep].currentState != null && _formKeys[_currentStep].currentState!.validate())) {
                  // print('Form validated successfully, moving to next step');
                  if (_currentStep < _formKeys.length - 1) {
                    setState(() {
                      _nextStep();
                    });
                  } else {
                    _register();
                  }
                } else {
                  // print('Form validation failed');
                }
              },

              onStepCancel: () {
                if (_currentStep > 0) {
                  _previousStep();
                }
              },
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                final isFirstStep = _currentStep == 0;
                final isLastStep = _currentStep == _formKeys.length - 1;
                
                return Row(
                  children: <Widget>[
                    if (!isLastStep)
                      ElevatedButton(
                        onPressed: details.onStepContinue,
                        child: Text('Next'),
                      ),
                    if (isLastStep)
                      ElevatedButton(
                        onPressed: details.onStepContinue,
                        child: Text('Finish'),
                      ),
                    if (!isFirstStep)
                      ElevatedButton(
                        onPressed: details.onStepCancel,
                        child: Text('Back'),
                      ),
                  ],
                );
              },
              steps: [
                Step(
                  title: Text('Account Info'),
                  content: Form(
                    key: _formKeys[0],
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password (At least 6 characters long)',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible1 ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible1 = !_passwordVisible1;
                                });
                              },
                            ),
                          ),
                          obscureText: !_passwordVisible1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible2 ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible2 = !_passwordVisible2;
                                });
                              },
                            ),
                          ),
                          obscureText: !_passwordVisible2,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: Text('Personal Info'),
                  content: Form(
                    key: _formKeys[1],
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: _sexController.text.isEmpty ? null : _sexController.text,
                          decoration: InputDecoration(labelText: 'Sex (At birth)'),
                          items: ['Male', 'Female', 'N/A'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _sexController.text = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your sex(as assigned at birth)';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        Align(alignment: Alignment.centerLeft,
                          child:Text( 
                            'Please select your birth month and year:',
                            textAlign: TextAlign.left,
                          ),
                        ),
                        // SizedBox(height: 8,),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _dobmController.text.isEmpty ? null : _dobmController.text,
                                decoration: InputDecoration(labelText: 'Month'),
                                items: [
                                  {'label': 'January', 'value': '1'},
                                  {'label': 'February', 'value': '2'},
                                  {'label': 'March', 'value': '3'},
                                  {'label': 'April', 'value': '4'},
                                  {'label': 'May', 'value': '5'},
                                  {'label': 'June', 'value': '6'},
                                  {'label': 'July', 'value': '7'},
                                  {'label': 'August', 'value': '8'},
                                  {'label': 'September', 'value': '9'},
                                  {'label': 'October', 'value': '10'},
                                  {'label': 'November', 'value': '11'},
                                  {'label': 'December', 'value': '12'},
                                ].map((Map<String, String> month) {
                                  return DropdownMenuItem<String>(
                                    value: month['value'],
                                    child: Text(month['label']!),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _dobmController.text = value!;
                                  });
                                },
                                validator: (value) {
                                  if (_dobmController.text.isEmpty && _currentStep == 1) {
                                    return 'Please select month';
                                  }
                                  return null;
                                },
                                menuMaxHeight: 350,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _dobyController.text.isEmpty ? null : _dobyController.text,
                                decoration: InputDecoration(labelText: 'Year'),
                                items: List.generate(75, (index) => (2024 - index).toString()).map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _dobyController.text = value!;
                                  });
                                },
                                validator: (value) {
                                  if (_dobyController.text.isEmpty && _currentStep == 1) {
                                    return 'Please select year';
                                  }
                                  return null;
                                },
                                menuMaxHeight: 350,
                              ),
                            ),
                          ],
                        ),
                        // TextFormField(
                        //   controller: _ageController,
                        //   decoration: InputDecoration(labelText: 'Age'),
                        //   keyboardType: TextInputType.number,
                        //   validator: (value) {
                        //     if (value == null || value.isEmpty) {
                        //       return 'Please enter your age';
                        //     }
                        //     int? age = int.tryParse(value);
                        //     if (age == null) {
                        //       return 'Please enter a valid number';
                        //     }
                        //     if (age < 14 || age > 105) {
                        //       return 'Please enter an age between 14 and 105';
                        //     }
                        //     return null;
                        //   },
                        // ),
                        MultiSelectDialogField(
                          items: [
                            MultiSelectItem('Claire Trevor School of the Arts', 'Claire Trevor School of the Arts'),
                            MultiSelectItem('Charlie Dunlop School of Biological Sciences', 'Charlie Dunlop School of Biological Sciences'),
                            MultiSelectItem('The Paul Merage School of Business', 'The Paul Merage School of Business'),
                            MultiSelectItem('School of Education', 'School of Education'),
                            MultiSelectItem('The Henry Samueli School of Engineering', 'The Henry Samueli School of Engineering'),
                            MultiSelectItem('School of Humanities', 'School of Humanities'),
                            MultiSelectItem('Donald Bren School of Information and Computer Sciences', 'Donald Bren School of Information and Computer Sciences'),
                            MultiSelectItem('School of Law', 'School of Law'),
                            MultiSelectItem('School of Medicine', 'School of Medicine'),
                            MultiSelectItem('Sue and Bill Gross School of Nursing', 'Sue and Bill Gross School of Nursing'),
                            MultiSelectItem('School of Pharmacy and Pharmaceutical Sciences', 'School of Pharmacy and Pharmaceutical Sciences'),
                            MultiSelectItem('School of Physical Sciences', 'School of Physical Sciences'),
                            MultiSelectItem('Joe C. Wen School of Population and Public Health', 'Joe C. Wen School of Population and Public Health'),
                            MultiSelectItem('School of Social Ecology', 'School of Social Ecology'),
                            MultiSelectItem('School of Social Sciences', 'School of Social Sciences'),
                            // MultiSelectItem('', ''),
                            MultiSelectItem('N/A', 'N/A')
                          ],
                          itemsTextStyle: TextStyle(fontSize: 15),
                          title: Text('Please select all that apply. \nClick on the right to search.',
                          style: TextStyle(fontSize: 16),),
                          buttonText: Text('Please select your Department or School',style: TextStyle(fontSize: 12),),
                          searchable: true,
                          dialogHeight: 450.0,
                          selectedColor: Colors.blue,
                          validator: (values) {
                            if (values == null || values.isEmpty) {
                              return 'Please select at least one Department or School';
                            }
                            return null;
                          },
                          onConfirm: (values) {
                            _selectedMajor = values.cast<String>();
                          },
                        ),
                        // DropdownButtonFormField<String>(
                        //   value: _majorController.text.isEmpty ? null : _majorController.text,
                        //   decoration: InputDecoration(labelText: 'Major'),
                        //   items: [
                        //     'Science',
                        //     'Engineering',
                        //     'Health Science',
                        //     // Add more majors as needed
                        //   ].map((String value) {
                        //     return DropdownMenuItem<String>(
                        //       value: value,
                        //       child: Text(value),
                        //     );
                        //   }).toList(),
                        //   onChanged: (value) {
                        //     setState(() {
                        //       _majorController.text = value!;
                        //     });
                        //   },
                        //   validator: (value) {
                        //     if (value == null || value.isEmpty) {
                        //       return 'Please select your major';
                        //     }
                        //     return null;
                        //   },
                        // ),
                      ],
                    ),
                  ),
                  isActive: _currentStep >= 1,
                  state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: Text('Choose Unit'),
                  content: Column(
                    // key: _formKeys[2],
                    children: [
                      RadioListTile<bool>(
                        title: Text('Imperial \n(Feet, Inches, Pounds)',style: TextStyle(fontSize: 16)),
                        value: true,
                        groupValue: _isImperial,
                        onChanged: (value) {
                          setState(() {
                            _isImperial = value!;
                          });
                        },
                      ),
                      RadioListTile<bool>(
                        title: Text('Metric \n(Centimeters, Kilograms)',style: TextStyle(fontSize: 16)),
                        value: false,
                        groupValue: _isImperial,
                        onChanged: (value) {
                          setState(() {
                            _isImperial = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 2,
                  state: _currentStep > 2 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: Text('Physical Info'),
                  content: Form(
                    key: _formKeys[3],
                    child: Column(
                      children: _isImperial
                          ? [
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: _feetController.text.isEmpty ? null : _feetController.text,
                                      decoration: InputDecoration(labelText: 'Height (ft)'),
                                      items: List.generate(4, (index) => (index + 4).toString()).map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _feetController.text = value!;
                                        });
                                      },
                                      validator: (value) {
                                        if (_feetController.text.isEmpty && _currentStep == 3) {
                                          return 'Please select feet';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: _inchController.text.isEmpty ? null : _inchController.text,
                                      decoration: InputDecoration(labelText: '(in)'),
                                      items: List.generate(12, (index) => index.toString()).map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _inchController.text = value!;
                                        });
                                      },
                                      validator: (value) {
                                        if (_inchController.text.isEmpty && _currentStep == 3) {
                                          return 'Please select inches';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              TextFormField(
                                controller: _weightController,
                                decoration: InputDecoration(
                                  labelText: 'Weight (lbs)',
                                ),
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your weight';
                                  }
                                  final weight = double.tryParse(value);
                                  if (weight == null || weight < 50.0 || weight > 500.0) {
                                    return 'Please enter a valid weight between 50 and 500 lbs';
                                  }
                                  return null;
                                },
                              ),
                            ]
                          : [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _cmController,
                                      decoration: InputDecoration(labelText: 'Height (cm)'),
                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your height';
                                        }
                                        final cm = double.tryParse(value);
                                        if(cm == null || cm < 30.0 || cm > 240.0){
                                          return 'Please enter a valid height between 30 and 240 cm';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              TextFormField(
                                controller: _kgController,
                                decoration: InputDecoration(
                                  labelText: 'Weight (kg)',
                                ),
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your weight';
                                  }
                                  final kg = double.tryParse(value);
                                  if (kg == null || kg < 20.0 || kg > 300.0) {
                                    return 'Please enter a valid weight between 20 and 300 kg';
                                  }
                                  return null;
                                },
                              ),
                            ],
                    ),
                  ),
                  isActive: _currentStep >= 3,
                  state: _currentStep > 3 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: Text('Additional Info'),
                  content: Form(
                    key: _formKeys[4],
                    child: Column(
                      children: [
                        MultiSelectDialogField(
                          items: [
                            MultiSelectItem('American Indian/Alaska Native', 'American Indian/Alaska Native'),
                            MultiSelectItem('Asian', 'Asian'),
                            MultiSelectItem('Black/African American', 'Black/African American'),
                            MultiSelectItem('Hispanic(non White)', 'Hispanic(non White)'),
                            MultiSelectItem('Latino', 'Latino'),
                            // MultiSelectItem('Two or more Races', 'Two or more Races'),
                            MultiSelectItem('Native Hawaiian/Other Pacific Islander', 'Native Hawaiian/Other Pacific Islander'),
                            MultiSelectItem('White', 'White'),
                            MultiSelectItem('N/A', 'N/A')
                          ],
                          itemsTextStyle: TextStyle(fontSize: 16),
                          title: Text('Please select all that apply.',
                          style: TextStyle(fontSize: 16),),
                          buttonText: Text('Please select your racial background'),
                          dialogHeight: 450.0,
                          selectedColor: Colors.blue,
                          validator: (values) {
                            if (values == null || values.isEmpty) {
                              return 'Please select at least one racial background';
                            }
                            return null;
                          },
                          onConfirm: (values) {
                            _selectedRacialBackgrounds = values.cast<String>();
                            // _formKeys[3].currentState?.validate();
                          },
                        ),
                        DropdownButtonFormField<String>(
                          value: _firstGenController.text.isEmpty ? null : _firstGenController.text,
                          decoration: InputDecoration(labelText: 'First Generation College Student'),
                          items: ['Yes', 'No','N/A'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _firstGenController.text = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select an option';
                            }
                            return null;
                          },
                        ),
                        DropdownButtonFormField<String>(
                          value: _internationalController.text.isEmpty ? null : _internationalController.text,
                          decoration: InputDecoration(labelText: 'International Student'),
                          items: ['Yes', 'No','N/A'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _internationalController.text = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select an option';
                            }
                            return null;
                          },
                        ),
                        DropdownButtonFormField<String>(
                          value: _statusController.text.isEmpty ? null : _statusController.text,
                          decoration: InputDecoration(labelText: 'Status'),
                          items: ['Master', 'Ph.D', 'Postdoc', 'Others'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _statusController.text = value!;
                              _yearController.clear(); // 清空 year 选项
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your status';
                            }
                            return null;
                          },
                        ),
                        DropdownButtonFormField<String>(
                          value: _yearController.text.isEmpty ? null : _yearController.text,
                          decoration: InputDecoration(labelText: 'Year'),
                          items: _getYearsBasedOnStatus(_statusController.text).map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _yearController.text = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your year';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  isActive: _currentStep >= 4,
                  state: _currentStep == 4 ? StepState.complete : StepState.indexed,
                ),
              ],
            ),
          ),
          // Spacer(),
          // SizedBox(height: 20),
        ],
      ),
    );
  }
}