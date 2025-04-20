// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:learning_platform/src/feature/admin/widget/pages/course_manage_page.dart';
// import 'package:learning_platform/src/feature/admin/widget/pages/user_manage_page.dart';

// class AdminHomePage extends StatefulWidget {
//   const AdminHomePage({Key? key}) : super(key: key);

//   @override
//   State<AdminHomePage> createState() => _AdminHomePageState();
// }

// class _AdminHomePageState extends State<AdminHomePage> {
//   int _selectedIndex = 0;

//   late final List<Widget> _pages = [
//     const AdminUserManagementPage(),
//     const AdminCourseManagementPage(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() => _selectedIndex = index);
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(
//           title: Text(
//             _getAppBarTitle(_selectedIndex),
//             textAlign: TextAlign.center,
//           ),
//           centerTitle: true,
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.person),
//               onPressed: () => context.push('/profile'),
//             ),
//           ],
//         ),
//         body: _pages[_selectedIndex],
//         bottomNavigationBar: BottomNavigationBar(
//           currentIndex: _selectedIndex,
//           onTap: _onItemTapped,
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.people),
//               label: 'Пользователи',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.book),
//               label: 'Курсы',
//             ),
//           ],
//         ),
//       );

//   String _getAppBarTitle(int index) {
//     switch (index) {
//       case 0:
//         return 'Управление\nпользователями';
//       case 1:
//         return 'Управление\nкурсами';
//       default:
//         return '';
//     }
//   }
// }
