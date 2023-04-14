import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:sorsfuse/config/config.dart' as CONFIG;

class Avatar extends StatefulWidget {
  final double size;
  final String ImageURL;
  final XFile? ImageFile;
  bool isFile;
  Avatar({required this.size, required this.ImageURL, this.ImageFile, this.isFile=false});

  @override
  State<Avatar> createState() =>  new AvatarState();
}

class AvatarState extends State<Avatar> {

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.size,
        width: widget.size,
        decoration: BoxDecoration(
          color:Colors.white,
          border:Border.all(
            color:Color(0x55FFFFFF),
            width: widget.size/20,
          ),
          borderRadius: BorderRadius.circular(widget.size/2),
          //boxShadow: [BoxShadow(color:Colors.white,blurRadius: 2,spreadRadius: 4)]
        ),
        child: ClipOval(child:widget.ImageURL!=''?Image.network(widget.ImageURL, fit: BoxFit.cover,):widget.isFile?Image.file(io.File(widget.ImageFile!.path,),fit: BoxFit.cover,):SvgPicture.asset("assets/svg/default_avatar.svg", color: CONFIG.primaryColor, width: widget.size,height: widget.size,),)
    );
  }
}
