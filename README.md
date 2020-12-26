# flutter_app_note

Xây dựng ứng dụng Note (Đây là phần thực hành của nội dung chương 4 trong học phần Phát triển ứng dụng đa nền tảng đang được giảng dạy tại Khoa Công nghệ thông tin của Trường Đại học Mỏ - Địa chất)

## Bắt đầu ngay

### Tạo một kho lưu trữ
Bài viết này sử dụng kho lưu trữ mẫu (template) GitHub để giúp bạn dễ dàng bắt đầu. Mẫu có một ứng dụng web tĩnh rất đơn giản để chúng ta có thể sử dụng như một điểm khởi đầu.

> 1. Đảm bảo rằng bạn đã đăng nhập vào GitHub và điều hướng đến vị trí sau để tạo một kho lưu trữ mới:
https://github.com/chuyentt/mynote/generate - nếu liên kết không hoạt động, vui lòng đăng nhập vào GitHub và thử lại.
> 2. Đặt tên cho Repository name (kho lưu trữ mã nguồn) của bạn là:
`mynote`

Chọn **`Create repository from template`**.

### Sao chép kho lưu trữ
Với kho lưu trữ được tạo trong tài khoản GitHub của bạn, hãy sao chép dự án vào máy cục bộ của bạn bằng lệnh sau với công cụ giao tiếp dòng lệnh `Command Prompt` trên Windows hoặc `terminal` trên macOS.
`git clone https://github.com/<YOUR_ACCOUNT_NAME>/mynote.git`

Hoặc sao chép nó về bằng công cụ `Visual Studio Code` bằng cách đi đến menu *`View > Command Palette...`* rồi nhập `Git: Clone` sau đó cung cấp URL của kho lưu trữ hoặc chọn nguồn kho lưu trữ `https://github.com/<YOUR_ACCOUNT_NAME>/mynote.git`.

# Source Code Module Note

### main.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_app_note/ui/views/login/auth_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginView(),
    );
  }
}
```

### note_model.dart
```dart
import 'package:flutter/material.dart';

class Note {
  String id =
      UniqueKey().hashCode.toUnsigned(20).toRadixString(16).padLeft(5, '0');

  String title;
  String desc;
  bool isDeleted = false;

  Note(this.title, this.desc);

  static String get tableName => 'Notes';

  static String get createTable =>
      'CREATE TABLE $tableName(`id` TEXT PRIMARY KEY,'
      ' `title` TEXT,'
      ' `desc` TEXT,'
      ' `isDeleted` INTEGER DEFAULT 0)';

  static List<Note> fromList(List<Map<String, dynamic>> query) {
    List<Note> items = List<Note>();
    for (Map map in query) {
      items.add(Note.fromMap(map));
    }
    return items;
  }

  Note.fromMap(Map data)
      : id = data['id'],
        title = data['title'],
        desc = data['desc'],
        isDeleted = data['isDeleted'] == 1 ? true : false;
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'desc': desc,
        'isDeleted': isDeleted ? 1 : 0,
      };
}
```
### note_repository.dart
```dart
import 'package:flutter_app_note/repository/local_repository.dart';
import 'package:flutter_app_note/repository/repository.dart';

import 'package:flutter_app_note/ui/views/note/note_model.dart';

class NoteRepository implements Repository<Note> {
  NoteRepository._internal(LocalRepository localRepo) {
    this.localRepo = localRepo;
  }

  static final _cache = <String, NoteRepository>{};

  factory NoteRepository() {
    return _cache.putIfAbsent('NoteRepository',
        () => NoteRepository._internal(LocalRepository.instance));
  }

  @override
  LocalRepository localRepo;

  @override
  Future delete(Note item) async {
    return await localRepo.db().then((db) =>
        db.delete(Note.tableName, where: 'id' + ' = ?', whereArgs: [item.id]));
  }

  @override
  Future insert(Note item) async {
    /// Code cho insetr data
    final db = await localRepo.db();
    return await db.insert(Note.tableName, item.toMap());
  }

  @override
  Future<List<Note>> items() async {
    /// cho get all item Note
    final db = await localRepo.db();
    var maps = await db.query(Note.tableName);
    return Note.fromList(maps);
  }

