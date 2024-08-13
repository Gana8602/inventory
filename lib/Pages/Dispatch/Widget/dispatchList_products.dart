// ignore_for_file: file_names, use_super_parameters, prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';
import 'package:inventory/Pages/Dispatch/Widget/Tab/tab1.dart';
import 'package:inventory/Pages/Dispatch/Widget/Tab/tab2.dart';

class DispatchedProductsPage extends StatelessWidget {
  DispatchedProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dispatched Products'),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Products List',
                icon: Icon(Icons.library_books),
              ),
              Tab(
                text: 'To Customer',
                icon: Icon(Icons.person),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [Tab1(), Tab2()],
        ),
      ),
    );
  }
}
