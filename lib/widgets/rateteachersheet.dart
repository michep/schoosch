import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:get/get.dart';

class RateSheet extends StatefulWidget {
  final TeacherModel _teacher;

  const RateSheet(this._teacher, {Key? key}) : super(key: key);

  @override
  RateSheetState createState() => RateSheetState();
}

class RateSheetState extends State<RateSheet> {
  int _rating = 0;
  bool _showComment = false;
  final TextEditingController _comment = TextEditingController();

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
              _rating = rating.round();
              setState(() {
                if (rating < 3) {
                  _showComment = true;
                } else {
                  _showComment = false;
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
            child: _showComment == true
                ? TextField(
                    controller: _comment,
                    decoration: const InputDecoration(labelText: 'объясните свой выбор:'),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(onPressed: _rate, child: const Text('оценить')),
        ],
      ),
    );
  }

  void _rate() {
    if ((_rating > 2) || (_rating < 2 && _comment.text != '')) {
      widget._teacher.createRating(PersonModel.currentUser!, _rating, _comment.text);
    }
    _rating = 0;
    _comment.clear();
    Get.back();
  }
}
