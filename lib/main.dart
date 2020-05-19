import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


void main() => runApp(Home());

class Home extends StatefulWidget {
    @override
    _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {
    static int page = 0;
    ScrollController _sc =  ScrollController();
    bool isLoading = false;
    List users =  List();
    final dio =  Dio();

    @override
    void initState() {
    this._getMoreData(page);
    super.initState();
    _sc.addListener(() {
        if (_sc.position.pixels == _sc.position.maxScrollExtent) {
            _getMoreData(page);
    }});}

    @override
    void dispose() {
        _sc.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
    return MaterialApp(
        title: "test",
        home:  Scaffold(
            appBar: AppBar(
                title: const Text("test"),
            ),
            body: Container(
                child: _buildList(),
            ),
            resizeToAvoidBottomPadding: false,
            )
        );
    }

    Widget _buildList() {
        return ListView.builder(
            controller: _sc,
            itemCount: users.length + 1,
            padding: EdgeInsets.symmetric(vertical: 8.0),
            itemBuilder: (BuildContext context, int index) {
                if (index == users.length) {
                    return _shimmerUserList();
                }
                else {
                    return ListTile(
                        leading: CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage(
                                users[index]['picture']['medium'],
                                ),
                            ),
                            title: Text((users[index]['name']['last'])),
                            subtitle: Text((users[index]['phone'])),
                            );
                        }
                },
        );
    }

    void _getMoreData(int index) async {
        if (!isLoading) {
            setState(() {
            isLoading = true;
        });
        final String url = "https://randomuser.me/api/?page=" + index.toString();
        print(url);

        final response = await dio.get(url, queryParameters: {
            "seed" : "abc",
            "results": 20});

        dio.options.connectTimeout = 5000;
        print("Connect Timeout!!");

            List tList = List();
            for (int i = 0; i < 13; i++) {
                tList.add(response.data['results'][i]);
            }
            setState(() {
                isLoading = false;
                users.addAll(tList);
                page++;
            });
        }
    }

    Widget _shimmerUserList() {
        return SizedBox(
            width: 200.0,
            height: 100.0,
            child: Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                child: ListTile(
                        leading: CircleAvatar(
                            radius: 30.0,
                        ),
                        title: Text('111111'),
                        subtitle: Text('11111111')
                ),
            ),
        );
    }
}


