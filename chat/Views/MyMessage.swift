//
//  MyMessage.swift
//  chat
//
//  Created by Canberk BİBİCAN on 14.05.2020.
//  Copyright © 2020 Emre Dereli. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import SDWebImageSwiftUI
import SDWebImage
struct MyMessage: View {
 
 @State var messageType : String
 @State var message : String
 @State var url : String
 @State var showImage = false

 
    var body: some View {
        HStack {
         
          Spacer()
         
             if messageType == "img"{
                 NavigationLink(destination: ImageModal(showModal: self.$showImage, imgURL: self.url ), isActive: self.$showImage){
                             
                               Button(action:{
                                       
                                   self.showImage.toggle()
                               }){
                                     AnimatedImage(url: URL(string: url)!).resizable().renderingMode(.original).frame(width: 150, height: 150).clipShape(ChatBubble(mymsg:true))
                               }
                           }
                           
              
                
                                                        
             }
             else{
                
                     Text(message)
                                                   .padding(10)
                                                   .background(Color.blue)
                                                   .clipShape(ChatBubble(mymsg: true))
                                                   .foregroundColor(.white)
                
 
                                                        
             }
           
        }
    }
}
