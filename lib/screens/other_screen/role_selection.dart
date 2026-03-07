import 'package:flutter/material.dart';
import 'package:gate_pass_project/authentication/student_auth/student_login_view.dart';
import 'package:gate_pass_project/authentication/tutur_auth/tutor_login_view.dart';
import 'package:google_fonts/google_fonts.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with TickerProviderStateMixin {
  String selectedRole = "Student";

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Select Role",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: w,
        height: h,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF3A3D98),
              Color(0xFF6F91CE),
              Color(0xFFEAEAEA),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: h * 0.14),

            // ---- ROLE SWITCH ----
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white70, width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _roleButton("Student"),
                  const SizedBox(width: 6),
                  _roleButton("Tutor"),
                ],
              ),
            ),

            SizedBox(height: h * 0.07),

            // ---- MAIN CARD ----
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              width: w * 0.88,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  colors: selectedRole == "Student"
                      ? [Colors.white, Colors.white70]
                      : [Colors.white, Colors.purple.shade50],
                ),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ROLE ICON
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.grey.shade200,
                    child: Icon(
                      selectedRole == "Student"
                          ? Icons.school_rounded
                          : Icons.supervisor_account_rounded,
                      color: Colors.deepPurple,
                      size: 40,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // TITLE
                  Text(
                    selectedRole == "Student"
                        ? "Welcome, Student!"
                        : "Welcome, Tutor!",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // SUBTITLE
                  Text(
                    selectedRole == "Student"
                        ? "Access your dashboard and view progress."
                        : "Manage students and approve leave requests.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 6,
                      ),
                      onPressed: () {
                        if (selectedRole == "Student") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StudentLoginPage(),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TutorLoginPage(),
                            ),
                          );
                        }
                      },
                      child: Text(
                        "Continue",
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // BEAUTIFUL ROLE BUTTON
  Widget _roleButton(String role) {
    bool isSelected = selectedRole == role;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = role;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Text(
          role,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.deepPurple : Colors.white,
          ),
        ),
      ),
    );
  }
}

