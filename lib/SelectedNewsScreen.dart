import 'package:flutter/material.dart';
import 'package:newsugrasu/SavedNewsScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectedNewsScreen extends StatefulWidget {
  final String titleNews;
  final String descriptionNews;
  final String dateTimeNews;
  final String urlImageNews;

  SelectedNewsScreen(
    {
      required this.titleNews,
      required this.descriptionNews,
      required this.dateTimeNews,
      required this.urlImageNews,
    });

  @override
  _SelectedNewsScreenState createState() => _SelectedNewsScreenState();

}

class _SelectedNewsScreenState extends State<SelectedNewsScreen> {

  void saveNewsInCache() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> news = prefs.getStringList('news') ?? [];

    if (!news.contains(widget.titleNews) && !news.contains(widget.descriptionNews)
    && !news.contains(widget.dateTimeNews)) {
      news.add(widget.titleNews);
      news.add(widget.descriptionNews);
      news.add(widget.dateTimeNews);

      await prefs.setStringList('news', news);
    }
  }

  void initState() {
    super.initState();
    saveNewsInCache();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row (
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Новости',
              style: TextStyle(
                fontFamily: 'DushaRegular',
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            IconButton(
              icon: Icon(Icons.download_for_offline),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SavedNewsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        backgroundColor: Color.fromRGBO(224, 255, 255, 1),
      ),
      backgroundColor: Color.fromRGBO(224, 255, 255, 1),
      body: Padding(
          padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
          child:
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.titleNews,
                  style: TextStyle(
                    fontFamily: 'DushaRegular',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
                Text(
                  widget.dateTimeNews,
                  style: TextStyle(
                    fontFamily: 'DushaRegular',
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
                if (widget.urlImageNews.isNotEmpty)
                  Image.network(
                    widget.urlImageNews,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitWidth,
                  ),
                Text(
                  widget.descriptionNews,
                  style: TextStyle(
                    fontFamily: 'DushaRegular',
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
              ],
            ),
          ),
      ),

    );
  }
}