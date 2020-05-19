//
//  ChatView.swift
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
struct CallView : View {
var name : String
var pic : String
var uid : String
    var url : String

@Binding var chat : Bool
@State var msgs = [Msg]()
@State var txt = ""
@State var nomsgs = false
@State var picker = false
@State var imagedata : Data = .init(count: 0)
    @State var status = false
var body : some View {
    VStack{
      
      Text(name+" aranıyor...")
        
      AnimatedImage(url: URL(string: url)!).resizable().renderingMode(.original).frame(width: 150, height: 150).clipShape(Circle())
        
    }.padding()
   
}


    
   
      
}
