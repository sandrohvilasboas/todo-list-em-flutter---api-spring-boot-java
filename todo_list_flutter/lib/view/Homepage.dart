import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todo_list/controller/TodoController.dart';
import 'package:todo_list/model/Todo.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:intl/intl.dart';
import '../widget/ModalContainerTextBox.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Todo> todoList = [];
  TextEditingController dateCtl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController titleCtrl = TextEditingController();

  Future _getTodos() async {
    var result = await TodoController.Fetch(method: 'GET');
    Iterable list = json.decode(result);
    todoList = list.map((e) => Todo.fromJson(e)).toList();

    return todoList;
  }

  void _updateTodo(todo) async {
    await TodoController.Fetch(todo: todo, method: 'PUT');
  }

  void _insertTodo(todo) async {
    await TodoController.Fetch(todo: todo, method: 'POST');
    var get = await _getTodos();
    setState(() {
      get;
    });
  }

  void _deleteTodo(todo) async {
    await TodoController.Fetch(todo: todo, method: 'DELETE');
    var get = await _getTodos();
    setState(() {
      get;
    });
  }

  Future _showModal() {
    return showMaterialModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Nova tarefa'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ModalContainerTextBox(
                context: context,
                controller: titleCtrl,
                hintText: 'Titulo',
              ),
              ModalContainerTextBox(
                context: context,
                controller: descriptionCtrl,
                hintText: 'Descrição',
              ),
              ModalContainerTextBox(
                context: context,
                controller: dateCtl,
                readonly: true,
                hintText: 'Data para finalização',
                function: () async {
                  DateTime? date = DateTime(1900);
                  FocusManager.instance.primaryFocus?.unfocus();
                  DateFormat? formatter = DateFormat('dd/MM/yyyy');

                  date = (await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100)));

                  if (date != null) dateCtl.text = formatter.format(date);
                },
              ),
              TextButton(
                onPressed: () {
                  Todo todo = Todo(
                    id: null,
                    title: titleCtrl.text,
                    description: descriptionCtrl.text,
                    date_end: dateCtl.text == null ? '' : dateCtl.text,
                    isComplete: false,
                  );
                  setState(() {
                    _insertTodo(todo.toJson());
                    titleCtrl.clear();
                    descriptionCtrl.clear();
                    dateCtl.clear();

                    Navigator.pop(context);
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  height: 50,
                  width: 250,
                  color: Colors.blue,
                  child: const Text(
                    'Adicionar Tarefa',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Tarefas"),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "A Fazer",
              ),
              Tab(
                text: "Finalizado",
              )
            ],
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                    future: _getTodos(),
                    builder: (ctx, snapshot) {
                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 150),
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (ctx, index) {
                          if (todoList[index].isComplete == false) {
                            return Dismissible(
                              key: Key(todoList[index].id.toString()),
                              background: Container(
                                color: Colors.red,
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 15),
                              ),
                              direction: DismissDirection.endToStart,
                              onDismissed: (void x) {
                                _deleteTodo(todoList[index]);
                              },
                              child: Card(
                                child: CheckboxListTile(
                                  title: Text(todoList[index].title.toString() +
                                      ' ' +
                                      todoList[index].date_end.toString()),
                                  subtitle: Text(
                                      todoList[index].description.toString()),
                                  value: todoList[index].isComplete,
                                  onChanged: (bool? value) {
                                    setState(
                                      () {
                                        if (todoList[index].isComplete!) {
                                          todoList[index].isComplete = false;
                                          _updateTodo(todoList[index].toJson());
                                        } else {
                                          todoList[index].isComplete = true;
                                          _updateTodo(todoList[index].toJson());
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                        itemCount: todoList.length,
                      );
                    },
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                      future: _getTodos(),
                      builder: (ctx, snapshot) {
                        return ListView.builder(
                          padding: const EdgeInsets.only(bottom: 150),
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) {
                            if (todoList[index].isComplete == true) {
                              return Dismissible(
                                key: Key(todoList[index].id.toString()),
                                background: Container(
                                  color: Colors.red,
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 15),
                                ),
                                direction: DismissDirection.endToStart,
                                onDismissed: (void x) {
                                  _deleteTodo(todoList[index]);
                                },
                                child: Card(
                                  child: CheckboxListTile(
                                    title: Text(
                                      todoList[index].title.toString() +
                                          ' ' +
                                          todoList[index].date_end.toString(),
                                    ),
                                    subtitle: Text(
                                        todoList[index].description.toString()),
                                    value: todoList[index].isComplete,
                                    onChanged: (bool? value) {
                                      setState(
                                        () {
                                          if (todoList[index].isComplete!) {
                                            todoList[index].isComplete = false;
                                            _updateTodo(
                                                todoList[index].toJson());
                                          } else {
                                            todoList[index].isComplete = true;
                                            _updateTodo(
                                                todoList[index].toJson());
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                          itemCount: todoList.length,
                        );
                      })
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _showModal();
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
