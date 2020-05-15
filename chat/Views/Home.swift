//
//  Home.swift
//  chat
//
//  Created by Canberk BİBİCAN on 25.04.2020.
//  Copyright © 2020 Emre Dereli. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import SDWebImageSwiftUI
import SDWebImage
struct Home : View {
    
    @State var myuid = UserDefaults.standard.value(forKey: "UserName") as! String
    @EnvironmentObject var datas : MainObservable
    @State var show = false
    @State var activeSheet = "first"
    @State var chat = false
    @State var uid = ""
    @State var name = ""
    @State var lstmsg = ""
    @State var pic = ""
    @State var msgss = [Msg]()
    var body: some View{
        
        ZStack{
            NavigationLink(destination: ChatView(name: self.name, pic: self.pic, uid: self.uid, chat: self.$chat), isActive: self.$chat){
                Text("")
            }
            
            VStack{
                       
                   
                       if self.datas.recents.count == 0{
                        
                        if self.datas.norecetns{
                            
                            Text("Sohbet Geçmişi Bulunamadı")
                        }else{
                            
                              Indicator()
                        }
        
                       }else{
                           
                           List{
                                     
                                   //  VStack(spacing: 12){
                                           
                                        ForEach(datas.recents.sorted(by: {$0.stamp > $1.stamp})){i in
                                                   
                                                  Button(action: {
                                                    
                                                    self.uid = i.id
                                                    self.name = i.name
                                                    self.pic = i.pic
                                                    self.chat.toggle()
                                                    
                                                   }) {
                                                  
                                                    RecentCellView(url: i.pic, name: i.name, time: i.time, date: i.date, lastmsg: i.lastmsg)
                                                    
                                                   }
                                                   
                                         
                                                   
                                                   
                                               }
                                        .onDelete{ (index) in
                                            let id = self.datas.recents[index.first!].id
                                            let uid = Auth.auth().currentUser?.uid
                                            
                                            let db = Firestore.firestore().collection("users")
                                            db.document(uid!).collection("recents").document(id).delete{ (err) in
                                                                                           
                                                                                           if err != nil{
                                                                                               
                                                                                               print((err!.localizedDescription))
                                                                                               return
                                                                                           }
                                                                                           print("deleted succesfull")
                                                                                           self.datas.recents.remove(atOffsets: index)
                                            }
                                            let opponentID = db.document(uid!).collection("recents").document(id).documentID
                                            print(opponentID)
                                        
                                            
                                            
                                        }
                             //  }.padding()
                            }
                       }
                   }.navigationBarTitle("Sohbetler",displayMode: .inline)
                   .navigationBarItems(leading:
                       
                       Button(action: {
                        UserDefaults.standard.set("", forKey: "UserName")
                         UserDefaults.standard.set("", forKey: "UID")
                         UserDefaults.standard.set("", forKey: "pic")
                        
                        try! Auth.auth().signOut()
                        
                         UserDefaults.standard.set(false, forKey: "status")
                        
                        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                           
                       } , label: {
                           
                           Text("Çıkış Yap")
                           
                       })
                       
                       
                       
                       , trailing:
                    HStack{
                        Button(action: {
                            self.show.toggle()
                            self.activeSheet = "first"
                                                       } , label: {
                                                           
                                                         Image(systemName: "person.crop.circle").resizable().frame(width: 25, height: 25)
                                                           
                                                       }
                        )
                        Button(action: {
                                                           
                            self.show.toggle()
                                                                         self.activeSheet = "second"
                                                       } , label: {
                                                           
                                                         Image(systemName: "square.and.pencil").resizable().frame(width: 25, height: 25)
                                                           
                                                       }
                                          )
                    }
                  
                         
                    
            )
            
            
        }
        
       
        
       .sheet(isPresented: self.$show) {
        
        if self.activeSheet == "first"{
            ProfileView(showProfile: self.$show)
        }else{
             newChatView(name: self.$name, uid: self.$uid, pic: self.$pic, show: self.$show, chat: self.$chat)
        }
       
        
        }.onAppear(){
            updateStatus(status: true)
        }
    }
}

