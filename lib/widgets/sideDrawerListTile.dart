import 'package:flutter/material.dart';

class SideDrawerListTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final Function onClick;

  const SideDrawerListTile({Key key, this.icon, this.title, this.onClick})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
        highlightColor: Colors.white,
        splashColor: Colors.white,
        onTap: onClick,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 5),
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.right,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: icon,
                  ),
                ],
              )),
        ));
  }
}
