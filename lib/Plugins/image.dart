import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:the_man_who_sold_the_world/Plugins/Colores.dart';
import 'package:the_man_who_sold_the_world/Plugins/Widgets/Containers.dart';

final c = Colores();

class ImageSelector extends StatefulWidget {
  final Function(Uint8List?) onImageSelected;
  final Uint8List? initialImageBytes;

  const ImageSelector({
    super.key,
    required this.onImageSelected,
    this.initialImageBytes,
  });

  @override
  State<ImageSelector> createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _imageBytes = widget.initialImageBytes;
  }

  Future<void> pickImage() async {
    try {
      Uint8List? bytes;

      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          withData: true,
        );
        bytes = result?.files.single.bytes;
      } else {
        final XFile? image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
        );
        if (image != null) bytes = await image.readAsBytes();
      }

      if (bytes != null) {
        setState(() {
          _imageBytes = bytes;
        });
        widget.onImageSelected(bytes);
      }
    } catch (e) {
      print("Error al seleccionar imagen: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pickImage,
      child: CustomContainer(
        width: 150,
        height: 150,
        child: Center(
          child: _imageBytes != null
              ? Image.memory(_imageBytes!, fit: BoxFit.cover)
              : Icon(Icons.add_a_photo, size: 50, color: Colores().textPrimary),
        ),
      ),
    );
  }
}
