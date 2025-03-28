import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomListView<T> extends StatefulWidget {
  final List<T> items;
  final ScrollController? scrollController;
  final bool isLoadingMore;
  final Widget Function(BuildContext, T) itemBuilder;
  final Function(T)? onItemPressed;
  final VoidCallback? reloadWidget;
  final VoidCallback? onLoadMore;
  final double separatorHeight;
  final EdgeInsets padding;
  final bool scrollToTop;

  const CustomListView({
    Key? key,
    required this.items,
    this.scrollController,
    this.isLoadingMore = false,
    required this.itemBuilder,
    this.onItemPressed,
    this.reloadWidget,
    this.separatorHeight = 16,
    this.padding = const EdgeInsets.all(16),
    this.scrollToTop = false,
    this.onLoadMore,
  }) : super(key: key);

  @override
  State<CustomListView<T>> createState() => _CustomListViewState<T>();
}

class _CustomListViewState<T> extends State<CustomListView<T>> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
  }

  @override
  void didUpdateWidget(CustomListView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scrollToTop && !oldWidget.scrollToTop) {
      _scrollToTop();
    }
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo is ScrollEndNotification) {
          if ((widget.scrollController?.position.pixels ?? 0) >= (widget.scrollController?.position.maxScrollExtent ?? 0) - 200 &&
              !widget.isLoadingMore) {
            widget.onLoadMore?.call();
          }
        }
        return widget.isLoadingMore; // Prevent scroll if loading more
      },
      child: Stack(
        children: [
          ListView.separated(
            shrinkWrap: true,
            controller: _scrollController,
            physics: widget.isLoadingMore ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
            padding: widget.padding,
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return GestureDetector(
                onTap: widget.onItemPressed != null ? () => widget.onItemPressed!(item) : null,
                child: widget.itemBuilder(context, item),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: widget.separatorHeight);
            },
          ),
          if (widget.isLoadingMore)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white.withOpacity(0.8),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
