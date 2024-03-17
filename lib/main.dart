import 'package:flutter/material.dart';


void main() 
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget 
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) 
  {
      return MaterialApp
      (
        title: 'Naloga',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
       ),
      
        home: const HomePage(),
      );
   
  }
}

class MyAppState extends ChangeNotifier 
{

}

class HomePage extends StatefulWidget
{
  const HomePage({super.key});

  @override
  _HomePage createState() => _HomePage();
  
}

class Item
{
  String name;
  bool isChecked;

  Item(this.name, this.isChecked);
}

List<Item> _checkedItemsList =[];
List<Item> _itemsList =
[
  Item('Item 1', false),
  Item('Item 2', false),
  Item('Item 3', false),
];

class _HomePage extends State<HomePage>
{
  @override
  Widget build(BuildContext context) 
  {
    return LayoutBuilder
    (
      builder: (context, constraints) 
      {
        return Scaffold
        (
          appBar: AppBar
          ( 
            title: const Text('Shopping List'),
            actions: 
            [
              IconButton
              (
                onPressed:(){ filterItem(); },
                icon: const Icon(Icons.filter_list)
              )
            ],
          ),

          body: ListView.builder
          (
            itemCount: _itemsList.length,
            itemBuilder: (context, index)
            {
              return CheckboxListTile
              (
                title: Text(_itemsList[index].name),
                secondary: Row
                (
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>
                  [
                    IconButton
                    (
                      tooltip: 'Edit Item',
                      onPressed: () => _editItem(index), 
                      icon: const Icon(Icons.edit)
                    ),
                    IconButton
                    (
                      tooltip: 'Delete Item',
                      onPressed: () => _deleteItem(index), 
                      icon: const Icon(Icons.delete)
                    )
                  ],
                ),
        
                controlAffinity: 
                ListTileControlAffinity.leading,
                value: _itemsList[index].isChecked, 
                onChanged: (value) 
                {
                  setState(() 
                  {
                    _itemsList[index].isChecked = value!;
                    //_checkedItemsList.add(_itemsList[index]);
                    //_checkedItem(index);
                    _checkbox(_itemsList[index]);
                  });
                },
                );
            }
          ),

          bottomNavigationBar: 
            NavigationBar
            (
              destinations: 
              [
                IconButton
                (
                  onPressed: ()
                  {
                    Navigator.push
                    (
                     context,
                     MaterialPageRoute(builder: (context) => const HomePage())
                    );
                  }, 
                  icon: const Icon(Icons.home),
                ),
                IconButton
                (
                  onPressed: ()
                  {
                    Navigator.push
                    (
                     context,
                     MaterialPageRoute(builder: (context) => const StoredItemsPage())
                    );
                  }, 
                  icon: const Icon(Icons.done),
                )
              ],
            ),
          floatingActionButton: FloatingActionButton
          (
            onPressed: () 
            {
              _addNewItem();
            },
            tooltip: 'Add Item',
            child: const Icon(Icons.add),
          )
        );
      }
    );
  }

  void _addNewItem()
  {
    showDialog
    (
      context: context,
      builder: (BuildContext context) 
      {
        return AlertDialog
        (
          title: const Text('Add New Item'),
          content: TextField
          (
            onSubmitted: (value)
            {
              setState(() 
              {
                var a = Item(value, false);
                _itemsList.add(a);
              });
              Navigator.pop(context);
            },
            ),
        );
      }
    );
  }

  void _editItem(int index) 
  {
    TextEditingController editController = TextEditingController(text: _itemsList[index].name);
    showDialog
    (
      context: context,
      builder: (context)
      {
        return AlertDialog
        (
          title: const Text('Edit Item'),
          content: TextField
            (
            controller: editController,
            onSubmitted: (value)
            {
              setState(() 
              {
                _itemsList[index].name = editController.text;
              });
              Navigator.pop(context);
            },
            ),
        );
      }
    );
  }
  void filterItem() { 
    setState(() { 
      _checkedItemsList =  _itemsList.where((item) => item.isChecked).toList(); 
    });}



  void _deleteItem(int index)
  {
    setState(() 
    {
      _itemsList.removeAt(index);
    });
  }


void _checkbox(Item item)
{
  setState((){
  if (_checkedItemsList.contains(item))
  {
    _checkedItemsList.remove(item);
    item.isChecked = false;
  }
  else
  {
    _checkedItemsList.add(item);
    item.isChecked = true;
  }});
}
  
}

class StoredItemsPage extends StatefulWidget
{
  const StoredItemsPage({super.key});

  @override
  _StoredItemsPage createState() => _StoredItemsPage();
  
}

class _StoredItemsPage extends State<StoredItemsPage>
{

  @override
  Widget build(BuildContext context) 
  {
    return LayoutBuilder
    (
      builder: (context, constraints) 
      {
        return Scaffold
        (
          body: ListView.builder
          (
            itemCount: _checkedItemsList.length,
            itemBuilder: (context, index)
            {
              return ListTile
              (
                title: Text(_checkedItemsList[index].name),
                leading: Row
                (
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>
                  [
                    IconButton
                    (
                      tooltip: 'Uncheck Item',
                      onPressed: () => _checkbox(_checkedItemsList[index]), 
                      icon: const Icon(Icons.check_box)
                    )
                  ],
                )
              );
            }
          ),
          bottomNavigationBar: 
            NavigationBar
            (
              destinations: 
              [
                IconButton
                (
                  onPressed: ()
                  {
                    Navigator.push
                    (
                     context,
                     MaterialPageRoute(builder: (context) => const HomePage())
                    );
                  }, 
                  icon: const Icon(Icons.home),
                ),
                IconButton
                (
                  onPressed: ()
                  {
                    Navigator.push
                    (
                     context,
                     MaterialPageRoute(builder: (context) => const StoredItemsPage())
                    );
                  }, 
                  //label: Text('Checked Item'),
                  icon: const Icon(Icons.done),
                )
              ],
            ),
        );
    
      }
    );
  }

  void _checkbox(Item item)
{
  setState((){
  if (_checkedItemsList.contains(item))
  {
    _checkedItemsList.remove(item);
    item.isChecked = false;
  }
  else
  {
    _checkedItemsList.add(item);
    item.isChecked = true;
  }});
}
}