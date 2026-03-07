import 'dart:async';
import 'package:flutter/material.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:gate_pass_project/authentication/student_auth/student_login_view.dart';
import 'package:gate_pass_project/screens/student_screens/attendence_rules.dart';
import 'package:gate_pass_project/screens/student_screens/exit_button_screen/exit_button_view.dart';
import 'package:gate_pass_project/screens/student_screens/face_detection/face_detection_view.dart';
import 'package:gate_pass_project/screens/student_screens/job_rules_reg.dart';
import 'package:gate_pass_project/screens/student_screens/list_of_jobs/list_of_jobs_view.dart';
import 'package:gate_pass_project/screens/student_screens/student_profile_management/stud_profile_manag_view.dart';
import 'package:gate_pass_project/screens/student_screens/view_stud_job_application/view_stud_view.dart';
import 'package:gate_pass_project/screens/student_screens/view_stud_leave_request/view_stud_leave.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.studId = 0, this.studentId = ''});
  final int studId;
  final String studentId;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String title = "PassiFY";
  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();
  final List<String> images = [
    'assets/images/qr.jpeg',
    'assets/images/v.jpg',
    'assets/images/job.jpg',
  ];
  //final PageController _carouselController = PageController();

 //final int _carouselNumPages = 3;
  int _currentPage = 0;
  Timer? _timer;

  int _tabIndex = 2;
  int get tabIndex => _tabIndex;
  set tabIndex(int v) {
    _tabIndex = v;
    setState(() {});
  }

  String? studentId;
  int? studId;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      int nextPage = (_currentPage + 1) % images.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });

    _pageController = PageController(initialPage: _tabIndex);
    studId = widget.studId;
    studentId = widget.studentId;
   // print("User ID in Home Screen: $studId");
   // print("studentId in Home Screen: $studentId");
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to close the dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text('Do you really want to log out?')],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                // If "No" is pressed, just close the dialog
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const StudentLoginPage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SliderDrawer(
          key: _sliderDrawerKey,
          sliderOpenSize: 300.0,
          slideDirection: SlideDirection.leftToRight,
          sliderBoxShadow: SliderBoxShadow(
            blurRadius: 25,
            spreadRadius: 5,
            color: Colors.white,
          ),
          slider: _buildDrawer(),
          appBar: SliderAppBar(
            config: SliderAppBarConfig(
              backgroundColor: const Color.fromARGB(255, 110, 117, 150),
              title: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: PageView.builder(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Stack(
                  // fit: StackFit.expand,
                  children: [
                    Positioned(
                      //  top: h * 0.1,
                      top: 50.0,
                      left: w * 0.1,
                      right: w * 0.1,
                      child: Card(
                        shadowColor: const Color.fromARGB(255, 43, 42, 42),
                        elevation: 13,
                        surfaceTintColor: const Color.fromARGB(255, 27, 0, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: h * 0.6,
                              width: w * 0.9,
                              decoration: BoxDecoration(color: Colors.grey[50]),
                              child: Image.asset(
                                images[index],
                                fit: BoxFit.fitHeight,
                                height: h * 0.2,
                                width: w * 0.8,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  114,
                                  141,
                                  161,
                                ),
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(30),
                                // ),
                              ),
                              onPressed: () {
                                // Your custom button action for this page
                                if (index == 0) {
                               //   print('You are pressed button $index');
                                } else if (index == 1) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AttenedanceRulesReg(studId: studId!,),
                                    ),
                                  );
                                } else if (index == 2) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => JobRulesReg(studId: studId!,),
                                    ),
                                  );
                                }
                               // print("Button pressed for image $index");
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 12,
                                ),
                                child: Text(
                                  "Terms & Conditions",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            extendBody: true,

            bottomNavigationBar: CircleNavBar(
              activeIcons: const [
                Icon(Icons.outbond_outlined, color: Colors.deepPurple),
                Icon(Icons.access_time, color: Colors.deepPurple),
                Icon(Icons.home, color: Colors.deepPurple),
                Icon(Icons.work, color: Colors.deepPurple),
                Icon(Icons.logout, color: Colors.deepPurple),
              ],
              inactiveIcons: const [
                Text("Exits"),
                Text("Check-In"),
                Text("Home"),
                Text("View Jobs"),
                Text("Logout"),
              ],
              color: Colors.white,
              height: 60,
              circleWidth: 60,
              activeIndex: tabIndex,
              onTap: (index) {
                tabIndex = index;
                _pageController.jumpToPage(tabIndex);

                if (index == 0) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LeaveRequestScreen(
                        studId: studId!,
                        // studId: studId!,
                        // studentId: studentId!,
                      ),
                    ),
                  );
                } else if (index == 1) {
                  // Navigate to attendance screen (FaceDetectionScreen)
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => FaceDetectionScreen(
                        studId: widget.studId,
                        studentId: widget.studentId,
                      ),
                    ),
                  );
                } else if (index == 2) {
                  // 'Home' tab: stays in this HomeScreen page view content (no navigation)
                } else if (index == 3) {
                  // Navigate to ViewJobs (list of jobs)
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CompanyListView(userId: studId!),
                    ),
                  );
                } else if (index == 4) {
                  _showLogoutDialog(context);
                }
              },

              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
              cornerRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(24),
                bottomLeft: Radius.circular(24),
              ),
              shadowColor: const Color.fromARGB(255, 248, 219, 175),
              elevation: 10,
            ),
            // body:
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Container(
      width: 200.0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: Column(
          children: [
            // const CircleAvatar(
            //   radius: 40,
            //   child: Icon(Icons.person, size: 50, color: Colors.white),
            // ),
            // const SizedBox(height: 10),
            // const Text('name'),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(
                Icons.home,
                color: Color.fromARGB(255, 163, 79, 182),
              ),
              title: const Text(
                "Home",
                style: TextStyle(color: Color.fromARGB(255, 14, 13, 13)),
              ),
              selectedColor: Colors.purple,
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return HomeScreen(studId: studId!, studentId: studentId!);
                    },
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.book_rounded,
                color: Color.fromARGB(255, 103, 30, 119),
              ),
              title: const Text(
                "Profile Management",
                style: TextStyle(color: Color.fromARGB(255, 10, 10, 10)),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return StudentProfileScreen(studId: studId!,studentId: widget.studentId,);
                    },
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.paypal_sharp,
                color: Color.fromARGB(255, 163, 79, 182),
              ),
              title: Text(
                "View Job Applications",
                style: TextStyle(color: Color.fromARGB(255, 10, 10, 10)),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return JobApplicationDetailsScreen(studentId: studId!);
                    },
                  ),
                );
              },
            ),
            // ListTile(
            //   leading: Icon(
            //     Icons.info_outlined,
            //     color: Color.fromARGB(255, 163, 79, 182),
            //   ),
            //   title: Text(
            //     "View Progress",
            //     style: TextStyle(color: Color.fromARGB(255, 10, 10, 10)),
            //   ),
            //   onTap: () {
            //     Navigator.pushReplacement(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) {
            //           return JobApplicationDetailsScreen(studentId: studId!);
            //           // ProcessTimelinePage();
            //         },
            //       ),
            //     );
            //   },
            // ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Color.fromARGB(255, 163, 79, 182),
              ),
              title: Text(
                "View Leave requests",
                style: TextStyle(color: Color.fromARGB(255, 10, 10, 10)),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                builder: (context) {
                 return LeaveRequestDetailsPage(studentId: studId!,);
                 },
                 ),
                );
              },
            ),
            // ListTile(
            //   leading: Icon(
            //     Icons.info_outlined,
            //     color: Color.fromARGB(255, 163, 79, 182),
            //   ),
            //   title: Text(
            //     "Do or Don'ts",
            //     style: TextStyle(color: Color.fromARGB(255, 10, 10, 10)),
            //   ),
            // ), // Add other drawer items here
          ],
        ),
      ),
    );
  }
}
