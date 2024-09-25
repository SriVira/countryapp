import 'dart:convert';
import 'dart:io';

import 'package:countryapp/config/graphql_config.dart';
import 'package:countryapp/models/country_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class CountryEvent extends Equatable {
  const CountryEvent();

  @override
  List<Object?> get props => [];
}

class FetchCountries extends CountryEvent {
  final int limit;
  final int offset;

  const FetchCountries({this.limit = 10, this.offset = 0});

  @override
  List<Object?> get props => [limit, offset];
}

class SearchCountries extends CountryEvent {
  final String query;

  const SearchCountries({required this.query});

  @override
  List<Object?> get props => [query];
}

class CountryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CountryInitial extends CountryState {}

class CountryLoading extends CountryState {}

class CountryLoaded extends CountryState {
  final List<CountryModel> countries;

  CountryLoaded({required this.countries});

  @override
  List<Object?> get props => [countries];
}

class CountryError extends CountryState {
  final String message;

  CountryError({required this.message});

  @override
  List<Object?> get props => [message];
}

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  CountryBloc() : super(CountryInitial()) {
    on<CountryEvent>((event, emit) async {
      final client = GraphQLConfig.initializeClient();

      if (event is FetchCountries) {
        emit(CountryLoading());
        try {
          final result = await client.value.query(
            QueryOptions(
              document: gql("""
            query{
              countries {
                code
                name 
                emoji 
                currency 
              }
            }
            """),
            ),
          );

          if (result.hasException) {
            emit(CountryError(message: result.exception.toString()));
          }
          emit(CountryLoaded(
              countries:
                  countryModelFromJson(jsonEncode(result.data?['countries']))));
        } on SocketException {
          emit(CountryError(message: "No Internet Connection"));
        } on HttpException {
          emit(CountryError(message: "No Service Found"));
        } on FormatException {
          emit(CountryError(message: "Invalid Response Format"));
        } catch (e) {
          emit(CountryError(message: e.toString()));
        }
      }

      if (event is SearchCountries) {
        emit(CountryInitial());
        emit(CountryLoading());
        try {
          final result = await client.value.query(QueryOptions(
            document: gql("""
              query GetCountries(\$name: String!) {
                countries(filter: { name: { eq: \$name } }) {
                  code
                  name
                  emoji
                  currency
                }
              }
            """),
            variables: {
              'name':
                  event.query, // Replace this with your dynamic country name
            },
          ));

          if (result.hasException) {
            emit(CountryError(message: result.exception.toString()));
          }

          print(result);

          emit(CountryLoaded(
              countries:
                  countryModelFromJson(jsonEncode(result.data?['countries']))));
        } on SocketException {
          emit(CountryError(message: "No Internet Connection"));
        } on HttpException {
          emit(CountryError(message: "No Service Found"));
        } on FormatException {
          emit(CountryError(message: "Invalid Response Format"));
        } catch (e) {
          emit(CountryError(message: e.toString()));
        }
      }
    });
  }
}
