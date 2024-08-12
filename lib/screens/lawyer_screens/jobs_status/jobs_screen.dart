import 'package:flutter/material.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/screens/lawyer_screens/jobs_status/success_job_screen.dart';
import 'active_job_screen.dart';
import 'complete_job_screen.dart';

class JobsStatusScreenLawyer extends StatefulWidget {
  const JobsStatusScreenLawyer({super.key});
  @override
  State<JobsStatusScreenLawyer> createState() => _JobsStatusScreenLawyerState();
}

class _JobsStatusScreenLawyerState extends State<JobsStatusScreenLawyer> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    ActiveScreenLawyer(),
    SuccessJobScreenLawyer(),
    CompleteJobScreenLawyer(),
  ];
  final List<String> _labels = ['Active', 'Success', 'Cancelled'];
  void _onContainerTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFf1f1f2),
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
              index: _selectedIndex,
              children: _screens,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContainer(String text, int index) {
    bool isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onContainerTap(index),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.075,
        width: MediaQuery.of(context).size.width * 0.47,
        decoration: BoxDecoration(
          color: isActive ? blueColor : Color(0xFFf1f1f2),
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
