class Memes {
  int id;
  String url_memes;
  String teks_atas;
  String teks_bawah;
  int jumlah_like;
  String username;
  // List? comments;

  Memes(
      {required this.id,
      required this.url_memes,
      required this.teks_atas,
      required this.teks_bawah,
      required this.jumlah_like,
      // this.comments,
      required this.username,});
  factory Memes.fromJson(Map<String, dynamic> json) {
    return Memes(
        id: json['memes_id'],
        url_memes: json['url_memes'],
        teks_atas: json['teks_atas'],
        teks_bawah: json['teks_bawah'],
        jumlah_like: json['jumlah_like'] == null ? 0 : json['jumlah_like'],
        username: json['username'],
        // comments: json['comments']
        );
  }
  // @override
  // String toString() {
  //   return title;
  // }
}



List<Memes> Meme = [];