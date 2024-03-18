import 'package:flutter/material.dart';
import 'package:naloga/models/lists.dart';
import 'package:naloga/screens/home_page.dart';
import 'package:naloga/screens/stored_item_page.dart';
import '../models/item.dart';

class UnstoredItemsPage extends StatefulWidget
{
  const UnstoredItemsPage({super.key});

  @override
  _UnstoredItemsPage createState() => _UnstoredItemsPage();
  
}

class _UnstoredItemsPage extends State<UnstoredItemsPage>
{
  void _uncheckbox(Item item)
  {
    setState(()
    {
    if (uncheckedItemsList.contains(item))
    {
      checkedItemsList.add(item);
      uncheckedItemsList.remove(item);
      item.isChecked = true;
    }
    else
    {
      checkedItemsList.remove(item);
      uncheckedItemsList.add(item);
      item.isChecked = false;
    }
    }
  );
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
            itemCount: uncheckedItemsList.length,
            itemBuilder: (context, index)
            {
              return ListTile
              (
                title: Text(uncheckedItemsList[index].name),
                leading: Row
                (
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>
                  [
                    IconButton
                    (
                      tooltip: 'Check Item',
                      onPressed: () => _uncheckbox(uncheckedItemsList[index]), 
                      icon: const Icon(Icons.check_box_outline_blank)
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
        );
      }
    );
  }
}