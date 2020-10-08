import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:Mazaj/Theme/app_colors.dart';

class PhotoPickerRow extends StatefulWidget {
  final Function onPhotoChanged;
  final String title;
  final String hint;
  PhotoPickerRow({this.onPhotoChanged, this.title, this.hint});
  @override
  _PhotoPickerRowState createState() => _PhotoPickerRowState();
}

class _PhotoPickerRowState extends State<PhotoPickerRow> {
  File pickedFile;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.01,
        horizontal: size.width * 0.03,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 18),
                ),
                widget.hint == null
                    ? Container()
                    : Align(
                        alignment: Alignment.centerRight,
                        child: Text(widget.hint),
                      )
              ],
            ),
          ),
          SizedBox(
            width: size.width * 0.03,
          ),
          InkWell(
            onTap: () async {
              final picker = ImagePicker();
              var image = await picker.getImage(source: ImageSource.gallery);
              if (image != null) {
                setState(() {
                  pickedFile = File(image.path);
                  widget.onPhotoChanged(pickedFile);
                });
              }
            },
            child: pickedFile == null
                ? Container(
                    width: size.width * 0.15,
                    height: size.height * 0.07,
                    color: AppColors.primaryColor,
                    child: Center(
                      child: Icon(
                        Icons.add,
                        size: size.aspectRatio * 66,
                        color: Colors.black,
                      ),
                    ),
                  )
                : Container(
                    width: size.width * 0.15,
                    height: size.height * 0.07,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: size.aspectRatio * 120,
                      backgroundImage: pickedFile == null
                          ? AssetImage('assets/images/avatar.png')
                          : FileImage(
                              pickedFile,
                            ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
