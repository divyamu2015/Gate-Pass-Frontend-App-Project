import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_pass_project/authentication/student_auth/bloc/student_login_bloc.dart';
import 'package:gate_pass_project/screens/other_screen/role_selection.dart';
import 'package:gate_pass_project/screens/student_screens/home_page/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentLoginPage extends StatefulWidget {
  const StudentLoginPage({super.key});

  @override
  State<StudentLoginPage> createState() => _StudentLoginPageState();
}

class _StudentLoginPageState extends State<StudentLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController studIdController = TextEditingController();
  bool _obscurePassword = true;
  bool isloading = false;
  int? userId;
  String? studentId;

  Future<void> loginState() async {
    if (_formKey.currentState!.validate()) {
    //  print(123);
      FocusScope.of(context).unfocus();
      setState(() {
        isloading = true;
      });
      String studEmail = emailController.text.trim();
      String studId = studIdController.text.trim();

     // print('after validation');

      if (studId.isEmpty || studEmail.isEmpty) {
        showError("Please enter all details");
        setState(() => isloading = false);
        return;
      }
      context.read<StudentLoginBloc>().add(
        StudentLoginEvent.studentLogin(
          role: 'student',
          email: studEmail,
          studentId: studId,
        ),
      );
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> storeUserId(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userId);
   // print('User ID stored: $userId');
  }

  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');
   // print("Retrieved User ID: $userId");
    return userId;
  }

  Future<void> storeStudentId(String studId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('student_id', studId);
   // print('Student ID stored: $studId');
  }

  Future<String?> getStudentId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    studentId = prefs.getString('student_id');
    //print("Retrieved Student ID: $studentId");
    return studentId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<StudentLoginBloc, StudentLoginState>(
        listener: (context, state) {
          state.when(
            initial: () {},
            loading: () {
              setState(() {
                isloading = true;
              });
            },
            success: (response) async {
              await storeUserId(response.userId);
              userId = await getUserId();
              await storeStudentId(response.studentId);
              studentId = await getStudentId();
              if (userId != null) {
                setState(() {
                  isloading = false;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("User login successful"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>
                          HomeScreen(studId: userId!, studentId: studentId!),
                    ),
                  );
                });
              } else {
                setState(() => isloading = false);
                showError("There was an error retrieving your User ID.");
              }
            },

            error: (error) {
              setState(() {
                isloading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error: $error"),
                  backgroundColor: Colors.red,
                ),
              );
            },
          );
        },
        builder: (context, state) => Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 150, 179, 243),
                Color.fromARGB(255, 123, 160, 240),
                // Color.fromARGB(255, 103, 150, 231),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return RoleSelectionScreen();
                        },
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.rotate_90_degrees_ccw,
                    color: Color.fromARGB(255, 63, 7, 77),
                    size: 28,
                  ),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 🎞 Lottie Animation
                        Image.asset(
                              "assets/images/student (1).png",
                              height: 180,
                            )
                            .animate()
                            .fadeIn(duration: 800.ms)
                            .slideY(begin: -0.2),

                        const SizedBox(height: 10),
                        Text(
                          "Student Login",
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ).animate().fadeIn(duration: 1.seconds),

                        const SizedBox(height: 30),

                        Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  // 📧 Email
                                  TextFormField(
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: "Email",
                                      prefixIcon: const Icon(
                                        Icons.email_outlined,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter your email";
                                      }
                                      if (!value.contains("@")) {
                                        return "Enter a valid email";
                                      }
                                      return null;
                                    },
                                  ).animate().slideX(
                                    begin: -0.2,
                                    duration: 500.ms,
                                  ),

                                  const SizedBox(height: 20),

                                  // 🔑 Password
                                  TextFormField(
                                    controller: studIdController,
                                    obscureText: _obscurePassword,
                                    decoration: InputDecoration(
                                      labelText: "Enrollment Number",
                                      prefixIcon: const Icon(
                                        Icons.lock_outline,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword =
                                                !_obscurePassword;
                                          });
                                        },
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter your enrollment number";
                                      }
                                      if (value.length < 6) {
                                        return "Password must be at least 6 characters";
                                      }
                                      return null;
                                    },
                                  ).animate().slideX(
                                    begin: 0.2,
                                    duration: 500.ms,
                                  ),

                                  const SizedBox(height: 30),

                                  // 🚀 Login Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 55,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF2575FC,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        elevation: 5,
                                      ),
                                      onPressed: isloading ? null : loginState,
                                      //  () {
                                      //   if (_formKey.currentState!.validate()) {
                                      //     ScaffoldMessenger.of(
                                      //       context,
                                      //     ).showSnackBar(
                                      //       const SnackBar(
                                      //         content: Text("Logging in..."),
                                      //         backgroundColor: Colors.green,
                                      //       ),
                                      //     );
                                      //   }
                                      // },
                                      child: Text(
                                        "Login",
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ).animate().scale(duration: 500.ms),

                                  const SizedBox(height: 15),
                                ],
                              ),
                            ),
                          ),
                        ).animate().fadeIn(duration: 1.seconds).slideY(begin: 0.2),
                      ],
                    ),
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
