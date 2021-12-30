import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:get/get.dart';

class RateSheet extends StatefulWidget {
  final TeacherModel teacher;

  const RateSheet(this.teacher, {Key? key}) : super(key: key);

  @override
  _RateSheetState createState() => _RateSheetState();
}

class _RateSheetState extends State<RateSheet> {
  int rating = 0;
  bool showComment = false;
  TextEditingController comment = TextEditingController();

  void rate() {
    if ((rating > 2) || (rating < 2 && comment.text != '')) {
      widget.teacher.createRating(PersonModel.currentUser!, rating, comment.text);
    }
    Get.back();
    rating = 0;
    comment.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          RatingBar.builder(
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              this.rating = rating.round();
              setState(() {
                if (rating < 3) {
                  showComment = true;
                } else {
                  showComment = false;
                }
              });
            },
            minRating: 1,
            updateOnDrag: true,
            glow: false,
            itemSize: MediaQuery.of(context).size.width * 0.14,
            itemPadding: const EdgeInsets.symmetric(horizontal: 5),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: showComment == true
                ? TextField(
                    controller: comment,
                    decoration: const InputDecoration(labelText: 'объясните свой выбор:'),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(onPressed: rate, child: const Text('оценить')),
        ],
      ),
    );
  }
}
