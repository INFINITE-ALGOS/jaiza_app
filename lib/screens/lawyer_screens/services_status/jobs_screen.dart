import 'package:flutter/material.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/screens/client_screens/jobs_status/completed_job_screen.dart';
import 'package:law_education_app/screens/client_screens/jobs_status/cancelled_job_screen.dart';
import 'package:law_education_app/screens/lawyer_screens/services_status/active_services/active_service_screen.dart';
import 'package:law_education_app/screens/lawyer_screens/services_status/cancelled_service_screen.dart';
import 'package:law_education_app/screens/lawyer_screens/services_status/completed_service_screen.dart';


class JobsStatusScreenLawyer extends StatefulWidget {
   const JobsStatusScreenLawyer({super.key});
  @override
  State<JobsStatusScreenLawyer> createState() => _JobsStatusScreenLawyerState();
}

class _JobsStatusScreenLawyerState extends State<JobsStatusScreenLawyer> {
  int selected_index=0;
  final List<Widget> _screens = [
    const ActiveServiceScreenLawyer(),
    const CompletedServiceScreen(),
    CancelledServiceScreen(),
  ];
  final List<String> _labels = ['Active', 'Completed', 'Cancelled'];
  void _onContainerTap(int index) {
    setState(() {
      selected_index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFFf1f1f2),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_labels.length, (index) {
                return Expanded(
                  child: _buildContainer(_labels[index], index),
                );
              }),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: selected_index,
              children: _screens,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContainer(String text, int index) {
    bool isActive = selected_index == index;
    return GestureDetector(
      onTap: () => _onContainerTap(index),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.075,
        width: MediaQuery.of(context).size.width * 0.47,
        decoration: BoxDecoration(

          color: isActive ? primaryColor : Color(0xFFf1f1f2),
          border: Border.all(
            color: Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(isActive ? 6 : 3),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color:isActive?Colors.white: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
