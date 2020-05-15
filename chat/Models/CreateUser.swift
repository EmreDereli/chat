//
//  CreateUser.swift
//  chat
//
//  Created by Canberk BİBİCAN on 25.04.2020.
//  Copyright © 2020 Emre Dereli. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

func CreateUser(name: String, about : String, imagedata: Data, completion: @escaping (Bool)-> Void){
    let db = Firestore.firestore()
    
    let storage = Storage.storage().reference()
    
    let uid = Auth.auth().currentUser?.uid
    
    storage.child("profilepics").child(uid!).putData(imagedata, metadata: nil){
        (_,err)in
        if err != nil{
            print((err?.localizedDescription)!)
            return
        }
        storage.child("profilepics").child(uid!).downloadURL{(url, err) in
            if err != nil{
                       print((err?.localizedDescription)!)
                       return
            }
            
            db.collection("users").document(uid!).setData(["name":name,"about": about,"pic":"\(url!)", "uid": uid]){(err) in
                
                if err != nil{
                                      print((err?.localizedDescription)!)
                                      return
                }
                completion(true)
                UserDefaults.standard.set(true, forKey: "status")
                UserDefaults.standard.set(name, forKey: "UserName")
                UserDefaults.standard.set(uid, forKey: "UID")
                UserDefaults.standard.set("\(url!)", forKey: "pic")
                NotificationCenter.default.post(name: NSNotification.Name("statusChange"),object:nil)
            }
        }
    }
}

