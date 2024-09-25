import 'package:countryapp/bloc/country_bloc.dart';
import 'package:countryapp/controllers/auth_controller.dart';
import 'package:countryapp/widgets/primary_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Countries",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await AuthController.signOut();
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: Column(
        children: [
          const PrimarySearchBar(
            hintText: "Search Countries",
          ),
          16.height,
          BlocBuilder<CountryBloc, CountryState>(
            builder: (context, state) {
              if (state is CountryLoaded) {
                return ListView.builder(
                  padding: const EdgeInsets.all(0),
                  itemCount: state.countries.length,
                  itemBuilder: (context, index) {
                    final country = state.countries[index];
                    return ListTile(
                      leading: Text(country.emoji),
                      title: Text(country.name),
                      subtitle: Text(country.currency),
                    );
                  },
                ).expand();
              } else if (state is CountryError) {
                return Center(child: Text(state.message));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ).paddingAll(8),
    );
  }
}
