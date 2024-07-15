import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  final String name;
  final String avatar;

  const UserCard({
    super.key,
    required this.name,
    required this.avatar,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.1,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 1),
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4)
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: size.width * 0.02,
          ),
          widget.avatar.isNotEmpty
              ? Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(widget.avatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : const Icon(
                  Icons.account_circle,
                  size: 50,
                  color: Colors.blueAccent,
                ),
          SizedBox(
            width: size.width * 0.03,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.name.isNotEmpty
                  ? Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : const CircularProgressIndicator(),
              const Text(
                'BQLDA',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Color.fromRGBO(167, 171, 195, 1),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