  @override
  Future update(Note item) async {
    /// Code cho update data
    final db = await localRepo.db();
    return await db.update(Note.tableName, item.toMap(),
        where: 'id' + ' = ? ', whereArgs: [item.id]);
  }
}
```
### note_view.dart
```dart
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
```
### note_viewmodel.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_app_note/ui/views/note/note_repository.dart';
import 'package:stacked/stacked.dart';

import 'package:flutter_app_note/ui/views/note/note_model.dart';
import 'note_model.dart';

/// Trạng thái của view
enum NoteViewState { listView, itemView, insertView, updateView }

class NoteViewModel extends BaseViewModel {
  final title = 'Danh sách Note';

  /// Danh sách các bản ghi được load bất đồng bộ bên trong view model,
  /// khi load thành công thì thông báo đến view để cập nhật trạng thái
  var _items = <Note>[];

  /// ### Danh sách các bản ghi dùng để hiển thị trên ListView
  /// Vì quá trình load items là bất đồng bộ nên phải tạo một getter
  /// `get items => _items` để tránh xung đột
  List<Note> get items => _items;

  /// Trạng thái mặc định của view là listView, nó có thể thay đổi
  /// bên trong view model
  var _state = NoteViewState.listView;

  /// Khi thay đổi trạng thái thì sẽ báo cho view biết để cập nhật
  /// nên cần tạo một setter để vừa nhận giá trị vừa thông báo đến view
  set state(value) {
    // Cập nhật giá trị cho biến _state
    _state = value;

    // Thông báo cho view biết để cập nhật trạng thái của widget
    notifyListeners();
  }

  /// Cần có một getter để lấy ra trạng thái view cục bộ cho view
  NoteViewState get state => _state;

  Note editingItem;

  var editingControllerTitle = TextEditingController();
  var editingControllerDesc = TextEditingController();

  ///
  var repo = NoteRepository();

  Future init() async {
    return reloadItems();
  }

  Future reloadItems() async {
    return repo.items().then((value) {
      _items = value;
      notifyListeners();
    });
  }

  void addItem() {
    var timestamp = DateTime.now();
    var title = timestamp.millisecondsSinceEpoch.toString();
    var desc = timestamp.toLocal().toString();

    var item = Note(title, desc);
    repo.insert(item).then((value) {
      reloadItems();
    });
  }

  void updateItem() {
    editingControllerTitle.text = editingItem.title;
    editingControllerDesc.text = editingItem.desc;
    state = NoteViewState.updateView;
  }

  void saveItem() {
    Note note =
        new Note(editingControllerTitle.text, editingControllerDesc.text);
    note.id = editingItem.id;
    repo.update(note).then((value) {
      int index = _items.indexWhere((element) => element.id == note.id);
      _items[index].title = note.title;
      _items[index].desc = note.desc;
      state = NoteViewState.listView;
      editingItem = null;
      notifyListeners();
    });
  }

  void deleteItem() {
    repo.delete(editingItem);
    _items.removeWhere((element) => element.id == editingItem.id);
    state = NoteViewState.listView;
    editingItem = null;
    notifyListeners();
  }
}

```
### /widgets/note_view_item_edit.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_app_note/ui/views/note/note_viewmodel.dart';
import 'package:stacked/stacked.dart';

class NoteViewItemEdit extends ViewModelWidget<NoteViewModel> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, model) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cập nhật thông tin ${model.editingItem.id}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => model.state = NoteViewState.listView,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => model.saveItem(),
          )
        ],
      ),
      body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Nhập tiêu đề',
                  ),
                  controller: model.editingControllerTitle),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Nhập mô tả',
                ),
                controller: model.editingControllerDesc,
              )
            ],
          )),
    );
  }
}
```
### /widgets/note_view_item.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_app_note/ui/views/note/note_viewmodel.dart';
import 'package:stacked/stacked.dart';

class NoteViewItem extends ViewModelWidget<NoteViewModel> {
  @override
  Widget build(BuildContext context, model) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết ${model.editingItem.id}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => model.state = NoteViewState.listView,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => model.updateItem(),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => model.deleteItem(),
          )
        ],
      ),
      body: Center(
        child: ListTile(
          title: Text(model.editingItem.title),
          subtitle: Text(model.editingItem.desc),
        ),
      ),
    );
  }
}
```
