import 'package:countryapp/bloc/country_bloc.dart';
import 'package:countryapp/controllers/auth_controller.dart';
import 'package:countryapp/models/country_model.dart';
import 'package:countryapp/screens/country_details.dart';
import 'package:countryapp/widgets/Shimmer.dart';
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
  final _debouncer = Debouncer(milliseconds: 1000);

  List<CountryModel> countries = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      BlocProvider.of<CountryBloc>(context).add(const FetchCountries());
    }
  }

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
          PrimarySearchBar(
            hintText: "Search Countries",
            onChanged: (query) {
              if (query.isEmpty) {
                BlocProvider.of<CountryBloc>(context)
                    .add(const FetchCountries());
              } else {
                _debouncer.run(() {
                  BlocProvider.of<CountryBloc>(context)
                      .add(SearchCountries(query: query));
                });
              }
            },
          ),
          16.height,
          BlocConsumer<CountryBloc, CountryState>(
            listener: (context, state) {
              if (state is CountryLoaded) {
                countries.addAll(state.countries);
                setState(() {});
              }
            },
            builder: (context, state) {
              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(0),
                itemCount: state is CountryLoading
                    ? countries.length + 12
                    : countries.length,
                itemBuilder: (context, index) {
                  if (countries.length <= index) {
                    return ShimmerWidget.rectangular(
                      width: 100,
                      shapeBorder: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      height: 75,
                      margin: const EdgeInsets.all(4),
                    );
                  } else {
                    final country = countries[index];
                    return ListTile(
                      leading: Text(
                        country.emoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                      title: Text(country.name),
                      subtitle: Text(country.code),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CountryDetails(countryModel: country)),
                        );
                      },
                    );
                  }
                },
              ).expand();
            },
          ),
        ],
      ).paddingAll(8),
    );
  }
}
