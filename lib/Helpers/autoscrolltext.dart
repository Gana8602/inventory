import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory/api_services/boxController.dart';

class InformationWarning extends StatefulWidget {
  const InformationWarning({super.key});

  @override
  State<InformationWarning> createState() => _InformationWarningState();
}

class _InformationWarningState extends State<InformationWarning> {
  final ScrollController _scrollController = ScrollController();
  final int _scrollDuration = 2000; // Duration of the scroll in milliseconds
  final BoxController boxController = Get.put(BoxController());
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    boxController.fetchBoxes();
    // Start auto-scrolling when the widget is initialized
    _startAutoScroll();
  }

  @override
  void dispose() {
    _scrollTimer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _startAutoScroll() {
    _scrollTimer =
        Timer.periodic(Duration(milliseconds: _scrollDuration), (Timer timer) {
      if (_scrollController.hasClients) {
        _scrollController
            .animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: _scrollDuration.toInt()),
          curve: Curves.linear,
        )
            .then((_) {
          // Scroll back to start after reaching end
          _scrollController.jumpTo(0);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Adjust height as needed
      child: Obx(() {
        if (boxController.boxes.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Extract product names
        List<String> productNames = [];
        List<String> qty = [];
        for (var box in boxController.boxes) {
          productNames.addAll(box.products.map((product) => product.name));
          qty.addAll(box.products.map((product) => product.qty.toString()));
        }

        return ListView.builder(
          controller: _scrollController, // Attach the ScrollController
          itemCount: productNames.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    CupertinoIcons.exclamationmark,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: "${productNames[index]} (${qty[index]})",
                        style: const TextStyle(color: Colors.grey),
                        children: const [
                          TextSpan(
                            text: "  is not updated",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
