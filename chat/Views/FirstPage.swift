//
//  FirstPage.swift
//  chat
//
//  Created by Canberk BİBİCAN on 25.04.2020.
//  Copyright © 2020 Emre Dereli. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct FirstPage : View {
    
    @State var ccode = ""
    @State var no = ""
    @State var show = false
    @State var msg = ""
    @State var alert = false
    @State var ID = ""
    
    var body : some View{
        VStack(spacing: 20){
            
            Image("pic")
            
            Text("Verify Your Number").font(.largeTitle).fontWeight(.heavy)
            
            Text("Please Enter Your Number To Verify Your Account")
                .multilineTextAlignment(.center)
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top,12)

            HStack{
            
                TextField("+1",text: $ccode)
                    .keyboardType(.default)
                    .frame(width: 45)
                    .padding()
                    .background(Color("Color"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                

                TextField("Number",text: $no)
                    .keyboardType(.default)
                    .padding()
                    .background(Color("Color"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                   
            }.padding(.top,15)
            
            
            NavigationLink(destination: ScndPage(show: $show, ID: $ID),isActive: $show){
                Button(action:{
                   // Auth.auth().settings?.isAppVerificationDisabledForTesting = true
                    PhoneAuthProvider.provider().verifyPhoneNumber("+"+self.ccode+self.no, uiDelegate: nil){ (ID, err)in
                        
                        if err != nil{
                            
                            self.msg = (err?.localizedDescription)!
                            self.alert.toggle()
                            return
                            
                        }
                        self.ID = ID!
                        self.show.toggle()
                    }
                    
                }){
                    Text("Send").frame(width: UIScreen.main.bounds.width - 30, height: 50)
                    
                }.foregroundColor(.white)
                 .background(Color.orange)
                 .cornerRadius(10)
                
                
            }
            
            
            
             .navigationBarTitle("")
             .navigationBarHidden(true)
             .navigationBarBackButtonHidden(true)
            
        }.padding()
        .alert(isPresented: $alert){
                
            Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
        }
        
    }
}
