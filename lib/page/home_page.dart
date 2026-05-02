// import 'package:flutter/material.dart';
// //import 'package:careo_new/widget/line_chart_widget.dart';
// import 'package:careo_new/widget/exercises_widget.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         body: CustomScrollView(
//           physics: BouncingScrollPhysics(),
//           slivers: [
//             buildAppBar(context),
//             ExercisesWidget(),
//           ],
//         ),
//       );
//   SliverAppBar buildAppBar(BuildContext context) => SliverAppBar(
//         //flexibleSpace: FlexibleSpaceBar(background:LineChartWidget() ,),
//         expandedHeight: MediaQuery.of(context).size.height * 0.5,
//         stretch: true,
//         centerTitle: true,
//         pinned: true,
//         title: Text('Fitness'),
//         backgroundColor: Colors.amber,
//         leading: Icon(Icons.menu),
//         actions: [Icon(Icons.person, size: 28), SizedBox(width: 12)],
//       );
// }
