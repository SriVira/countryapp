import 'package:countryapp/bloc/country_details_bloc.dart';
import 'package:countryapp/models/country_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class CountryDetails extends StatefulWidget {
  final CountryModel countryModel;

  const CountryDetails({super.key, required this.countryModel});

  @override
  State<CountryDetails> createState() => _CountryDetailsState();
}

class _CountryDetailsState extends State<CountryDetails> {
  final countryDetails = CountryDetailsBloc();

  @override
  void initState() {
    super.initState();
    countryDetails.add(FetchCountryDetails(code: widget.countryModel.code));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.deepPurple,
        title: Text(
          widget.countryModel.name,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<CountryDetailsBloc, CountryDetailsState>(
        bloc: countryDetails,
        builder: (context, state) {
          if (state is CountryDetailsLoaded) {
            return Column(
              children: [
                ListTile(
                  leading: Text(
                    state.country.emoji,
                    style: const TextStyle(fontSize: 40),
                  ),
                  title: Text(state.country.name),
                  subtitle: Text(state.country.code),
                ),
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Capital"),
                    Text(state.country.capital)
                  ],
                ),
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Currency"),
                    Text(state.country.currency)
                  ],
                ),
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Languages"),
                    Wrap(
                      direction: Axis.vertical,
                      verticalDirection: VerticalDirection.up,
                      children: state.country.languages.map((language) {
                        return Text(language.name);
                      }).toList(),
                    )
                  ],
                )
              ],
            ).paddingAll(16);
          }

          if (state is CountryDetailsError) {
            return Center(child: Text(state.message));
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
