import 'package:flutter/material.dart';
import 'package:gate_pass_project/screens/other_screen/constant_uri.dart';
import 'package:gate_pass_project/screens/student_screens/list_of_jobs/list_of_jobs_model.dart';
import 'package:gate_pass_project/screens/student_screens/list_of_jobs/list_of_jobs_service.dart';
import 'package:gate_pass_project/screens/student_screens/view_job_details/job_details_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyListView extends StatefulWidget {
  const CompanyListView({super.key, required this.userId});
  final int userId;

  @override
  State<CompanyListView> createState() => _CompanyListViewState();
}

class _CompanyListViewState extends State<CompanyListView> {
  late Future<List<CompanyModel>> futureCompanies;
  String? storedCompanyId;
  @override
  void initState() {
    super.initState();
    futureCompanies = fetchCompanies();
     loadStoredCompanyId();
    
  }
 Future<void> storeCompanyId(String companyId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', companyId);
   // print('ID stored: $companyId');
    setState(() => storedCompanyId = companyId);
  }

  Future<void> loadStoredCompanyId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? companyId = prefs.getString('id');
   // print("Retrieved Company ID: $companyId");
    setState(() => storedCompanyId = companyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track your Companies'),
        backgroundColor: Colors.indigo[200],
      ),
      body: Container(
        decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage(
          //     'assets/images/764921_1-01.jpg',
          //   ), // Path to your image
          //   fit: BoxFit.cover, // Cover entire background
          // ),
        ),
        child: FutureBuilder<List<CompanyModel>>(
          future: futureCompanies,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No companies found"));
            }

            final companies = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: companies.length,
              itemBuilder: (context, index) {
                final company = companies[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    // Display the logo
                    leading:
                        company.logo.isEmpty || company.logo == "companyLogo"
                        ? CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 25,
                            child: Icon(
                              Icons.business,
                              size: 40,
                              color: Colors.white,
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            radius: 25,
                            backgroundImage: NetworkImage(
                              "$imageBaseUrl${company.logo}",
                            ),
                            onBackgroundImageError: (exception, stackTrace) {
                              // Fallback to a default icon if the image fails to load
                              return;
                            },
                            child: company.logo.isEmpty
                                ? const Icon(
                                    Icons.business,
                                    size: 40,
                                    color: Colors.grey,
                                  )
                                : null,
                          ),
                    // Display the name
                    title: Text(
                      company.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    // Display the description
                    subtitle: Text(
                      company.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                   onTap: () async {
                      await storeCompanyId(company.id.toString());
                    //  print("Tapped on ${company.name}");
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => JobsListScreen(
                            studentId: widget.userId,

                            companyName: company.name,
                            companyLogo: "$imageBaseUrl${company.logo}",
                            companyId: company.id,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
