import 'package:flutter/material.dart';

class PopUpMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      tooltip: "Estrategia de geração",
      itemBuilder: (context) {
        var list = List<PopupMenuEntry<Object>>();
        list.add(
          PopupMenuItem(
            child: Text("Estratégia de geração"),
            enabled: false,
          ),
        );
        list.add(
          PopupMenuDivider(
            height: 10,
          ),
        );
        list.add(
          CheckedPopupMenuItem(
            child: Text(
              "Aleatório",
            ),
            value: 1,
            checked: true,
          ),
        );
        list.add(
          CheckedPopupMenuItem(
            child: Text(
              "Histórico",
            ),
            value: 2,
            enabled: false,
          ),
        );
        list.add(
          CheckedPopupMenuItem(
            child: Text(
              "Mais frequentes",
            ),
            value: 3,
            enabled: false,
          ),
        );
        list.add(
          CheckedPopupMenuItem(
            child: Text(
              "Menos frequentes",
            ),
            value: 4,
            enabled: false,
          ),
        );
        return list;
      },
    );
  }
}
