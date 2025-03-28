import 'dart:convert';

/// page : 1
/// limit : 1
/// news_category_id : 1

BlogInput newsInputFromJson(String str) => BlogInput.fromJson(json.decode(str));

String newsInputToJson(BlogInput data) => json.encode(data.toJson());

class BlogInput {
  BlogInput({
    this.page,
    this.limit,
    this.slug,
  });

  BlogInput.fromJson(dynamic json) {
    page = json['page'];
    limit = json['limit'];
    slug = json['slug'];
  }

  num? page;
  num? limit;
  String? slug;

  BlogInput copyWith({
    num? page,
    num? limit,
    String? slug,
  }) =>
      BlogInput(
        page: page ?? this.page,
        limit: limit ?? this.limit,
        slug: slug ?? this.slug,
      );

  Map<String, dynamic>? toJson() {
    final map = <String, dynamic>{};
    map['page'] = page;
    map['limit'] = limit;
    if (slug?.isNotEmpty == true) {
      map['slug'] = slug;
    }
    return map;
  }
}
