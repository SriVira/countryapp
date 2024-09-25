import 'dart:convert';

List<CountryModel> countryModelFromJson(String str) => List<CountryModel>.from(
    json.decode(str).map((x) => CountryModel.fromJson(x)));

String countryModelToJson(List<CountryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CountryModel {
  String code;
  String name;
  String emoji;
  String currency;
  //Continent continent;
  //List<Continent> languages;

  CountryModel({
    required this.code,
    required this.name,
    required this.emoji,
    required this.currency,
    // required this.continent,
    //required this.languages,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        code: json["code"],
        name: json["name"],
        emoji: json["emoji"],
        currency: json["currency"] ?? "None",
        //continent: Continent.fromJson(json["continent"]),
        //languages: List<Continent>.from(json["languages"].map((x) => Continent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "emoji": emoji,
        "currency": currency,
        //"continent": continent.toJson(),
        // "languages": List<dynamic>.from(languages.map((x) => x.toJson())),
      };
}

class Continent {
  String name;
  String code;

  Continent({
    required this.name,
    required this.code,
  });

  factory Continent.fromJson(Map<String, dynamic> json) => Continent(
        name: json["name"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
      };
}
