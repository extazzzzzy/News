import 'package:flutter/material.dart';
import 'package:newsugrasu/SelectedNewsScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedNewsScreen extends StatefulWidget {
  @override
  _SavedNewsScreenState createState() => _SavedNewsScreenState();
}

class _SavedNewsScreenState extends State<SavedNewsScreen> {
  List<String> news = [];
  void getCache() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      news = prefs.getStringList('news') ?? [];
    });
    print(news);
  }

  void clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    news = [];
    await prefs.setStringList('news', news);
  }

  void initState() {
    super.initState();
    getCache();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row (
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Сохранённые новости',
              style: TextStyle(
                fontFamily: 'DushaRegular',
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  clearCache();
                });
              },
            ),
          ],
        ),
        backgroundColor: Color.fromRGBO(224, 255, 255, 1),
      ),
      backgroundColor: Color.fromRGBO(224, 255, 255, 1),
      body: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: news.isEmpty ? Center(child: Text(
                    'Сохранённых новостей не найдено',
                  style: TextStyle(
                    fontFamily: 'DushaRegular',
                    fontSize: 24,
                  ),
                )) : ListView.separated(
                  itemCount: news.length,
                  itemBuilder: (context, index) {
                      if (index == 0 || index % 3 == 0)
                      {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SelectedNewsScreen(
                                  titleNews: news[index],
                                  descriptionNews: news[index + 1],
                                  dateTimeNews: news[index + 2],
                                  urlImageNews: '',
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    news[index],
                                    style: TextStyle(
                                      fontFamily: 'DushaRegular',
                                      fontSize: 20,
                                    ),
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  '${news[index + 2]}',
                                  style: TextStyle(
                                    fontFamily: 'DushaRegular',
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      else {
                        return Container();
                      }
                  },
                  separatorBuilder: (context, index) {
                    if (index % 3 == 0) {
                      return Divider(color: Colors.grey);
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}