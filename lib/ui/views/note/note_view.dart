import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:flutter_app_note/ui/views/note/note_model.dart';
import 'package:flutter_app_note/ui/views/note/note_viewmodel.dart';
import 'package:flutter_app_note/ui/views/note/widgets/note_view_item.dart';
import 'package:flutter_app_note/ui/views/note/widgets/note_view_item_edit.dart';

class NoteView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NoteViewModel>.reactive(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text(model.title)),

        body: Stack(
          children: [
            model.state == NoteViewState.listView
                ? ListView.builder(
                    itemCount: model.items.length,
                    itemBuilder: (BuildContext context, int index) {
                      Note item = model.items[index];
                      return ListTile(
                        title: Text(item.title),
                        subtitle: Text(item.desc),
                        onTap: () {
                          model.editingItem = item;
                          model.state = NoteViewState.itemView;
                        },
                      );
                    },
                  )
                : model.state == NoteViewState.itemView
                    ? NoteViewItem()
                    : model.state == NoteViewState.updateView
                        ? NoteViewItemEdit()
                        : SizedBox(),
          ],
        ),
        // body: ListView.builder(
        //   itemCount: model.items.length,
        //   itemBuilder: (BuildContext context, int index) {
        //     Note item = model.items[index];
        //     return ListTile(
        //       title: Text(item.title),
        //       subtitle: Text(item.desc),
        //     );
        //   },
        // ),
        floatingActionButton: model.state == NoteViewState.listView
            ? FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  model.addItem();
                },
              )
            : null,
      ),
      viewModelBuilder: () => NoteViewModel(),
    );
  }
}
