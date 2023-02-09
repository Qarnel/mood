import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LinkWidget extends StatefulWidget {
  void Function()? onTap;
  Icon? icon;
  String? text;
  bool underline;
  BorderRadius? borderRadius;
  ShapeBorder? customBorder;
  double? fontSize;
  FontWeight? fontWeight;
  String? fontFamily;

  LinkWidget(
      {this.onTap,
      this.text,
      this.icon,
      this.underline = false,
      this.borderRadius,
      this.customBorder,
      this.fontSize = 18,
      this.fontWeight = FontWeight.w600,
      this.fontFamily = 'Montserrat',
      super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LinkWidgetState createState() => _LinkWidgetState();
}

class _LinkWidgetState extends State<LinkWidget> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onHover: (value) {
          setState(() {
            value ? _isHovering = true : _isHovering = false;
          });
        },
        onTap: widget.onTap,
        child: Column(children: <Widget>[
          Row(children: <Widget>[
            widget.icon != null
                ? IconButton(
                    onPressed: widget.onTap,
                    icon: widget.icon!,
                  )
                : const SizedBox(),
            widget.text != null
                ? Text(
                    widget.text!,
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      fontFamily: widget.fontFamily,
                      fontWeight: widget.fontWeight,
                      color: _isHovering
                          ? Theme.of(context).primaryTextTheme.overline!.color
                          : Theme.of(context).primaryTextTheme.button!.color,
                    ),
                  )
                : const SizedBox(),
          ]),
          SizedBox(height: widget.underline ? 5 : 0),
          widget.underline
              ? Visibility(
                  maintainAnimation: true,
                  maintainState: true,
                  maintainSize: true,
                  visible: _isHovering,
                  child: Container(
                    height: 2,
                    width: 20,
                    color: _isHovering
                        ? Theme.of(context).primaryTextTheme.overline!.color
                        : Theme.of(context).primaryTextTheme.button!.color,
                  ),
                )
              : const SizedBox(),
        ]),
      ),
    );
  }
}
