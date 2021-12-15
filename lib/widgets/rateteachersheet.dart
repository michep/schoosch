import 'package:flutter/material.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:schoosch/model/people_model.dart';
import 'package:get/get.dart';

class RateSheet extends StatefulWidget {
  final TeacherModel teach;

  const RateSheet(this.teach, {Key? key}) : super(key: key);

  @override
  _RateSheetState createState() => _RateSheetState();
}

class _RateSheetState extends State<RateSheet> {
  int rating = 0;
  bool showComment = false;
  TextEditingController cont = TextEditingController();

  void rate() {
    var store = Get.find<FStore>();
    if ((rating > 2) || (rating < 2 && cont.text != '')) {
      store.saveTeacherRating(widget.teach, store.currentUser!, DateTime.now(), rating, cont.text);
    }
    Get.back();
    rating = 0;
    cont.clear();
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
                    controller: cont,
                    decoration: const InputDecoration(labelText: 'объясните свой выбор:'),
                  )
                : Container(),
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
