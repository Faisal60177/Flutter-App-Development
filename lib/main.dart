import 'package:flutter_project/repositories/country_repository.dart';
import 'package:flutter_project/screens/country_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => CountryRepository(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Countries of the World',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const CountryListScreen(),
      ),
    );
  }
}