import 'package:flutter/material.dart';
import 'package:gate_pass_project/authentication/tutur_auth/tutor_login_view.dart';
import 'package:gate_pass_project/screens/tutor_screen/upload_student_excel.dart';
import 'package:gate_pass_project/screens/tutor_screen/view_attandence/view_attandence_view.dart';
import 'package:gate_pass_project/screens/tutor_screen/view_leave_request/view_leave_request_view.dart';
import 'package:gate_pass_project/screens/tutor_screen/view_student_job_appli/view_stud_list.dart';
import 'package:iconsax/iconsax.dart';

class TutorDashboard extends StatefulWidget {
  const TutorDashboard({
    super.key,
    required this.tutorName,
    required this.tutorId,
  });
  final String tutorName;
  final int tutorId;

  @override
  State<TutorDashboard> createState() => _TutorDashboardState();
}

class _TutorDashboardState extends State<TutorDashboard> {
  int _currentIndex = 0;
  String? tutorName;
  int? tutorId;

  @override
  void initState() {
    super.initState();
    tutorName = widget.tutorName;
    tutorId = widget.tutorId;
  }

  // Sample data
  final List<Map<String, dynamic>> quickStats = [
    {
      'title': 'Total Students',
      'value': '142',
      'icon': Iconsax.people,
      'color': Colors.blue,
    },
    {
      'title': 'Pending Leave',
      'value': '8',
      'icon': Iconsax.calendar_remove,
      'color': Colors.orange,
    },
    {
      'title': 'Job Applications',
      'value': '12',
      'icon': Iconsax.briefcase,
      'color': Colors.green,
    },
    {
      'title': 'Attendance Today',
      'value': '89%',
      'icon': Iconsax.chart_square,
      'color': Colors.purple,
    },
  ];

