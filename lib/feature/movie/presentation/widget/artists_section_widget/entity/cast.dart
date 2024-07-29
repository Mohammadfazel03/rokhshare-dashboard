import 'package:dashboard/feature/media/data/remote/model/artist.dart';

enum Position {
  other(persianTitle: "دیگران", serverNameSpace: "Other"),
  actor(persianTitle: "بازیگر", serverNameSpace: "Actor"),
  director(persianTitle: "کارگردان", serverNameSpace: "Director"),
  producer(persianTitle: "نهیه کننده", serverNameSpace: "Producer"),
  writer(persianTitle: "نویسنده", serverNameSpace: "Writer"),
  editor(persianTitle: "تدوین گر", serverNameSpace: "Editor"),
  executorOfPlan(persianTitle: "مجری طرح", serverNameSpace: "Executor Of Plan"),
  productManager(
      persianTitle: "مدیر تولید", serverNameSpace: "Production Manager"),
  directorOfFilmingManager(
      persianTitle: "مدیر فیلم برداری",
      serverNameSpace: "Director Of Filming Manager");

  final String persianTitle;
  final String serverNameSpace;

  const Position({required this.persianTitle, required this.serverNameSpace});
}

class Cast {
  Artist? artist;
  Position? position;

  Cast({required this.artist, required this.position});

  Map<String, String?> toJson() {
    return {
      'artist_id': artist?.id.toString(),
      'position': position?.serverNameSpace
    };
  }

  Cast.fromJson(dynamic json) {
    artist = json['artist'] != null ? Artist.fromJson(json['artist']) : null;
    if (json['position'] != null) {
      for (final pos in Position.values) {
        if (pos.serverNameSpace == json['position']) {
          position = pos;
          break;
        }
      }
    }
  }
}
