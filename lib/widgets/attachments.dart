import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

import 'package:schoosch/model/attachments_model.dart';

class Attachments extends StatefulWidget {
  final List<AttachmentModel?> attachments;
  final int? limit;
  final bool readOnly;
  final bool localOnly;

  const Attachments({
    super.key,
    required this.attachments,
    this.limit,
    this.readOnly = false,
    this.localOnly = false,
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
        ...widget.attachments
            .take(limit)
            .map(
              (element) => Attachment(
                attachment: element,
                readOnly: widget.readOnly,
                localOnly: widget.localOnly,
                onDelete: deleteAttachment,
              ),
            ),
        if (!widget.readOnly && widget.attachments.length < limit)
          IconButton(
            icon: Icon(Icons.add),
            onPressed: addAttachment,
          ),
      ],
    );
  }

  void addAttachment() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      String fileName = result.files.first.name;
      var res = AttachmentModel.fromMap(
        (widget.attachments.length + 1).toString(),
        {
          'filename': fileName,
          'filebytes': fileBytes,
        },
      );
      if (!(widget.localOnly)) {
        // res = await Get.find<ProxyStore>().saveFile(fileName, fileBytes!);
        res.save();
      }
      setState(() {
        widget.attachments.add(res);
      });
    }
  }

  void deleteAttachment(AttachmentModel attachment) async {
    // await attachment.delete();
    setState(() {
      widget.attachments.remove(attachment);
    });
  }
}

class Attachment extends StatelessWidget {
  final AttachmentModel? attachment;
  final void Function(AttachmentModel)? onDelete;
  final bool readOnly;
  final bool localOnly;
  final bool isExpanded;

  const Attachment({
    super.key,
    required this.attachment,
    required this.onDelete,
    this.readOnly = false,
    this.localOnly = false,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    if (attachment == null) {
      return SizedBox(width: 0);
    } else {
      return Container(
        padding: EdgeInsets.all(8),
        constraints: BoxConstraints(
          maxWidth: isExpanded ? 600 : 200,
          minWidth: 50
        ),
        decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                attachment!.filename,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(),
              ),
            ),
            if (!readOnly)
              IconButton(
                onPressed: delete,
                icon: Icon(Icons.delete_outline),
              ),
            if (!localOnly)
              IconButton(
                onPressed: () {
                  attachment!.download();
                },
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
}
