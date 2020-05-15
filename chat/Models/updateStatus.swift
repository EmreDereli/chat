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

func updateStatus( status : Bool){
    let db = Firestore.firestore()
   
    let uid = Auth.auth().currentUser?.uid
   
    db.collection("users").document(uid!).updateData(["status": status]){(err) in
                           
                           if err != nil{
                                                 print((err?.localizedDescription)!)
                                                 return
                           }
                           
                          
                       }
   
    
   
}

