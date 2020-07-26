import 'package:global_configuration/global_configuration.dart';

class Media {

  String id;
  String name;
  String url;
  String thumb;
  String icon;
  String size;

  Media() {
    url = "${GlobalConfiguration().getString('base_url')}images/image_default.png";
    thumb = "${GlobalConfiguration().getString('base_url')}images/image_default.png";
    icon = "${GlobalConfiguration().getString('base_url')}images/image_default.png";
  }
}