struct RecentCellView : View {
    
    var url : String
    var name : String
    var time : String
    var date : String
    var lastmsg : String
  
    var body : some View{
        
        HStack{
             AnimatedImage(url: URL(string: url)!).resizable().renderingMode(.original).frame(width: 55, height: 55).clipShape(Circle())
            
            
            VStack{
                 
                HStack{
                  
                    VStack(alignment: .leading, spacing: 6) {
                       
                        

                        
                                          Text(name).foregroundColor(.black)
                                         Text("Siz: "+lastmsg).foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 6) {
                        
                         Text(date).foregroundColor(.gray)
                         Text(time).foregroundColor(.gray)
                    }
                }
                
              //Divider()
            }
        }
    }
    
}

 struct newChatView : View{
    
    @ObservedObject var datas = getAllUsers()
    @Binding var name : String
    @Binding var uid : String
    @Binding var pic : String
    @Binding var show : Bool
    @Binding var chat : Bool
    
    var body : some View{
        VStack(alignment: .leading){
           
      
              
                  if self.datas.users.count == 0{
                      
                      Indicator()
                  }
                  else{
                    Text("Yeni Sohbet").font(Font.system(size: 18, weight: .heavy, design: .default)).foregroundColor(Color.black)
                      ScrollView(.vertical, showsIndicators: false){
                                
                                VStack(spacing: 12){
                                      
                                          ForEach(datas.users){i in
                                              
                                            
                                            
                                            Button(action: {
                                                self.uid = i.id
                                                self.name = i.name
                                                self.pic = i.pic
                                                self.show.toggle()
                                                self.chat.toggle()
                                            }){
                                                
                                                 UserCellView(url: i.pic, name: i.name, about: i.about)
                                            }
                                        
                                            
                                            
                                            
                                            
                                           
                                              
                                          }
                                }
                           
                    }
                  
              }
            
        }.padding()
    }
}

class getAllUsers : ObservableObject{
    @Published var users = [User]()
    
    init(){
        let db = Firestore.firestore()
        
        db.collection("users").getDocuments{ (snap,err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            
            for i in snap!.documents{
                let id = i.documentID
                let name = i.get("name")as! String
                let pic = i.get("pic") as! String
                let about = i.get("about") as! String
                
                if id != UserDefaults.standard.value(forKey: "UID") as! String {
                      self.users.append(User(id: id, name: name, pic: pic, about: about))
                }
                
              
            }
        }
    }
    
}

struct User : Identifiable{
    var id : String
    var name : String
    var pic : String
    var about : String
    
}


struct UserCellView : View {
    
    var url : String
    var name : String
    var about : String

    
    
    
    var body : some View{
        
        HStack{
             AnimatedImage(url: URL(string: url)!).resizable().renderingMode(.original).frame(width: 55, height: 55).clipShape(Circle())
            
            
            VStack{
                 
                HStack{
                    VStack(alignment: .leading, spacing: 6) {
                                          
                                          Text(name).foregroundColor(.black)
                                          Text(about).foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    
                }
                
              Divider()
            }
        }
    }
    
}




struct Msg : Identifiable {
    
    var id : String
       var msg : String
       var user : String
    var tip :String
    var url :String
}

struct ChatBubble : Shape {
    var mymsg : Bool
      
      func path(in rect: CGRect) -> Path {
              
          let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight,mymsg ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 16, height: 16))
          
          return Path(path.cgPath)
      }
}

