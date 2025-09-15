import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:schoosch/controller/proxy_controller.dart';

import 'package:schoosch/model/attachments_model.dart';

class Attachments extends StatefulWidget {
  final List<AttachmentModel?> attachments;
  final int? limit;
  final bool readOnly;

  const Attachments({
    super.key,
    required this.attachments,
    this.limit,
    this.readOnly = false,
  });

  @override
  State<Attachments> createState() => _AttachmentsState();
}

class _AttachmentsState extends State<Attachments> {
  @override
  Widget build(BuildContext context) {
    var limit = widget.limit ?? 100;
    return Row(
      spacing: 8,
      children: [
        ...widget.attachments.take(limit).map((element) => Attachment(
              attachment: element,
              readOnly: widget.readOnly,
              onDelete: deleteAttachment,
            )),
        if (!widget.readOnly && widget.attachments.length < limit)
          IconButton(
            icon: Icon(Icons.add),
            onPressed: addAttachment,
          )
      ],
    );
  }

  void addAttachment() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      String fileName = result.files.first.name;
      var res = await Get.find<ProxyStore>().saveFile(fileName, fileBytes!);
      widget.attachments.add(res);
      setState(() {});
    }
  }

  void deleteAttachment(AttachmentModel attachment) async {
    await attachment.delete();
    widget.attachments.remove(attachment);
    setState(() {});
  }
}

class Attachment extends StatelessWidget {
  final AttachmentModel? attachment;
  final void Function(AttachmentModel)? onDelete;
  final bool readOnly;

  const Attachment({
    super.key,
    required this.attachment,
    required this.onDelete,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    if (attachment == null) {
      return SizedBox(width: 0);
    } else {
      return Container(
        color: Get.theme.primaryColor,
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Text(attachment!.filename),
            if (!readOnly)
              IconButton(
                onPressed: delete,
                icon: Icon(Icons.delete_outline),
              ),
            IconButton(
              onPressed: download,
              icon: Icon(Icons.download),
            ),
          ],
        ),
      );
    }
  }

  void delete() async {
    if (onDelete != null) onDelete!(attachment!);
  }

  void download() async {
    await Get.find<ProxyStore>().downloadFile(attachment!);
  }
}
