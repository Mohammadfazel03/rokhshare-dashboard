import 'package:dashboard/feature/media/data/remote/model/artist.dart';

enum Role {
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

  const Role({required this.persianTitle, required this.serverNameSpace});
}

class Cast {
  final Artist artist;
  final Role role;

  Cast({required this.artist, required this.role});

  Map<String, String> toJson() {
    return {
      'artist_id': artist.id.toString(),
      'position': role.serverNameSpace
    };
  }
}
