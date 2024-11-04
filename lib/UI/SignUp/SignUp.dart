import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:softwareproject/UI/SignUp/CourseSelection.dart';
import 'package:softwareproject/Utils/helper/helper_functions.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController studentIdController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController pass1Controller = TextEditingController();
  TextEditingController pass2Controller = TextEditingController();
  int batchCode = 24;
  bool isNotValid = false;
  String errorMessage = "";

  gotoCourseSelection() {
    if(nameController.text.isEmpty || emailController.text.isEmpty || studentIdController.text.isEmpty ||
    mobileController.text.isEmpty || pass2Controller.text.isEmpty || pass1Controller.text.isEmpty ){
      errorMessage = "Enter Valid Details";
      HelperFunctions.showSnackBar(errorMessage);
    } else {
      if(pass1Controller.text != pass2Controller.text){
        errorMessage = "Password is not Matching";
        return HelperFunctions.showSnackBar(errorMessage);
      }

      HelperFunctions.navigateToScreen(context, CourseSelection(fullName: nameController.text, studentId: studentIdController.text,
        email: emailController.text, mobile: mobileController.text, password: pass1Controller.text, batchCode: batchCode,));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            // Changed background to a gradient for a more elegant look
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF3E5F5),
              Color(0xFFE1BEE7),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const SizedBox(height: 50,),

                Text('Sign Up', style: GoogleFonts.pacifico(
                    textStyle: const TextStyle(
                      fontSize: 36,
                      color: Colors.black,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 4,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
          
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person, color: Colors.grey[500]),
                    hintText: "Full Name",
                  ),
                ),
          
                const SizedBox(height: 15),
          
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Colors.grey[500]),
                    hintText: "College Email",
                  ),
                ),

                const SizedBox(height: 15),
          
                TextField(
                  controller: mobileController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.numbers, color: Colors.grey[500]),
                    hintText: "Mobile Number",
                  ),
                ),

                const SizedBox(height: 15),
          
                TextField(
                  controller: studentIdController,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.difference, color: Colors.grey[500]),
                    hintText: "Roll Number",
                  ),
                ),

                const SizedBox(height: 15),
          
                TextField(
                  controller: pass1Controller,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.password, color: Colors.grey[500]),
                    hintText: "Enter Password",
                  ),
                ),

                const SizedBox(height: 15),
          
                TextField(
                  controller: pass2Controller,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.password, color: Colors.grey[500]),
                    hintText: "Enter Password again",
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  height: 50,
                  child: DropdownButtonFormField<int>(
                    style: Theme.of(context).textTheme.bodySmall,
                    value: batchCode,
                    onChanged: (value) {
                      setState(() {
                        batchCode = value!;
                      });
                    },
                    dropdownColor: Colors.white,
                    items: const [
                      DropdownMenuItem(
                        value: 24,
                        child: Text(
                          'Batch 2024',
                        ),
                      ),
                      DropdownMenuItem(
                        value: 23,
                        child: Text(
                          'Batch 2023',
                        ),
                      ),
                      DropdownMenuItem(
                        value: 22,
                        child: Text(
                          'Batch 2022'
                        ),
                      ),
                      DropdownMenuItem(
                        value: 21,
                        child: Text(
                          'Batch 2021',
                        ),
                      ),
                    ],
                    validator: (value) {
                      if (value != null) {
                        return '';
                      }
                      return null;
                    },
                    onSaved: (value) => {
                      setState(() => batchCode = value!)
                    },
                  ),
                ),



                const SizedBox(height: 30,),

                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      gotoCourseSelection();
                    },
                    child: const Text("Continue"),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Already have an account? LogIn",
                    style: GoogleFonts.roboto(
                      // Clean and modern font for the text button
                      textStyle: const TextStyle(
                        fontSize: 16,
                        color:
                            Colors.deepPurple, // Updated text color to match theme
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
