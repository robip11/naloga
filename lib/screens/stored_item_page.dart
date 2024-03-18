import 'package:flutter/material.dart';
import 'package:naloga/screens/home_page.dart';
import 'package:naloga/screens/unstored_item_page.dart';
import '../models/item.dart';
import '../models/lists.dart';

class StoredItemsPage extends StatefulWidget
{
  const StoredItemsPage({super.key});

  @override
  _StoredItemsPage createState() => _StoredItemsPage();
  
}

class _StoredItemsPage extends State<StoredItemsPage>
{
  void _checkbox(Item item)
  {
    setState(()
    {
    if (checkedItemsList.contains(item))
    {
      uncheckedItemsList.add(item);
      checkedItemsList.remove(item);
      item.isChecked = false;
    }
    else
    {
      uncheckedItemsList.remove(item);
      checkedItemsList.add(item);
      item.isChecked = true;
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
            itemCount: checkedItemsList.length,
            itemBuilder: (context, index)
            {
              return ListTile
              (
                title: Text(checkedItemsList[index].name),
                leading: Row
                (
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>
                  [
                    IconButton
                    (
                      tooltip: 'Uncheck Item',
                      onPressed: () => _checkbox(checkedItemsList[index]), 
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
            )
            
        );
      }
    );
  }
}