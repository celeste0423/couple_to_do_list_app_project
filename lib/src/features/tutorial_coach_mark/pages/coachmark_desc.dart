import 'package:couple_to_do_list_app/src/utils/custom_color.dart';
import 'package:flutter/material.dart';

class CoachmarkDesc extends StatefulWidget {
  const CoachmarkDesc({
    super.key,
    required this.text,
    this.skip = "건너뛰기",
    this.next = "다음",
    this.onSkip,
    this.onNext,
  });

  final String text;
  final String skip;
  final String next;
  final void Function()? onSkip;
  final void Function()? onNext;

  @override
  State<CoachmarkDesc> createState() => _CoachmarkDescState();
}

class _CoachmarkDescState extends State<CoachmarkDesc> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.text,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: widget.onSkip,
                child: Text(
                  widget.skip,
                  style: TextStyle(
                    fontSize: 15,
                    color: CustomColors.greyText,
                  ),
                ),
              ),
              const SizedBox(width: 30),
              GestureDetector(
                onTap: widget.onNext,
                child: Text(
                  widget.next,
                  style: TextStyle(
                    fontSize: 15,
                    color: CustomColors.mainPink,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
