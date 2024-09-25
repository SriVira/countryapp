import 'dart:convert';
import 'dart:io';

import 'package:countryapp/config/graphql_config.dart';
import 'package:countryapp/models/country_details_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class CountryDetailsEvent extends Equatable {
  const CountryDetailsEvent();

  @override
  List<Object?> get props => [];
}

class FetchCountryDetails extends CountryDetailsEvent {
  final String code;

  const FetchCountryDetails({required this.code});

  @override
  List<Object?> get props => [code];
}

class CountryDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CountryDetailsInitial extends CountryDetailsState {}

class CountryDetailsLoading extends CountryDetailsState {}

class CountryDetailsLoaded extends CountryDetailsState {
  final CountryDetailsModel country;

  CountryDetailsLoaded({required this.country});

  @override
  List<Object?> get props => [country];
}

class CountryDetailsError extends CountryDetailsState {
  final String message;

  CountryDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class CountryDetailsBloc
    extends Bloc<CountryDetailsEvent, CountryDetailsState> {
  CountryDetailsBloc() : super(CountryDetailsInitial()) {
    on<CountryDetailsEvent>((event, emit) async {
      final client = GraphQLConfig.initializeClient();

      if (event is FetchCountryDetails) {
        emit(CountryDetailsLoading());
        try {
          final result = await client.value.query(
            QueryOptions(
              document: gql("""
                query GetCountry(\$code: ID!) {
                  country(code: \$code) {
                    name
                    code
                    native
                    capital
                    emoji
                    currency
                    languages {
                      code
                      name
                    }
                  }
                }
            """),
              variables: {
                'code': event.code,
              },
            ),
          );

          //print(result);

          if (result.hasException) {
            emit(CountryDetailsError(message: result.exception.toString()));
          }
          emit(CountryDetailsLoaded(
              country: countryDetailsModelFromJson(
                  jsonEncode(result.data?['country']))));
        } on SocketException {
          emit(CountryDetailsError(message: "No Internet Connection"));
        } on HttpException {
          emit(CountryDetailsError(message: "No Service Found"));
        } on FormatException {
          emit(CountryDetailsError(message: "Invalid Response Format"));
        } catch (e) {
          emit(CountryDetailsError(message: e.toString()));
        }
      }
    });
  }
}
