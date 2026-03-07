import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gate_pass_project/screens/student_screens/home_page/home_page.dart';
import 'package:typewritertext/typewritertext.dart';

class JobRulesReg extends StatelessWidget {
  const JobRulesReg({super.key,required this .studId});
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
                      "Job Application and Resume Terms&Conditions 📋",
                      maintainSize: true,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 32, 5, 78),
                      ),
                      duration: const Duration(milliseconds: 50),
                    ),
                    const SizedBox(height: 25.0),

                    // Application Eligibility Criteria
                    TypeWriter.text(
                      "Application Eligibility Criteria:",
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 107, 59, 190),
                      ),
                      duration: const Duration(milliseconds: 50),
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: TypeWriter(
                        controller: TypeWriterController(
                          text:
                              '''- Only students meeting the company’s status requirements may apply for each job vacancy.
- Students with no active backlogs (supplies) or only 1 supply can apply, as per company preference. The system automatically forwards it to a teacher/reviewer for verification and the application may be rejected.''',
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
                    const SizedBox(height: 20.0),

                    // Academic & Project Requirements
                    TypeWriter.text(
                      "Academic & Project Requirements:",
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 107, 59, 190),
                      ),
                      duration: const Duration(milliseconds: 50),
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: TypeWriter(
                        controller: TypeWriterController(
                          text:
                              '''- Companies may require a minimum academic score/grade; check each job's specific marks/practical knowledge requirements before applying.
- Submit details of your own self-created projects and demonstrate solid practical knowledge in your project area and its future potential.''',
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
                    //                     const SizedBox(height: 20.0),

                    //                     // Communication & Status Updates
                    //                     TypeWriter.text(
                    //                       "Communication & Status Updates:",
                    //                       style: const TextStyle(
                    //                         fontSize: 20.0,
                    //                         fontWeight: FontWeight.bold,
                    //                         color: Color.fromARGB(255, 45, 25, 80),
                    //                       ),
                    //                       duration: const Duration(milliseconds: 50),
                    //                     ),
                    //                     const SizedBox(height: 8.0),
                    //                     Padding(
                    //                       padding: const EdgeInsets.only(left: 12.0),
                    //                       child: TypeWriter(
                    //                         controller: TypeWriterController(
                    //                           text:
                    //                               '''- Submit a valid, active email address in your application. All status updates (shortlisting, interview schedules, selection, or rejection) will be sent to this email.
                    // - Regularly check your email—including the spam folder—for company communications.''',
                    //                           duration: const Duration(milliseconds: 25),
                    //                         ),
                    //                         builder: (context, value) {
                    //                           return AutoSizeText(
                    //                             value.text,
                    //                             maxLines: 8,
                    //                             minFontSize: 15.0,
                    //                             style: const TextStyle(color: Colors.black87),
                    //                           );
                    //                         },
                    //                       ),
                    //                     ),
                    const SizedBox(height: 20.0),

                    // Resume & Application Integrity
                    TypeWriter.text(
                      "Resume & Application Integrity:",
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 107, 59, 190),
                      ),
                      duration: const Duration(milliseconds: 50),
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: TypeWriter(
                        controller: TypeWriterController(
                          text:
                              '''- Create an AI-optimized resume as part of your application.
- Fill in all required details honestly and correctly; if there are mismatches or false information, the application will be rejected by the authority.''',
                          duration: const Duration(milliseconds: 25),
                        ),
                        builder: (context, value) {
                          return AutoSizeText(
                            value.text,
                            maxLines: 8,
                            minFontSize: 15.0,
                            style: const TextStyle(color: Colors.black87),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    // Interview Process & Conduct
                    TypeWriter.text(
                      "Interview Process & Conduct:",
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 107, 59, 190),
                      ),
                      duration: const Duration(milliseconds: 50),
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: TypeWriter(
                        controller: TypeWriterController(
                          text:
                              '''- Follow the scheduled time and instructions for all rounds (technical, aptitude, HR, etc.) carefully.
- Missing deadlines or not appearing for interviews may result in cancellation of your application.''',
                          duration: const Duration(milliseconds: 25),
                        ),
                        builder: (context, value) {
                          return AutoSizeText(
                            value.text,
                            maxLines: 7,
                            minFontSize: 15.0,
                            style: const TextStyle(color: Colors.black87),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    // Professionalism & Best Practices
                    TypeWriter.text(
                      "Professionalism & Best Practices:",
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 107, 59, 190),
                      ),
                      duration: const Duration(milliseconds: 50),
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: TypeWriter(
                        controller: TypeWriterController(
                          text:
                              '''- Provide correct and well-presented documents and contact details; incomplete or incorrect submissions are grounds for rejection.
- Demonstrate professionalism and a positive attitude throughout the recruitment process.''',
                          duration: const Duration(milliseconds: 25),
                        ),
                        builder: (context, value) {
                          return AutoSizeText(
                            value.text,
                            maxLines: 7,
                            minFontSize: 15.0,
                            style: const TextStyle(color: Colors.black87),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20.0),

                    // Final Good Luck Message
                    TypeWriter.text(
                      "Good luck! 🎉",
                      alignment: Alignment.center,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 24, 153, 7),
                      ),
                      duration: const Duration(milliseconds: 50),
                    ),
                    const SizedBox(height: 15.0),
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
