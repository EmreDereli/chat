//
//  ProfileView.swift
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
struct ProfileView: View {
 
  @Binding var showProfile : Bool
    @State var picker = false
     @State var imagedata : Data = .init(count: 0)
    @State var about = ""
    @State var alert = false
    @State var activeAlert = "warn"
    
    let myname = UserDefaults.standard.value(forKey: "UserName") as! String
      let mypic = UserDefaults.standard.value(forKey: "pic") as! String
      
 
    var body: some View {
        ScrollView(.vertical){
            VStack (alignment:.leading, spacing:50){
                VStack{
                Text("Profilim").font(Font.system(size: 22, weight: .heavy, design: .default)).foregroundColor(Color.black)
                }.padding()
                
                HStack{
                    Spacer()
                    Button(action: {
                                                  self.picker.toggle()
                                              }){
                                                  
                                                  if self.imagedata.count == 0{
                                                       AnimatedImage(url: URL(string: mypic)!).resizable().renderingMode(.original).frame(width: 100, height: 100).clipShape(Circle())
                                                  }
                                                  else{
                                                      Image(uiImage: UIImage(data: self.imagedata)!).resizable().renderingMode(.original).frame(width:100, height:100).clipShape(Circle())
                                                  }
                                                  
                                              }
                    Spacer()
                }
           
                HStack{
                    Spacer()
                    Text("Merhaba "+myname)
                                   .padding(10)
                                   .foregroundColor(.black)
                            
                    Spacer()
                }
                
                                                              
                           TextField("About",text: self.$about)
                                       .keyboardType(.default)
                                       .padding()
                                       .background(Color("Color"))
                                       .clipShape(RoundedRectangle(cornerRadius: 10))
                                       .padding(10)
                           
                HStack(alignment: .bottom){
                Divider()
                Button(action: {
                    
                    if  self.about != "" && self.imagedata.count != 0{
                                         
                                        UpdateUser( about: self.about, imagedata: self.imagedata){ (status) in
                                              if status{
                                                  self.alert.toggle()
                                                
                                              }
                                          }
                                      }
                                                    }){
                                                            Text("Kaydet").frame(width: UIScreen.main.bounds.width - 30, height: 50)
                                                            
                                                        }.foregroundColor(.white)
                                                         .background(Color.orange)
                                                         .cornerRadius(10)
                
            }
               
            
                                        
            }
            .sheet(isPresented: self.$picker, content: {
                   ImagePicker(picker: self.$picker, imagedata: self.$imagedata)
               })
            .alert(isPresented: self.$alert){
               
               
                                  
                             
                                  Alert(title: Text("Başarılı"), message: Text("Ayarlar Kaydedildi"), dismissButton: .default(Text("Tamam")))
                             
            }
            
    }
    }
}
