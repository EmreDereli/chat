//
//  ImageModal.swift
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

struct ImageModal : View {
    
    @Binding var showModal : Bool
    @State var imgURL : String
     
    @Environment(\.presentationMode) var presentationmode: Binding<PresentationMode>
    var body : some View{
        ZStack{
            
            GeometryReader{ geometry in
                AnimatedImage(url: URL(string: self.imgURL)!).resizable().renderingMode(.original).frame(width: geometry.size.width, height: geometry.size.width)
            }
          
              
        }.navigationBarTitle("Fotoğraf",displayMode: .inline)
        .navigationBarItems(leading:
            Button(action:{
                self.showModal.toggle()
            }){
                 Text("Bitti")
            }
           
        ).navigationBarBackButtonHidden(true)
        
    }
    
}
