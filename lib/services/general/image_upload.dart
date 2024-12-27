import 'dart:convert';

import 'package:aws_s3_upload_lite/aws_s3_upload_lite.dart';
import 'package:ecofy/services/general/localstorage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<Uint8List?> pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
  return null;
}

Future<String?> selectImage(
    String userId, DatabaseService database, WebSocketChannel socket,
    {bool isProfilePic = true, int count = 0}) async {
  await dotenv.load(fileName: '.env');
  Uint8List? img = await pickImage(ImageSource.gallery);
  if (img != null) {
    AwsS3.uploadUint8List(
      accessKey: dotenv.env["accessKey"]!,
      secretKey: dotenv.env["secretKey"]!,
      file: img,
      bucket: "ecofy-app",
      region: "eu-central-1",
      destDir: isProfilePic ? "profilePics" : userId,
      filename: isProfilePic ? "$userId.png" : "$count.png",
    );

    var picURL = isProfilePic
        ? "https://ecofy-app.s3.eu-central-1.amazonaws.com/profilePics/$userId.png"
        : "https://ecofy-app.s3.eu-central-1.amazonaws.com/$userId/$count.png";
    
    database.updateValue(isProfilePic ? "profilePic" : "countUploadedPhotos", picURL, userId);

    socket.sink.add(jsonEncode({
      "action": "updateUserData",
      "userId": userId,
      "key": isProfilePic ? "profilePic" : "countUploadedPhotos",
      "value": isProfilePic ? picURL : count++
    }));
    return picURL;
  }
  return null;
}
