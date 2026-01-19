import 'package:flutter/material.dart';

import 'audioRecordWidget.dart';
import 'emotionApiService.dart';
import 'emotionResultPage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  TextEditingController emotion = TextEditingController();
  String? detectedEmotion;
  double? confidence;
  bool isLoading= false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Detect Emotion",
        ),
        centerTitle: true,
      ),
     body:
     ListView(
         children: [
           Padding(
             padding: const EdgeInsets.only(left: 30,right: 30,top: 20),
             child: Container(
               height: 150,
               width: MediaQuery.of(context).size.width,
               decoration: BoxDecoration(
                 boxShadow: [
                   BoxShadow(
                     color: Colors.grey.withOpacity(0.1),
                     spreadRadius: 5,

                   )
                 ],
                 borderRadius: BorderRadius.circular(10),
               ),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   SizedBox(height: 20,),
                   Padding(
                     padding: const EdgeInsets.only(left: 20),
                     child: Row(
                       children: [
                         Icon(Icons.info_outline,color: Colors.blue,),
                         SizedBox(width: 10,),
                         Text(
                           "How to use",
                           style: TextStyle(
                             fontSize: 20,

                             color: Colors.blue,
                           ),
                         ),
                       ],
                     ),
                   ),
                   SizedBox(height: 10,),
                   Padding(
                     padding: const EdgeInsets.only(left: 50,right: 10),
                     child: Text(
                       "Share your feelings through text or voice. Be as detailed as you'd like to help us understand your emotional state better."
                     ),
                   )
                 ],
               ),
             ),
           ), //how to use
           SizedBox(height: 20,),
           Padding(
             padding: const EdgeInsets.only(left: 30,right: 30),
             child: Container(
               height: 400,
               width: MediaQuery.of(context).size.width,
               decoration: BoxDecoration(
                 color: Colors.white,
                 border: Border.all(
                   color: Colors.grey,
                   width: 2,
                 ),
                 borderRadius: BorderRadius.circular(10),
               ),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   SizedBox(height: 20,),
                   Padding(
                     padding: const EdgeInsets.only(left: 30),
                     child: Text(
                         "Describe Your Feeling",
                       style: TextStyle(
                         fontSize: 20,
                         fontWeight: FontWeight.bold,

                       ),
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(left: 30),
                     child: Text(
                         "Whats on your mind?",
                       style: TextStyle(
                         color: Colors.grey,
                         fontSize: 15,
                       ),
                     ),
                   ),
                   SizedBox(height: 20,),
                   Padding(
                     padding: const EdgeInsets.only(left: 30,right: 30),
                     child: Container(
                       height: 140,
                       width: MediaQuery.of(context).size.width,
                       decoration: BoxDecoration(
                         border: Border.all(
                           color: Colors.grey,
                           width: 1,
                         ),
                         borderRadius: BorderRadius.circular(20),
                       ),
                       child: Padding(
                         padding: const EdgeInsets.only(left: 10,top:5,right: 10,bottom: 5),
                         child: TextFormField(
                           controller: emotion,
                           maxLines: 5,
                           decoration: InputDecoration(
                             hintText: "Tell us how you're feeling right now. You can describe your mood, what triggered it or any thoughts you'd like to share...",
                             border: InputBorder.none,
                           ),
                         ),
                       ),
                     ),
                   ),
                   SizedBox(height: 20,),
                   Padding(
                     padding: const EdgeInsets.only(left: 30,right: 30,),
                     child: Container(
                       height: 100,
                       width: MediaQuery.of(context).size.width,
                       decoration: BoxDecoration(
                         boxShadow: [
                           BoxShadow(
                             color: Colors.grey.withOpacity(0.1),
                             spreadRadius: 5,

                           )
                         ],
                         borderRadius: BorderRadius.circular(20),
                       ),
                       child: Padding(
                         padding: const EdgeInsets.only(left:20),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             SizedBox(height: 10,),
                             Text(
                                 "Tips for better analysis:",
                               style: TextStyle(
                                 color: Colors.black,
                               ),
                             ),
                             SizedBox(height: 5,),
                             Text(
                                 "i)  Be specific about what you are feeling",
                               style: TextStyle(
                                 color: Colors.grey,
                                 fontSize: 10
                               ),
                             ),
                             Text(
                                 "ii)  Mention and trigger or context",
                               style: TextStyle(
                                 color: Colors.grey,
                                 fontSize: 10
                               ),
                             ),
                             Text(
                                 "iii)  Share your physical sensation if relevant",
                               style: TextStyle(
                                 color: Colors.grey,
                                 fontSize: 10
                               ),
                             ),
                           ],
                         ),
                       ),
                     ),
                   ),
                 ],
               ),
             ),
           ) ,// describe you feelings
           SizedBox(height:20 ,),
           Padding(
             padding: const EdgeInsets.only(left: 30,right: 30),
             child: Container(
               height: 200,
               width: MediaQuery.of(context).size.width,
               decoration: BoxDecoration(
                 color: Colors.white,
                 border: Border.all(
                   color: Colors.grey,
                   width: 2,
                 ),
                 borderRadius: BorderRadius.circular(10),
               ),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Padding(
                     padding: const EdgeInsets.only(left: 30,top: 20),
                     child: Row(
                       children: [
                         Icon(Icons.mic,size: 25,),
                         SizedBox(width: 15,),
                         Text("Voice Input",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                       ],
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(left: 70),
                     child: Text("Record your feelings in your own voice"),
                   ),
                   SizedBox(height: 20,),
                   Padding(
                     padding: const EdgeInsets.only(left: 30,right: 30),
                     child: Container(
                       height: 60,
                       width: MediaQuery.of(context).size.width,
                       decoration: BoxDecoration(
                         color: Colors.purple,
                         borderRadius: BorderRadius.circular(20),
                       ),
                       child: GestureDetector(
                         onTap: () async {
                           String? recordedFilePath =
                           await showModalBottomSheet<String>(
                             context: context,
                             isScrollControlled: true,
                             backgroundColor: Colors.transparent,
                             builder: (context) => Padding(
                               padding: EdgeInsets.only(
                                 bottom: MediaQuery.of(context).viewInsets.bottom,
                               ),
                               child: AudioRecorderWidget(),
                             ),
                           );

                           if (recordedFilePath == null) return;

                           // Optional loading indicator
                           showDialog(
                             context: context,
                             barrierDismissible: false,
                             builder: (_) => const Center(
                               child: CircularProgressIndicator(),
                             ),
                           );

                           try {
                             final result =
                             await EmotionApiService.analyzeAudio(recordedFilePath);

                             Navigator.pop(context); // remove loading dialog

                             Navigator.push(
                               context,
                               MaterialPageRoute(
                                 builder: (_) => EmotionResultPage(
                                   emotion: result['emotion'],
                                   confidence: result['confidence'],
                                 ),
                               ),
                             );
                           } catch (e) {
                             Navigator.pop(context);

                             ScaffoldMessenger.of(context).showSnackBar(
                               const SnackBar(content: Text("Emotion analysis failed")),
                             );
                           }
                         },

                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Icon(Icons.mic,color: Colors.white,),
                             SizedBox(width: 10,),
                             Text(
                               "Start Recording",
                               style: TextStyle(
                                   fontWeight: FontWeight.bold,
                                   fontSize: 20,
                                   color: Colors.white
                               ),
                             )
                           ],
                         ),
                       ),
                     ),
                   )

                 ],
               ),
             ),
           )//voice recording
         ],

     ),

    );
  }
}
