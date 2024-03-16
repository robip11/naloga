import 'package:flutter/material.dart';


void main() 
{
  runApp(MyApp());
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
      
        home: HomePage(),
      );
   
  }
}

class MyAppState extends ChangeNotifier 
{

}

class HomePage extends StatefulWidget
{
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
  List<Item> _itemsList =[];

class _HomePage extends State<HomePage>
{
  //var selectedIndex = 0;



  @override
  Widget build(BuildContext context) 
  {
    // Widget page;
    // switch (selectedIndex) 
    // {
    //   case 0:
    //     page = HomePage();
    //     break;
    //   case 1:
    //     page = StoredItemsScreen();
    //     break;
    //   default:
    //     throw UnimplementedError('no widget for $selectedIndex');
    // }

    return LayoutBuilder
    (
      builder: (context, constraints) 
      {
        return Scaffold
        (
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
                      icon: Icon(Icons.edit)
                    ),
                    IconButton
                    (
                      tooltip: 'Delete Item',
                      onPressed: () => _deleteItem(index), 
                      icon: Icon(Icons.delete)
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
                    _checkedItemsList.add(_itemsList[index]);
                    
                    _checkedItem(index);
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
                     MaterialPageRoute(builder: (context) => HomePage())
                    );
                  }, 
                  icon: Icon(Icons.home),
                ),
                IconButton
                (
                  onPressed: ()
                  {
                    Navigator.push
                    (
                     context,
                     MaterialPageRoute(builder: (context) => StoredItemsPage())
                    );
                  }, 
                  //label: Text('Checked Item'),
                  icon: Icon(Icons.done),
                )

                // ,NavigationDestination
                // (
                //   icon: Icon(Icons.home),
                //   label: ('Home'),
                // ),
                // NavigationDestination
                // (
                //   icon: Icon(Icons.done),
                //   label: ('Checked Items'),
                // ),
              ],
              // selectedIndex: selectedIndex,
              // onDestinationSelected: (value)
              // {
              //   setState(() 
              //   {
              //     selectedIndex = value;
              //   });
              // }
            ),



          floatingActionButton: FloatingActionButton
          (
            onPressed: () 
            {
              _addNewItem();
            },
            tooltip: 'Add Item',
            child: Icon(Icons.add),
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
          title: Text('Add New Item'),
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
          title: Text('Edit Item'),
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

  void _checkedItem(int index)
  {
    setState(() {
      _checkedItemsList.add(_itemsList[index]);
    });
  }

  void _deleteItem(int index)
  {
    setState(() 
    {
      _itemsList.removeAt(index);
    });
  }

  void _checkbox(int index)
  {
    if (_checkedItemsList.contains(_itemsList[index]))
    {
      _checkedItemsList.remove(_itemsList[index]);
    }
    else
    {
      _checkedItemsList.add(_itemsList[index]);
    }
  }
}

class StoredItemsPage extends StatefulWidget
{
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
                      onPressed: () => _deleteItem(index), 
                      icon: Icon(Icons.check_box)
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
                     MaterialPageRoute(builder: (context) => HomePage())
                    );
                  }, 
                  icon: Icon(Icons.home),
                ),
                IconButton
                (
                  onPressed: ()
                  {
                    Navigator.push
                    (
                     context,
                     MaterialPageRoute(builder: (context) => StoredItemsPage())
                    );
                  }, 
                  //label: Text('Checked Item'),
                  icon: Icon(Icons.done),
                )
              ],
            ),
        );
    
      }
    );
  }

  void _deleteItem(int index)
  {
    setState(() 
    {
      _checkedItemsList.removeAt(index);
      _itemsList.remove(_checkedItemsList[index]);
    });
  }
}