import 'package:flutter/material.dart';
import 'package:newsugrasu/SavedNewsScreen.dart';
import 'package:newsugrasu/SelectedNewsScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> newsList = [];

  void getNews() async {
    final SupabaseClient supabase = Supabase.instance.client;
    final response = await supabase.from('news').select();
    setState(() {
      newsList = response as List<dynamic>;
    });
  }

  @override
  void initState() {
    super.initState();

    getNews();
  }


  @override
  Widget build (BuildContext context) {
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
            Row (
              children: [
                IconButton(
                  icon: Icon(Icons.sort),
                  onPressed: () {
                    setState(() {
                      newsList = newsList.reversed.toList();
                    });
                  },
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
          ],
        ),
        backgroundColor: Color.fromRGBO(224, 255, 255, 1),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: newsList.isEmpty ? Center(child: CircularProgressIndicator()) : ListView.separated(
                  itemCount: newsList.length,
                  itemBuilder: (context, index) {
                    var news = newsList[index];
                    news['created_at'] = news['created_at'].toString().substring(0, 16).replaceAll('T', ' ');

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectedNewsScreen(
                              titleNews: news['news_title'],
                              descriptionNews: news['news_description'],
                              dateTimeNews: news['created_at'],
                              urlImageNews: news['news_url_image'],
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: Image.network(
                          news['news_url_image'],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                news['news_title'],
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
                              '${news['created_at']}',
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
                  },
                  separatorBuilder: (context, index) {
                    return Divider(color: Colors.grey);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(224, 255, 255, 1),
    );
  }
}