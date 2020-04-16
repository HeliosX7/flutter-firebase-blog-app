class Post {
  String image, desc, date, time;
  String postKey;
  Post(this.image, this.desc, this.date, this.time, this.postKey);

  toJson() {
    return {
      'image': image,
      'desc': desc,
      'date': date,
      'time': time,
    };
  }
}
