import 'package:flutter/material.dart';

class ColorSeperatedList extends StatelessWidget {
  const ColorSeperatedList({Key key, this.itemCount, this.itemBuilder}) : super(key: key);

  final int itemCount;
  final Function(BuildContext context, int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: itemCount,
      separatorBuilder: (context, index){
        return const SeperaterContainer();
      },
      itemBuilder: itemBuilder,
    );
  }
}

class SeperaterContainer extends StatelessWidget {
  const SeperaterContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      height: 1,
      color: Theme.of(context).primaryColor,
    );
  }
}