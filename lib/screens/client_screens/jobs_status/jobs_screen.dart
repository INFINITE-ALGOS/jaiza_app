import 'package:flutter/material.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/screens/client_screens/jobs_status/completed_job_screen.dart';
import 'package:law_education_app/screens/client_screens/jobs_status/cancelled_job_screen.dart';

import 'active_jobs/active_job_screen.dart';

class JobsStatusScreen extends StatefulWidget {
   const JobsStatusScreen({super.key});
  @override
  State<JobsStatusScreen> createState() => _JobsStatusScreenState();
}

class _JobsStatusScreenState extends State<JobsStatusScreen> {
  int selected_index=0;
  final List<Widget> _screens = [
    const ActiveJobsScreen(),
    const CompletedJobsScreen(),
    CancelledJobsScreen(),
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
          color: isActive ? primaryColor : const Color(0xFFf1f1f2),
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