func sendMsg(user: String,uid:String,pic:String,date:Date,msg:String){
    
    let db = Firestore.firestore()
    
    let myuid = Auth.auth().currentUser?.uid
    
    db.collection("users").document(uid).collection("recents").document(myuid!)
        .getDocument{ (snap, err) in
        
        if err != nil{
            print((err?.localizedDescription)!)
              //eğer hiç yoksa ekle
              setRecents(user: user, uid: uid, pic: pic, date: date, msg: msg)
            return
        }
        
            if !snap!.exists{
                setRecents(user: user, uid: uid, pic: pic, date: date, msg: msg)
            }
            else{
                updateRecents(uid: uid, lastmsg: msg, date: date)
            }
        
    }
    
    updateDB(uid: uid, msg: msg, date: date, tip: "text", url: "")
}


func setRecents(user: String,uid:String,pic:String,date:Date,msg:String){
    
    let db = Firestore.firestore()
    
    let myuid = Auth.auth().currentUser?.uid
    
    let myname = UserDefaults.standard.value(forKey: "UserName") as! String
    let mypic = UserDefaults.standard.value(forKey: "pic") as! String
    
    
    db.collection("users").document(uid).collection("recents").document(myuid!)
        .setData(["name": myname, "pic": mypic, "lastmsg":msg,"date":date]){ (err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            
    }
    
    db.collection("users").document(myuid!).collection("recents").document(uid)
        .setData(["name": user, "pic": pic, "lastmsg":msg,"date":date]){ (err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            
    }
}


func updateRecents(uid: String, lastmsg: String, date:Date){
    
    let db = Firestore.firestore()
    
    let myuid = Auth.auth().currentUser?.uid
    
    
    db.collection("users").document(uid).collection("recents").document(myuid!)
        .updateData(["lastmsg":lastmsg, "date":date])
    
    db.collection("users").document(myuid!).collection("recents").document(uid)
           .updateData(["lastmsg":lastmsg, "date":date])
}


func updateDB(uid:String, msg:String, date:Date, tip: String, url : String){
    
    let db = Firestore.firestore()
       
    let myuid = Auth.auth().currentUser?.uid
    
    db.collection("msgs").document(uid).collection(myuid!).document().setData(["msg":msg,"user":myuid!,"date":date, "tip": tip, "url": url]) { (err) in
        
        if err != nil{
            print((err?.localizedDescription)!)
            return
        }
        
    }
    
    db.collection("msgs").document(myuid!).collection(uid).document().setData(["msg":msg,"user":myuid!,"date":date, "tip": tip, "url": url]) { (err) in
        
        if err != nil{
            print((err?.localizedDescription)!)
            return
        }
        
    }
    
}


func sendImageMsg(data:Data, uid:String, date:Date){
    
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    let number1 = Int.random(in: 1..<10000)
    let number2 = Int.random(in: 1..<10000)
    let result = number1*number2
    var URL = ""
    let name = String(result)
    let myuid = Auth.auth().currentUser?.uid
    storage.child("images").child(name).putData(data, metadata: nil) { (_,err) in
        
        if err != nil{
            print((err?.localizedDescription)!)
            return
        }
        
        
        storage.child("images").child(name).downloadURL {(url,err)in
            
             db.collection("msgs").document(myuid!).collection(uid).document().setData(["msg":"", "tip":"img", "user":myuid!, "date":date, "url":"\(url!)"]) { (err) in
                       
                        if err != nil{
                                  print((err?.localizedDescription)!)
                                  return
                              }
                
                
                   }
        }
        
       
        
    }
    
}



struct OpponentMessage: View {
 
 @State var messageType : String
 @State var message : String
 @State var url : String

 
    var body: some View {
        HStack {
             if messageType == "img"{
                AnimatedImage(url: URL(string: url)!).resizable().renderingMode(.original).frame(width: 150, height: 150).clipShape(ChatBubble(mymsg:false))
             Spacer()
             }
             else{
                
                     Text(message)
                                                   .padding(10)
                                                   .background(Color.green)
                                                   .clipShape(ChatBubble(mymsg: false))
                                                   .foregroundColor(.white)
                
  Spacer()
                                                        
             }
            
           
        }
    }
}

