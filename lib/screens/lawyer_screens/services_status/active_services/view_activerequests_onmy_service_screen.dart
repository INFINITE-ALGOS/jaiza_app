import 'package:flutter/material.dart';
import 'package:law_education_app/widgets/cache_image_circle.dart';
import 'package:law_education_app/widgets/see_more_text.dart';

import '../../../../conts.dart';
class ViewActiverequestsOnmyServiceScreen extends StatefulWidget {
  Map<String,dynamic> service;
  List<Map<String,dynamic>> activeRequests;
   ViewActiverequestsOnmyServiceScreen({super.key,required this.service,required this.activeRequests});

  @override
  State<ViewActiverequestsOnmyServiceScreen> createState() => _ViewActiverequestsOnmyServiceScreenState();
}

class _ViewActiverequestsOnmyServiceScreenState extends State<ViewActiverequestsOnmyServiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Requests'),
        backgroundColor: Colors.transparent,
      ),
      body:widget.activeRequests.isNotEmpty? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 30),
        child: ListView.builder(itemCount:widget.activeRequests.length ,itemBuilder: (context,index){
          return ActiveServiceCard(service: widget.service, request: widget.activeRequests[index]);

        }),
      ):Center(child: Text("No Active Requests Found"),),
    );
  }
}
class ActiveServiceCard extends StatelessWidget {
  final Map<String, dynamic> service;
  final Map<String, dynamic> request;
   ActiveServiceCard({super.key,
    required this.service,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String,dynamic> requestDetails=request['requestDetails'];
    final Map<String,dynamic> clientDetails=request['clientDetails'];

    return InkWell(
      onTap: (){
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
            width: MediaQuery.sizeOf(context).width,
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              border: Border.all(color: lightGreyColor,width: 2),
              borderRadius: BorderRadius.circular(18),
            ),
            child:Column(
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,

                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            constraints:BoxConstraints(maxWidth: 200),
                            child: SeeMoreTextCustom(text: requestDetails['requestMessage']?? '??',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600)))
                     ,   Spacer(),
                        Container(
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(6)
                          ),
                          padding: EdgeInsets.all(5),
                          child: Text('${requestDetails['status']??''}'.toUpperCase(),style: TextStyle(color: whiteColor,fontSize: 9),),
                        )
                      ],
                    ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //  Icon(Icons.star,color: yellowColor,),
                              Text(requestDetails['duration']?? '',style: TextStyle(),),
                            ],
                          ),
                          Text('PKR ${requestDetails['requestAmount']?? ''}',style: TextStyle(color: greyColor),)
                        ],
                      )],
                  ),
                ),
                Divider(),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          children: [Text(clientDetails['name']?? '??',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.star,color: yellowColor,),
                                Text(clientDetails['rating']?? '0.0',style: TextStyle(),),
                              ],
                            ),
                          ]                ),
                      InkWell(
                          onTap:(){

                          },
                          child: CacheImageCircle(url: clientDetails['url']))
                    ],
                  ),
                ),

              ],
            )
        ),
      ),
    );
  }

}

