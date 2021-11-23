// To parse this JSON data, do
//
//     final radioStream = radioStreamFromJson(jsonString);

import 'dart:convert';

class RadioStream {
    RadioStream({
        required this.name,
        required this.url,
        required this.urlResolved,
        required this.homepage,
        required this.favicon,
        required this.tags,
        required this.bitrate,
    });

    String name;
    String url;
    String urlResolved;
    String homepage;
    String favicon;
    String tags;
    int bitrate;

    factory RadioStream.fromRawJson(String str) => RadioStream.fromJson(json.decode(str));


    factory RadioStream.fromJson(Map<String, dynamic> json) => RadioStream(
        name: json["name"].trim(),
        url: json["url"].trim(),
        urlResolved: json["url_resolved"].trim(),
        homepage: json["homepage"].trim(),
        favicon: json["favicon"].trim(),
        tags: json["tags"].trim(),
        bitrate: json["bitrate"],
    );


}