import 'package:flutter/material.dart';
import 'package:naloga/screens/stored_item_page.dart';
import 'package:naloga/screens/unstored_item_page.dart';
import '../models/item.dart';
import '../models/lists.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget
{
  const HomePage({super.key});

  @override
  _HomePage createState() => _HomePage();
  
}

class _HomePage extends State<HomePage>
{
  void _addNewItem()
  {
    showDialog
    (
      context: context,
      builder: (context) 
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
                itemsList.add(a);
                uncheckedItemsList.add(a);
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
    TextEditingController editController = TextEditingController(text: itemsList[index].name);
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
                itemsList[index].name = editController.text;
              });
              Navigator.pop(context);
            },
            ),
        );
      }
    );
  }
  
  void _deleteItem(Item item)
  {
    setState(() 
    {
      itemsList.remove(item);
      checkedItemsList.remove(item);
      uncheckedItemsList.remove(item);

    });
  }

  void _checkbox(Item item)
  {
    setState((){
    if (checkedItemsList.contains(item))
    {
      checkedItemsList.remove(item);
      uncheckedItemsList.add(item);
      item.isChecked = false;
    }
    else
    {
      uncheckedItemsList.remove(item);
      checkedItemsList.add(item);
      item.isChecked = true;
    }});
  }
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
            itemCount: itemsList.length,
            itemBuilder: (context, index)
            {
              return CheckboxListTile
              (
                title: Text(itemsList[index].name),
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
                      onPressed: () => _deleteItem(itemsList[index]), 
                      icon: const Icon(Icons.delete)
                    )
                  ],
                ),
        
                controlAffinity: 
                ListTileControlAffinity.leading,
                value: itemsList[index].isChecked, 
                onChanged: (value) 
                {
                  setState(() 
                  {
                    itemsList[index].isChecked = value!;
                    _checkbox(itemsList[index]);
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
                  tooltip: 'All Items',
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
                  tooltip:'Checked Items',
                  onPressed: ()
                  {
                    Navigator.push
                    (
                      context,
                      MaterialPageRoute(builder: (context) => const StoredItemsPage())
                    );
                  }, 
                  icon: const Icon(Icons.done),
                ),
                IconButton
                (
                  tooltip:'Unchecked Items',
                  onPressed: ()
                  {
                    Navigator.push
                    (
                      context,
                      MaterialPageRoute(builder: (context) => const UnstoredItemsPage())
                    );
                  }, 
                  icon: const Icon(Icons.check_box_outline_blank),
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
}
