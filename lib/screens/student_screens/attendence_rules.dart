import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gate_pass_project/screens/student_screens/home_page/home_page.dart';
import 'package:typewritertext/typewritertext.dart';

class AttenedanceRulesReg extends StatelessWidget {
  const AttenedanceRulesReg({super.key,required this .studId});
  final int studId;
  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 245, 237, 212),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 60.0,
              left: 5.0,
              right: 5.0,
              bottom: 20.0,
            ),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TypeWriter.text(
                      "Attendence Terms and Conditions 📋",
                      maintainSize: true,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 32, 5, 78),
                      ),
                      duration: const Duration(milliseconds: 50),
                    ),
                    const SizedBox(height: 30.0),

                    // Application Eligibility Criteria
                    TypeWriter.text(
                      "Mark Your Attendance:",
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 107, 59, 190),
                      ),
                      duration: const Duration(milliseconds: 50),
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: TypeWriter(
                        controller: TypeWriterController(
                          text:
                              "Mark your attendance only between 9:15 AM to 9:30 AM. "
                              "After 9:30 AM, attendance cannot be marked. "
                              "Click the camera button to take your photo and upload it. "
                              "Attendance is automatically marked when your photo is uploaded. "
                              "You must be physically in the class while taking the photo because an authorized person is watching. "
                              "If attendance is marked without being in the classroom, appropriate action will be taken.",
                          duration: const Duration(milliseconds: 25),
                        ),
                        builder: (context, value) {
                          return AutoSizeText(
                            value.text,
                            maxLines: 10,
                            minFontSize: 15.0,
                            style: const TextStyle(color: Colors.black87),
                          );
                        },
                      ),
                    ),
                    //
                    const SizedBox(height: 30.0),

                    // Final Good Luck Message
                    TypeWriter.text(
                      "Note: Attendance marked only Digitally.",
                      alignment: Alignment.center,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 202, 71, 61),
                      ),
                      duration: const Duration(milliseconds: 50),
                    ),
                    const SizedBox(height: 40.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 141, 124, 170),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 20.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      ),
                      child: Text(
                        'OK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
