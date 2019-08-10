import 'package:jam_i/categories/category.dart';


class Notification{
  String title;
  String body;
  String assetPhoto;
  String assetVideo ;
  String categories;
  String date;
  String time;
  String urgency;

  Notification({this.title , this.body, this.assetPhoto, this.assetVideo, this.categories, this.date, this.time, this.urgency});


}

List<Notification> notifs = [
  Notification({'Broken Pipe AGAIN', 'Traffic is piled up on the Mandella once more because of this broken pipe issue. WE NEED INTERVENTION NOW!','assets/images/traffic_pileup.jpg', ' ', 'by John Green and Rodrigo Corral'),

];