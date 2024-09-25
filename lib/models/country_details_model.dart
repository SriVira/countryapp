import 'dart:convert';

CountryDetailsModel countryDetailsModelFromJson(String str) =>
    CountryDetailsModel.fromJson(json.decode(str));

String countryDetailsModelToJson(CountryDetailsModel data) =>
    json.encode(data.toJson());

class CountryDetailsModel {
  String name;
  String code;
  String native;
  String capital;
  String emoji;
  String currency;
  List<Language> languages;

  CountryDetailsModel({
    required this.name,
    required this.code,
    required this.native,
    required this.capital,
    required this.emoji,
    required this.currency,
    required this.languages,
  });

  factory CountryDetailsModel.fromJson(Map<String, dynamic> json) =>
      CountryDetailsModel(
        name: json["name"],
        code: json["code"],
        native: json["native"],
        capital: json["capital"] ?? "None",
        emoji: json["emoji"],
        currency: json["currency"] ?? "None",
        languages: List<Language>.from(
            json["languages"].map((x) => Language.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
        "native": native,
        "capital": capital,
        "emoji": emoji,
        "currency": currency,
      };
}

class Language {
  String code;
  String name;

  Language({
    required this.code,
    required this.name,
  });

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        code: json["code"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
      };
}
