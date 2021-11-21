import 'package:flutter/material.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:schoosch/model/people_model.dart';
import 'package:get/get.dart';

class RateSheet extends StatefulWidget {
  RateSheet(this.teach, {Key? key}) : super(key: key);
  PeopleModel teach;
  @override
  _RateSheetState createState() => _RateSheetState();
}

class _RateSheetState extends State<RateSheet> {
  void rate() {
    var store = Get.find<FStore>();
    if((rating > 2) || (rating < 2 && cont.text != '')) {
      store.saveRate(widget.teach.id, store.currentUser.id, DateTime.now(),
        rating, cont.text);
    }
    Get.back();
    rating = 0;
    cont.clear();
  }

  int rating = 0;
  bool showComment = false;
  TextEditingController cont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Column(
          children: [
            RatingBar.builder(
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                this.rating = rating.round();
                setState(() {
                  if(rating < 3) {
                    showComment = true;
                  }
                  else {
                    showComment = false;
                  }
                });
              },
              minRating: 1,
              updateOnDrag: true,
              glow: false,
              itemSize: 60.0,
              itemPadding: EdgeInsets.symmetric(horizontal: 10),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: showComment == true
                  ? TextField(
                      controller: cont,
                      decoration: InputDecoration(labelText: 'объясните свой выбор:'),
                    )
                  : Container(),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(onPressed: rate, child: Text("оценить")),
          ],
        ),
      ),
    );
  }
}
