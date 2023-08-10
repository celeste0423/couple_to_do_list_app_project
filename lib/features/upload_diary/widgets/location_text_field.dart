import 'package:couple_to_do_list_app/features/upload_diary/controller/upload_diary_controller.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationTextField extends StatefulWidget {
  const LocationTextField({Key? key}) : super(key: key);

  @override
  State<LocationTextField> createState() => _LocationTextFieldState();
}

class _LocationTextFieldState extends State<LocationTextField> {
  final UploadDiaryController _controller =
      Get.find<UploadDiaryController>();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(_overlayEntry!);
      } else {
        _overlayEntry!.remove();
      }
    });
    super.initState();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height - 20,
        width: size.width,
        child: Material(
          color: Colors.transparent,
          child: _controller.placePredictions.isEmpty
              ? Container()
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(width: 20, height: 20, color: Colors.white),
                        Container(width: 20, height: 20, color: Colors.white),
                      ],
                    ),
                    Container(
                      height: 150,
                      color: Colors.white,
                      child: ListView.builder(
                        itemCount: _controller.placePredictions.length,
                        itemBuilder: (context, index) {
                          return _locationListTile(
                            _controller.placePredictions[index].description,
                            () {
                              List<String> parts = _controller
                                  .placePredictions[index].description!
                                  .split(',');
                              String shortLocation = parts.last.trim();
                              _controller.locationController.text =
                                  shortLocation;
                              _overlayEntry!.remove();
                              FocusScope.of(context).unfocus();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _locationListTile(String? location, VoidCallback? onTap) {
    List<String> parts = location!.split(',');
    String shortLocation = parts.last.trim();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Divider(
            height: 2,
            thickness: 2,
            color: CustomColors.lightGrey,
          ),
        ),
        ListTile(
          onTap: onTap,
          horizontalTitleGap: 0,
          title: Text(
            shortLocation ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          controller: _controller.locationController,
          focusNode: _focusNode,
          maxLines: 1,
          onChanged: (value) {
            _controller.placeAutocomplete(value);
            setState(() {
              _overlayEntry?.markNeedsBuild();
            });
          },
          textInputAction: TextInputAction.search,
          style: TextStyle(
            color: CustomColors.blackText,
            fontSize: 25,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: '위치',
            hintStyle: TextStyle(
              color: CustomColors.greyText,
              fontSize: 25,
            ),
          ),
        ),
      ),
    );
  }
}
