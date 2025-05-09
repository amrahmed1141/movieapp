import 'package:flutter/material.dart';
import 'package:movieapp/constant.dart';

class AppColor {
  static const Color primaryColor =Color(0xFFffb43b);
  static const Color white = Colors.white;
  static const Color black = Colors.grey;
}

class SeatWidget extends StatefulWidget {
  const SeatWidget({
    super.key,
    this.onTap,
    required this.seatNumber,
    this.width = 50,
    this.height = 50,
    this.isSelected = false,
    this.isAvailable = true,
   
  });

  final void Function()? onTap;
  final String seatNumber;
  final double width;
  final double height;
  final bool isSelected;
  final bool isAvailable;
  

  @override
  State<SeatWidget> createState() => _SeatWidgetState();
}

class _SeatWidgetState extends State<SeatWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isAvailable ? widget.onTap : null,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.isAvailable
              ? widget.isSelected
                  ? buttonColor
                  : Colors.white
              : Colors.grey,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: widget.isAvailable
                ? widget.isSelected
                    ? buttonColor
                    : Colors.grey
                : Colors.grey,
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          widget.seatNumber,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: widget.isAvailable
                    ? Colors.black.withOpacity(0.7)
                    : Colors.black.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }
}

class SeatInfoWidget extends StatelessWidget {
  const SeatInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         SeatWidget(
          seatNumber: "",
          width: 24,
          height: 24,
          isAvailable: false,
        ),
         SizedBox(width: 8),
        Text(
          "Reserved",
          style: TextStyle(color: Colors.white,fontSize: 16),
        ),
        SizedBox(width: 16),
         SeatWidget(
          seatNumber: "",
          width: 24,
          height: 24,
          isAvailable: true,
          isSelected: true,
        ),
         SizedBox(width: 8),
        Text(
          "Selected",
          style: TextStyle(color: Colors.white,fontSize: 16),
        ),
         SizedBox(width: 16),
         SeatWidget(
          seatNumber: "",
          width: 24,
          height: 24,
          isAvailable: true,
          isSelected: false,
        ),
         SizedBox(width: 8),
        Text(
          "Available",
          style: TextStyle(color: Colors.white,fontSize: 16),
        ),
      ],
    );
  }
}