class AppUser {
  String username;
  String phone;
  String serial;
  bool isfibernet;
  String address;
  int totaldue;
  int currentpackamount;
  String currentpacksummary;
  String currentpackpaidon;
  String userid;

  AppUser(
      this.username,
      this.phone,
      this.serial,
      this.isfibernet,
      this.address,
      this.totaldue,
      this.currentpackamount,
      this.currentpacksummary,
      this.currentpackpaidon,
      this.userid) {
    var arr = username.split(' ');
    String res = '';
    for (int i = 0; i < arr.length; i++) {
      res = res + arr[i][0].toUpperCase() + arr[i].substring(1) + " ";
    }
    this.username = res.substring(0, res.length - 1);
  }
}
