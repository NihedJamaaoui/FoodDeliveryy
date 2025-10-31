import 'package:flutter/material.dart';
import 'package:projet/Utilities/colors.dart';
import 'package:projet/Utilities/constant.dart';
import 'package:projet/models/food.dart';


class DetailScreen extends StatefulWidget {

  final Food detail;

  const DetailScreen({Key? key, required this.detail})
      : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

@override
State<DetailScreen> createState() => _DetailScreenState();


class _DetailScreenState extends State<DetailScreen> {
  int? _value = 1;
  int s = 1;

  @override
  Widget build(BuildContext context) {
    Size sc = Utils().getScreenSize();
    return Scaffold(
      backgroundColor: backgroundclr,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: sc.height * 0.270,
                    width: sc.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.detail.image),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        height: sc.height * 0.043,
                        width: sc.width * 0.1,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xff757283)),
                        child: const Center(
                            child: Icon(
                              Icons.favorite_rounded,
                              color: whiteclr,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, right: 12, left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: sc.height * 0.010,
                    ),
                    Text(
                      widget.detail.name,
                      style: const TextStyle(
                          fontSize: 21.5,
                          fontWeight: FontWeight.bold,
                          color: whiteclr),
                    ),
                    SizedBox(
                      height: sc.height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.detail.price.toString()+" Dt",
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: whiteclr),
                        ),
                        Row(
                          children: [
                            Container(
                              height: sc.height * 0.050,
                              width: sc.width * 0.08,
                              decoration: const BoxDecoration(
                                  color: lbackgroundclr,
                                  shape: BoxShape.circle),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.remove,
                                  color: whiteclr,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (s > 1) {
                                      s--;
                                    }
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: sc.width * 0.04,
                            ),
                            Text(
                              s.toString(),
                              style: const TextStyle(
                                fontSize: 22,
                                color: whiteclr,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: sc.width * 0.04,
                            ),
                            Container(
                              height: sc.height * 0.050,
                              width: sc.width * 0.08,
                              decoration: const BoxDecoration(
                                  color: lbackgroundclr,
                                  shape: BoxShape.circle),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.add,
                                  color: whiteclr,
                                ),
                                onPressed: () {
                                  setState(() {
                                    s++;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sc.height * 0.006,
                    ),
                    Text(
                      widget.detail.description,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[400],
                      ),
                    ),
                    SizedBox(
                      height: sc.height * 0.015,
                    ),
                    const Text(
                      "Choose Additive",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: whiteclr,
                      ),
                    ),
                    SizedBox(
                      height: sc.height * 0.01,
                    ),
                    Row(
                      children: [
                        Container(
                          height: sc.height * 0.080,
                          width: sc.width * 0.15,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "https://images-prod.healthline.com/hlcmsresource/images/AN_images/healthiest-cheese-1296x728-swiss.jpg"),
                              ),
                              color: Color(0xff3A3843),
                              shape: BoxShape.circle),
                        ),
                        SizedBox(
                          width: sc.width * 0.03,
                        ),
                        const Text(
                          "Cheese",
                          style: TextStyle(
                              color: whiteclr,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: sc.width * 0.347,
                        ),
                        Row(
                          children: [
                            const Text(
                              "+ ${3.2} Dt",
                              style: TextStyle(color: whiteclr, fontSize: 16),
                            ),
                            Radio(
                                value: 1,
                                groupValue: _value,
                                onChanged: (int? value) {
                                  setState(() {
                                    _value = value!;
                                  });
                                }),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sc.height * 0.015,
                    ),
                    Row(
                      children: [
                        Container(
                          height: sc.height * 0.080,
                          width: sc.width * 0.15,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "https://resize.prod.femina.ladmedia.fr/rblr/1200,806/img/var/2023-03/1-recette-oeufs-au-plat.jpg"),
                              ),
                              color: Color(0xff3A3843),
                              shape: BoxShape.circle),
                        ),
                        SizedBox(
                          width: sc.width * 0.03,
                        ),
                        const Text(
                          "Egg",
                          style: TextStyle(
                              color: whiteclr,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: sc.width * 0.410,
                        ),
                        Row(
                          children: [
                            const Text(
                              "+ ${3.5} Dt",
                              style: TextStyle(color: whiteclr, fontSize: 16),
                            ),
                            Radio(
                                value: 2,
                                groupValue: _value,
                                onChanged: (int? value) {
                                  setState(() {
                                    _value = value!;
                                  });
                                }),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sc.height * 0.015,
                    ),
                    Row(
                      children: [
                        Container(
                          height: sc.height * 0.080,
                          width: sc.width * 0.15,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "https://upload.wikimedia.org/wikipedia/commons/9/9d/Tomato.png"),
                              ),
                              color: Color(0xff3A3843),
                              shape: BoxShape.circle),
                        ),
                        SizedBox(
                          width: sc.width * 0.0305,
                        ),
                        const Text(
                          "Tomato",
                          style: TextStyle(
                              color: whiteclr,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: sc.width * 0.337,
                        ),
                        Row(
                          children: [
                            const Text(
                              "+ ${4.2} Dt",
                              style: TextStyle(color: whiteclr, fontSize: 16),
                            ),
                            Radio(
                                value: 3,
                                groupValue: _value,
                                onChanged: (int? value) {
                                  setState(() {
                                    _value = value!;
                                  });
                              }),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sc.height * 0.015,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () { _showAddToCartDialog(); },
                        child: Container(
                          height: sc.height * 0.06,
                          width: sc.width * 0.75,
                          decoration: BoxDecoration(
                            color: primaryclr,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              "Add to Cart",
                              style: TextStyle(
                                fontSize: 15,
                                color: whiteclr,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showAddToCartDialog() {
    int itemPrice = widget.detail.price * s;
    double additivePrice = 0.0;

    switch (_value) {
      case 1:
        additivePrice = 3.2;
        break;
      case 2:
        additivePrice = 3.5;
        break;
      case 3:
        additivePrice = 4.2;
        break;
    }

    double totalPrice = itemPrice + additivePrice;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey,
          contentPadding: EdgeInsets.zero,
          content: Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Item Added to Cart', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Divider(color: Colors.orangeAccent),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Item: ${widget.detail.name}'),
                      SizedBox(height: 8),
                      Text('Quantity: $s'),
                      Text('Additive Price: +${additivePrice.toStringAsFixed(2)} Dt'),
                      Divider(color: Colors.orangeAccent),
                      Text('Total Price: ${totalPrice.toStringAsFixed(2)} Dt'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}