  final List<Map<String, dynamic>> modules = [
    {
      'title': 'Upload Student Excel',
      'icon': Iconsax.document_upload,
      'color': Color(0xFF6366F1),
      'gradient': [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    },
    {
      'title': 'View Student Leave Request',
      'icon': Iconsax.calendar_remove,
      'color': Color(0xFF10B981),
      'gradient': [Color(0xFF10B981), Color(0xFF059669)],
    },
    {
      'title': 'View Student Job Application',
      'icon': Iconsax.briefcase,
      'color': Color(0xFFF59E0B),
      'gradient': [Color(0xFFF59E0B), Color(0xFFD97706)],
    },
    {
      'title': 'View Student Attendance',
      'icon': Iconsax.chart_square,
      'color': Color(0xFFEF4444),
      'gradient': [Color(0xFFEF4444), Color(0xFFDC2626)],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              const SizedBox(height: 30),

              // Quick Stats
             // _buildQuickStats(),
             // const SizedBox(height: 30),

              // Modules Grid
              _buildModulesGrid(),
              const SizedBox(height: 30),

              // Recent Activity
              //   _buildRecentActivity(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back,',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 5),
            Text(
             tutorName!,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/profile.jpg', // Add your profile image
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Iconsax.profile_circle,
                    color: Colors.white,
                    size: 30,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildQuickStats() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'Quick Stats',
  //         style: TextStyle(
  //           fontSize: 20,
  //           fontWeight: FontWeight.bold,
  //           color: Color(0xFF1E293B),
  //         ),
  //       ),
  //       const SizedBox(height: 16),
  //       SizedBox(
  //         height: 100,
  //         child: ListView.builder(
  //           scrollDirection: Axis.horizontal,
  //           itemCount: quickStats.length,
  //           itemBuilder: (context, index) {
  //             final stat = quickStats[index];
  //             return Container(
  //               width: 160,
  //               margin: EdgeInsets.only(right: 16),
  //               decoration: BoxDecoration(
  //                 gradient: LinearGradient(
  //                   colors: [
  //                     stat['color'].withOpacity(0.1),
  //                     stat['color'].withOpacity(0.05),
  //                   ],
  //                   begin: Alignment.topLeft,
  //                   end: Alignment.bottomRight,
  //                 ),
  //                 borderRadius: BorderRadius.circular(20),
  //                 border: Border.all(color: stat['color'].withOpacity(0.2)),
  //               ),
  //               padding: const EdgeInsets.all(16),
  //               child: Row(
  //                 children: [
  //                   Container(
  //                     padding: const EdgeInsets.all(12),
  //                     decoration: BoxDecoration(
  //                       color: stat['color'].withOpacity(0.1),
  //                       shape: BoxShape.circle,
  //                     ),
  //                     child: Icon(stat['icon'], color: stat['color'], size: 24),
  //                   ),
  //                   const SizedBox(width: 12),
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Text(
  //                         stat['value'],
  //                         style: TextStyle(
  //                           fontSize: 20,
  //                           fontWeight: FontWeight.bold,
  //                           color: Color(0xFF1E293B),
  //                         ),
  //                       ),
  //                       Text(
  //                         stat['title'],
  //                         style: TextStyle(
  //                           fontSize: 12,
  //                           color: Colors.grey[600],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildModulesGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Modules',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: modules.length,
          itemBuilder: (context, index) {
            final module = modules[index];
            return _buildModuleCard(module);
          },
        ),
      ],
    );
  }

  Widget _buildModuleCard(Map<String, dynamic> module) {
    return GestureDetector(
      onTap: () {
        // Handle module tap
        _openModule(module['title']);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: module['gradient'],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: module['color'].withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned(
              right: -20,
              bottom: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: 20,
              top: -10,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(module['icon'], color: Colors.white, size: 24),
                  ),
                  const Spacer(),
                  Text(
                    module['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
void _openModule(String title) {
  if (title == 'Upload Student Excel') {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  StudentExcelUploader(tutorId: widget.tutorId,)),
    );
  } 
  else if (title == 'View Student Leave Request') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewStudentLeaveRequest(tutorId: tutorId!),
      ),
    );
  } 
  else if (title == 'View Student Job Application') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplicationListPage(tutorId: tutorId!),
      ),
    );
  } 
  else if (title == 'View Student Attendance') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewAttendancePage(tutorId: tutorId!),
      ),
    );
  }
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
                    builder: (context) => const TutorLoginPage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
  // Widget _buildRecentActivity() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(
  //             'Recent Activity',
  //             style: TextStyle(
  //               fontSize: 20,
  //               fontWeight: FontWeight.bold,
  //               color: Color(0xFF1E293B),
  //             ),
  //           ),
  //           Text(
  //             'View All',
  //             style: TextStyle(
  //               color: Color(0xFF6366F1),
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 16),
  //       Container(
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(20),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black.withOpacity(0.05),
  //               blurRadius: 20,
  //               offset: const Offset(0, 4),
  //             ),
  //           ],
  //         ),
  //         padding: const EdgeInsets.all(16),
  //         child: Column(
  //           children: [
  //             _buildActivityItem(
  //               'New leave request from John Doe',
  //               '2 min ago',
  //               Iconsax.calendar_remove,
  //               Colors.orange,
  //             ),
  //             _buildActivityItem(
  //               'Job application submitted by Jane Smith',
  //               '1 hour ago',
  //               Iconsax.briefcase,
  //               Colors.green,
  //             ),
  //             _buildActivityItem(
  //               'Attendance report generated for today',
  //               '2 hours ago',
  //               Iconsax.chart_square,
  //               Colors.blue,
  //             ),
  //             _buildActivityItem(
  //               'Excel file uploaded successfully',
  //               '4 hours ago',
  //               Iconsax.document_upload,
  //               Colors.purple,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildActivityItem(
  //   String title,
  //   String time,
  //   IconData icon,
  //   Color color,
  // ) {
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 12),
  //     child: Row(
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.all(8),
  //           decoration: BoxDecoration(
  //             color: color.withOpacity(0.1),
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: Icon(icon, color: color, size: 20),
  //         ),
  //         const SizedBox(width: 12),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 title,
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.w500,
  //                   color: Color(0xFF1E293B),
  //                 ),
  //               ),
  //               Text(
  //                 time,
  //                 style: TextStyle(fontSize: 12, color: Colors.grey[500]),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
        if (index == 1) {  
        // Logout clicked
        _showLogoutDialog(context);
      }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Color(0xFF6366F1),
      unselectedItemColor: Colors.grey[600],
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'Home'),
        // BottomNavigationBarItem(
        //   icon: Icon(Iconsax.calendar),
        //   label: 'Schedule',
        // ),
        // BottomNavigationBarItem(
        //   icon: Icon(Iconsax.message),
        //   label: 'Messages',
        // ),
        BottomNavigationBarItem(icon: Icon(Iconsax.setting), label: 'Log Out'),
      ],
    );
  }

  // void _showModuleDialog(String moduleName) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //       title: Text(moduleName),
  //       content: Text(
  //         '$moduleName module would open here with full functionality.',
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text('Close'),
  //         ),
  //         ElevatedButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text('Open'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
