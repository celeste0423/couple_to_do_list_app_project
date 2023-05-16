import 'package:couple_to_do_list_app/features/upload_bukkung_list/controller/upload_bukkung_list_controller.dart';
import 'package:couple_to_do_list_app/utils/custom_color.dart';
import 'package:flutter/material.dart';

class LocationTextField extends StatefulWidget {
  const LocationTextField({Key? key}) : super(key: key);

  @override
  State<LocationTextField> createState() => _LocationTextFieldState();
}

class _LocationTextFieldState extends State<LocationTextField> {
  UploadBukkungListController _controller = UploadBukkungListController();

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
              top: offset.dy + size.height + 5.0,
              width: size.width,
              child: Material(
                child: _controller.placePredictions.length == 0
                    ? Container(
                        color: Colors.red,
                        height: 50,
                        width: 50,
                      )
                    : ListView.builder(
                        itemCount: _controller.placePredictions.length,
                        itemBuilder: (context, index) {
                          return _locationListTile(
                            _controller.placePredictions[index].description,
                            () {},
                          );
                        },
                      ),
              ),
            ));
  }

  Widget _locationListTile(String? location, VoidCallback? onTap) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          horizontalTitleGap: 0,
          title: Text(
            location ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Divider(
          height: 2,
          thickness: 2,
          color: CustomColors.grey,
        )
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
            this._overlayEntry = this._createOverlayEntry();
            Overlay.of(context).insert(this._overlayEntry!);
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
