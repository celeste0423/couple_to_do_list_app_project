import 'package:couple_to_do_list_app/features/upload_bukkung_list/controller/upload_bukkung_list_controller.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LocationTextField extends StatefulWidget {
  const LocationTextField({Key? key}) : super(key: key);

  @override
  State<LocationTextField> createState() => _LocationTextFieldState();
}

class _LocationTextFieldState extends State<LocationTextField> {
  final UploadBukkungListController _controller =
      Get.find<UploadBukkungListController>();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context).insert(this._overlayEntry!);
      } else {
        this._overlayEntry!.remove();
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
                              _controller.locationController!.text =
                                  shortLocation;
                              this._overlayEntry!.remove();
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
    List<String> _parts = location!.split(',');
    String _shortLocation = _parts.last.trim();
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
            _shortLocation ?? '',
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
          maxLength: 20,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
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
            fontSize: 20,
          ),
          cursorColor: CustomColors.darkGrey,
          decoration: const InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: '위치',
            counterText: '',
            hintStyle: TextStyle(
              color: CustomColors.greyText,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
