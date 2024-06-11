import 'package:flutter/material.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  TransactionScreenState createState() => TransactionScreenState();
}

class TransactionScreenState extends State<TransactionScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 75,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(17.5),
                    bottomRight: Radius.circular(17.5),
                  ),
                  color: Colors.deepPurple,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 22, left: 16, right: 16),
                  child: Text(
                    'Transaction',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20, left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'On Going',
                      style: TextStyle(
                        color: Color(0xFF383C45),
                        fontSize: 22,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 600, // Atur tinggi sesuai kebutuhan
                      child: ListView.builder(
                        itemCount: creators_ongoing.length,
                        itemBuilder: (context, index) {
                          final creator = creators_ongoing[index];
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Image.asset(creator.imagePath),
                                const SizedBox(width: 16.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(creator.role),
                                    Text(
                                      creator.name,
                                      style: const TextStyle(
                                        color: Color(0xFF191919),
                                        fontSize: 16,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      'Rp${creator.price}',
                                      style: const TextStyle(
                                        color: Color(0xFFF26D20),
                                        fontSize: 12,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.star, color: Colors.yellow),
                                        Text(
                                          '${creator.rating} | ${creator.participants} Partisipan',
                                          style: const TextStyle(
                                            color: Color(0xFF8C8C8C),
                                            fontSize: 12,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20, left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Done',
                      style: TextStyle(
                        color: Color(0xFF383C45),
                        fontSize: 22,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 600, // Atur tinggi sesuai kebutuhan
                      child: ListView.builder(
                        itemCount: creators_done.length,
                        itemBuilder: (context, index) {
                          final creator = creators_done[index];
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Image.asset(creator.imagePath),
                                const SizedBox(width: 16.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(creator.role),
                                    Text(
                                      creator.name,
                                      style: const TextStyle(
                                        color: Color(0xFF191919),
                                        fontSize: 16,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      'Rp${creator.price}',
                                      style: const TextStyle(
                                        color: Color(0xFFF26D20),
                                        fontSize: 12,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.star, color: Colors.yellow),
                                        Text(
                                          '${creator.rating} | ${creator.participants} Partisipan',
                                          style: const TextStyle(
                                            color: Color(0xFF8C8C8C),
                                            fontSize: 12,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Creator {
  final String name;
  final String role;
  final int price;
  final double rating;
  final int participants;
  final String imagePath;

  Creator({
    required this.name,
    required this.role,
    required this.price,
    required this.rating,
    required this.participants,
    required this.imagePath,
  });
}

final List<Creator> creators_ongoing = [
    Creator(
      name: 'Childfree itu pilihan?',
      role: 'Educator',
      price: 50000,
      rating: 4.2,
      participants: 180,
      imagePath: 'assets/show1.png',
    ),
    Creator(
      name: 'Nobar Queen of Tears',
      role: 'Motivator',
      price: 50000,
      rating: 4.8,
      participants: 80,
      imagePath: 'assets/show2.png',
    ),
    // Creator(
    //   name: 'Cara membuat konten',
    //   role: 'Barista',
    //   price: 50000,
    //   rating: 4.9,
    //   participants: 80,
    //   imagePath: 'assets/show3.png',
    // ),
    // Creator(
    //   name: 'Review Villa di Bali',
    //   role: 'Educator',
    //   price: 50000,
    //   rating: 4.9,
    //   participants: 80,
    //   imagePath: 'assets/show4.png',
    // ),
    // Creator(
    //   name: 'Belajar Penting',
    //   role: 'Selebgram',
    //   price: 50000,
    //   rating: 4.9,
    //   participants: 80,
    //   imagePath: 'assets/show5.png',
    // ),
];

final List<Creator> creators_done = [
    // Creator(
    //   name: 'Childfree itu pilihan?',
    //   role: 'Educator',
    //   price: 50000,
    //   rating: 4.2,
    //   participants: 180,
    //   imagePath: 'assets/show1.png',
    // ),
    // Creator(
    //   name: 'Nobar Queen of Tears',
    //   role: 'Motivator',
    //   price: 50000,
    //   rating: 4.8,
    //   participants: 80,
    //   imagePath: 'assets/show2.png',
    // ),
    Creator(
      name: 'Cara membuat konten',
      role: 'Barista',
      price: 50000,
      rating: 4.9,
      participants: 80,
      imagePath: 'assets/show3.png',
    ),
    Creator(
      name: 'Review Villa di Bali',
      role: 'Educator',
      price: 50000,
      rating: 4.9,
      participants: 80,
      imagePath: 'assets/show4.png',
    ),
    Creator(
      name: 'Belajar Penting',
      role: 'Selebgram',
      price: 50000,
      rating: 4.9,
      participants: 80,
      imagePath: 'assets/show5.png',
    ),
];