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
struct ChatView : View {
var name : String
var pic : String
var uid : String

@Binding var chat : Bool
@State var msgs = [Msg]()
@State var txt = ""
@State var nomsgs = false
@State var picker = false
@State var imagedata : Data = .init(count: 0)
    @State var status = false
var body : some View {
    VStack{
      
        if msgs.count == 0{
            
            if self.nomsgs{
                Text("Yeni Bir Sohbet Başlat")
                    .foregroundColor(Color.black.opacity(0.5))
                    .padding(.top)
                
                Spacer()
                
            }else{
                
                Spacer()
                Indicator()
                Spacer()
            }
        
        }else{
            ScrollView(.vertical, showsIndicators: false){
                
                VStack(spacing: 8){
                    
                    ForEach(self.msgs){i in
                        
                        HStack{
                        
                            if i.user == UserDefaults.standard.value(forKey: "UID") as! String{
                                          
                                
                                MyMessage(messageType: i.tip, message: i.msg, url: i.url)
                                
                            
                            }else{
                                
                                //OpponentMessage(messageType: i.tip, message: i.msg, url: i.url)
                      
                                if i.tip == "img"{
                                    AnimatedImage(url: URL(string: i.url)!).resizable().renderingMode(.original).frame(width: 150, height: 150).clipShape(ChatBubble(mymsg:false))
                                           Spacer()
                                           }
                                           else{
                                              
                                    Text(i.msg)
                                                                                 .padding(10)
                                                                                 .background(Color.green)
                                                                                 .clipShape(ChatBubble(mymsg: false))
                                                                                 .foregroundColor(.white)
                                              
                                Spacer()
                                                                                      
                                           }
                               
                                                    
                           }
                            
                        }
                      
                    }
                }
            }
        }
        
        HStack{
           
            Button(action: {
                          
                          self.picker.toggle()
                         // sendImageMsg(data: self.imagedata, uid: self.uid, date: Date())
                        /* sendMsg(user: self.name, uid: self.uid, pic: self.pic, date: Date(), msg: self.txt)
                         
                         self.txt = ""*/
                          
                      }) {
                          
                          Image(systemName: "camera").resizable().frame(width: 24, height: 20)
                      }
            TextField("", text: self.$txt).font(Font.system(size: 15)).padding(5).overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.gray, lineWidth: 1))
            
          
                        
            
            Button(action: {
                if self.imagedata.count == 0{
                    if self.txt != nil && self.txt != ""{
                        sendMsg(user: self.name, uid: self.uid, pic: self.pic, date: Date(), msg: self.txt)
                        
                        self.txt = ""
                    }
                    
                }
                else{
                    sendImageMsg(data: self.imagedata, uid: self.uid, date: Date())
                                            self.imagedata.count = 0
                }
                
                           
                             
                         }) {
                             
                             Image(systemName: "paperplane").resizable().frame(width: 24, height: 24)
                         }
            
        }
        
            //.navigationBarTitle("\(name)",displayMode: .inline)
            .navigationBarItems(leading:
                HStack{
                    Button(action: {
                            self.chat.toggle()
                            }, label: {
                                Image(systemName: "arrow.left").resizable().frame(width:20, height:15)
                    })
                    HStack{
                           AnimatedImage(url: URL(string: pic)!).resizable().renderingMode(.original).frame(width: 30, height: 30).clipShape(Circle())
                        VStack(alignment: .leading){
                            
                          
                            
                              Text(name).font(Font.system(size: 14, weight: .semibold, design: .default))
                            if self.status == true{
                                 Text("Online").font(Font.system(size: 10, weight: .ultraLight, design: .default))
                            }else{
                                 Text("Offline").font(Font.system(size: 10, weight: .ultraLight, design: .default))
                            }
                           
                        }
                      
                    }.padding(.horizontal, 10)
                   
                    
                },
                                 trailing :
                                                   HStack{
                                                       Button(action: {
                                                                                 
                                                                                  }, label: {
                                                                                      Image(systemName: "video").resizable().frame(width:22, height:20)
                                                                          })
                                                    
                                                    Button(action: {
                                                                                                                                   
                                                                                                                                    }, label: {
                                                                                                                                        Image(systemName: "phone").resizable().frame(width:20, height:20)
                                                                                                                            })
                                                   }
            
                
        )
    }.padding()
    .sheet(isPresented: self.$picker, content: {
        ImagePicker(picker: self.$picker, imagedata: self.$imagedata)
    })
        .onAppear(){
            
        self.getMsgs()
            self.getStatus()
    }
}

func getMsgs(){
    
    let db = Firestore.firestore()
    
    let uid = Auth.auth().currentUser?.uid
    
    db.collection("msgs").document(uid!).collection(self.uid).order(by: "date", descending: false).addSnapshotListener { (snap, err) in
        
        if err != nil{
                      print((err?.localizedDescription)!)
                      self.nomsgs = true
                      return
                      
                  }
                  
                  if snap!.isEmpty{
                      
                      self.nomsgs = true
                  }
                  
                  for i in snap!.documentChanges{
                      
                    if i.type == .added{
                        let id = i.document.documentID
                        let msg = i.document.get("msg") as! String
                        let user = i.document.get("user") as! String
                        var tip = "text"
                        var url = ""
                        if i.document.get("tip") != nil && i.document.get("url") != nil{
                             tip = i.document.get("tip") as! String
                             url = i.document.get("url") as! String
                        }
                        print(tip)
                                            
                        self.msgs.append(Msg(id: id, msg: msg, user: user, tip: tip, url: url))
                    }
                    
                    
                  }
                  
              }
        
        
    }
    
    
    func getStatus(){
        let db = Firestore.firestore()
        
     /*   db.collection("users").document(self.uid).getDocument{ (document, error) in
            
            if let info = document?.data() as? [String: Any]{
                print(info["status"])
                
            }
            
            
        }*/
        
        db.collection("users").document(uid).addSnapshotListener{ (document, error) in
            
       
             self.status = document?.get("status") as! Bool
        }
        
    }
        
      
}
