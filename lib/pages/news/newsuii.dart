import 'package:demo/api/getapi.dart';
import 'package:demo/model/newsapi.dart';
import 'package:demo/modules/cardsandmodules.dart';
import 'package:demo/pages/news/newsdetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewsUII extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
  return NewsUIIState();
  }
}
class NewsUIIState extends State<NewsUII>{
  late Future<Newsapi?>? _futurehorizontallist;
  late Future<Newsapi?>? _futureverticallist;



  horizontallistitem(size, Articles article){
    return GestureDetector(
      onTap: (){
        //navigator// login sucess //go to detail page
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
            NewsDetail(article)));
      },
      child: Container(
        margin: EdgeInsets.only(left: 10),
        child: Stack(
          children: [
            Container(
              width: size.width/1.7,
              height: size.height/4.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(article.urlToImage!,
                    fit: BoxFit.cover),
              ),
            ),
            Positioned(
              bottom: 65,
              left: 20,
              child: Container(
                width: size.width/1.9,
                child: Text(article.title!.toUpperCase()
                  ,maxLines: 2,overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white,fontSize: 16,
                      fontWeight:FontWeight.bold),),
              ),
            ),
            Positioned(
              left: 20,bottom: 5,
              child: Text(CardsandModules.formatDateTimestring(article.publishedAt!),style: TextStyle(color: Colors.white,
                fontSize: 14,fontWeight: FontWeight.normal,),),
            ),
            Positioned(bottom: 5,right: 15,child: Icon(Icons.play_circle,color: Colors.white,size: 25,))
          ],
        ),
      ),
    );
  }


  apicallh(){
    _futurehorizontallist = GetApi.getnewsdata();
  }
  apicallv(){
    _futureverticallist = GetApi.getnewsdata();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apicallh();
    apicallv();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            //horizontal list
                  // stack // image // title // date // icon

            //future builder
            FutureBuilder<Newsapi?>(
            future: _futurehorizontallist, // a previously-obtained Future<String> or null
            builder: (BuildContext context, AsyncSnapshot<Newsapi?> snapshot) {
                //switch
              switch (snapshot.connectionState){
                case ConnectionState.none:
                  //error
                  return Container(); // paxi dialog box thapne
                case ConnectionState.waiting: //loading
                  return Center(
                    child: Container(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    ),
                  );//
                case ConnectionState.done:
                  if(snapshot.data==null || snapshot.data!.articles!.isEmpty){
                    return Center(
                      child: Container(
                        child: Text("No Data or api issue"),
                      ),
                    );
                  }else{
                    // data ayo
                    //show ui

                    return Container(
                        width: size.width,
                        height: size.height/4.1,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.all(8),
                            itemCount: snapshot.data!.articles!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return horizontallistitem(size,snapshot.data!.articles![index]);
                            }
                        ),
                      );

                  }
                default: //error
                  return Container();//error paxi thapaula
              }
            }),
            //vertical list
                // row //
                      //col // col
                      //1st col
                            // stack //icon
                      //2nd col
                            // text
                            //row // container //text  /// text

            //future builder
            FutureBuilder<Newsapi?>(
                future: _futureverticallist, // a previously-obtained Future<String> or null
                builder: (BuildContext context, AsyncSnapshot<Newsapi?> snapshot) {
                  //switch
                  switch (snapshot.connectionState){
                    case ConnectionState.none:
                    //error
                      return Container(); // paxi dialog box thapne
                    case ConnectionState.waiting: //loading
                      return Center(
                        child: Container(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(),
                        ),
                      );//
                    case ConnectionState.done:
                      if(snapshot.data==null || snapshot.data!.articles!.isEmpty){
                        return Center(
                          child: Container(
                            child: Text("No Data or api issue"),
                          ),
                        );
                      }else{
                        // data ayo
                        //show ui

                        return Container(
                          width: size.width,
                          height: size.height/1.8,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              padding: const EdgeInsets.all(8),
                              itemCount: snapshot.data!.articles!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return CardsandModules.verticallistitem(context,size,snapshot.data!.articles![index]);
                              }
                          ),
                        );

                      }
                    default: //error
                      return Container();//error paxi thapaula
                  }
                }),
            //list view



          ],
        ),
      ),
    );
  }

}