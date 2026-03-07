import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_pass_project/authentication/tutur_auth/bloc/tutor_login_bloc.dart';
import 'package:gate_pass_project/screens/tutor_screen/tutor_home_screen.dart';
//import 'package:gate_pass_project/screens/tutor_screen/upload_student_excel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorLoginPage extends StatefulWidget {
  const TutorLoginPage({super.key});

  @override
  State<TutorLoginPage> createState() => _TutorLoginPageState();
}

class _TutorLoginPageState extends State<TutorLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController tutorIdController = TextEditingController();
  final bool _obscurePassword = true;
  bool isloading = false;
  int? tutorId;
  String? tutorName;

  Future<void> loginState() async {
    if (_formKey.currentState!.validate()) {
     // print(123);
      FocusScope.of(context).unfocus();
      setState(() {
        isloading = true;
      });
      String tutEmail = emailController.text.trim();
      String tutId = tutorIdController.text.trim();

     // print('after validation');

      if (tutId.isEmpty || tutEmail.isEmpty) {
        showError("Please enter all details");
        setState(() => isloading = false);
        return;
      }
      context.read<TutorLoginBloc>().add(
        TutorLoginEvent.tutorLogin(
          role: 'tutor',
          email: tutEmail,
          tutorId: tutId,
        ),
      );
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> storeUserId(int tutorId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', tutorId);
  //  print('User ID stored: $tutorId');
  }

  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tutorId = prefs.getInt('user_id');
   // print("Retrieved User ID: $tutorId");
    return tutorId;
  }

  Future<void> storeName(String tutorName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', tutorName);
   // print('User ID stored: $tutorId');
  }

  Future<String?> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tutorName = prefs.getString('name');
   // print("Retrieved User ID: $tutorName");
    return tutorName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TutorLoginBloc, TutorLoginState>(
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
              tutorId = await getUserId();
               await storeName(response.name);
              tutorName = await getName();

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
                    builder: (context) {
                      return
                      // ChatScreen(userId: userId!);
                      // HomeScreen(userId: tutorId!);
                      TutorDashboard(
                        tutorName: tutorName!,
                        tutorId: tutorId!,
                      );
                      // StudentExcelUploader();
                    },
                  ),
                );
              });
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink[200]!, Colors.pink[100]!, Colors.pink[200]!],
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
                    Navigator.of(context).pop();
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
                              "assets/images/tutor.jpg",
                              // color: Colors.pink,
                              height: 180,
                            )
                            .animate()
                            .fadeIn(duration: 1800.ms)
                            .slideY(begin: -0.20, duration: 4.seconds),

                        const SizedBox(height: 10),
                        Text(
                          "Tutor Login",
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
                                  // 🔑 Password
                                  TextFormField(
                                    controller: tutorIdController,
                                   // obscureText: _obscurePassword,
                                    decoration: InputDecoration(
                                      labelText: "Tutor ID",
                                      prefixIcon: const Icon(
                                        Icons.badge_outlined,
                                      ),
                                      // suffixIcon: IconButton(
                                      //   icon: Icon(
                                      //     _obscurePassword
                                      //         ? Icons.visibility_off
                                      //         : Icons.visibility,
                                      //   ),
                                      //   onPressed: () {
                                      //     setState(() {
                                      //       _obscurePassword = !_obscurePassword;
                                      //     });
                                      //   },
                                      // ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter your Tutor ID";
                                      }
                                      // if (value.length < 6) {
                                      //   return "Password must be at least 6 characters";
                                      // }
                                      return null;
                                    },
                                  ).animate().slideX(
                                    begin: 0.2,
                                    duration: 500.ms,
                                  ),

                                  const SizedBox(height: 20),
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

                                  const SizedBox(height: 30),

                                  // 🚀 Login Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 55,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.pink[300],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        elevation: 5,
                                      ),
                                      onPressed: isloading ? null : loginState,
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

                                  // Forgot password
                                  // TextButton(
                                  //   onPressed: () {},
                                  //   child: Text(
                                  //     "Forgot Password?",
                                  //     style: GoogleFonts.poppins(
                                  //       fontSize: 14,
                                  //       color: Colors.grey[700],
                                  //     ),
                                  //   ),
                                  // ),
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
