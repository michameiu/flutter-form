import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/infinite_scroll.dart';
import '../providers/auth.dart';

class InfiniteListView<T> extends StatefulWidget {
  final Function parseItemsFunction;
  final Function addItemListener;
  final Function builder;
  final String url;
  final pageSize;
  _InfiniteListViewState<T> widgetState=_InfiniteListViewState<T>();

  InfiniteListView({
    this.parseItemsFunction,
    this.url,
    this.addItemListener,
    this.pageSize=100,
    this.builder,
  });

  refreshList(){
    widgetState.itemsScrollModel.refresh();
  }

  @override
  _InfiniteListViewState createState() =>widgetState ;
}

class _InfiniteListViewState<T> extends State<InfiniteListView> {
  final scrollController = ScrollController();
  InfiniteScrollModel<T> itemsScrollModel;

  @override
  void initState() {
    print("This init statet.");
    itemsScrollModel = InfiniteScrollModel(
        url: widget.url,
        pageSize: widget.pageSize,
        parseItemsFunction: widget.parseItemsFunction,
        auth: Provider.of<Auth>(context, listen: false));

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        itemsScrollModel.loadMore();
      } else {
        print("the stufff that happedded");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: itemsScrollModel.stream,
        builder: (BuildContext contx, AsyncSnapshot _snapshot) {
          if (!_snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else if (_snapshot.hasError) {
            return Center(child: Text("Error occured"));
          } else {
            print("got data");
            return RefreshIndicator(
              onRefresh: itemsScrollModel.refresh,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                controller: scrollController,
                separatorBuilder: (context, index) => Divider(),
                itemCount: _snapshot.data.length+1,
                itemBuilder: (BuildContext ctx, index) {
                  if (index < _snapshot.data.length) {
                    var item = _snapshot.data[index] as T;
                    return widget.builder(item);
                  } else {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 32.0),
                      child: Center(child: Text('nothing more to load!')),
                    );
                  }
                },
              ),
            );
          }
        });
  }
}
