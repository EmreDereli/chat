//
//  AccountCreation.swift
//  chat
//
//  Created by Canberk BİBİCAN on 25.04.2020.
//  Copyright © 2020 Emre Dereli. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
struct AccountCreation : View {
    @Binding var show : Bool
    @State var name = ""
    @State var about = ""
    @State var picker = false
    @State var loading = false
    @State var imagedata : Data = .init(count: 0)
    @State var alert = false
    
    var body : some View{
        VStack(alignment: .leading, spacing: 15){
            Text("Awesome !! Create An Account").font(.title)
            
            HStack{
                Spacer()
                Button(action: {
                    self.picker.toggle()
                }){
                    
                    if self.imagedata.count == 0{
                        Image(systemName: "person.crop.circle.badge.plus").resizable().frame(width:90, height:70).foregroundColor(.gray)
                    }
                    else{
                        Image(uiImage: UIImage(data: self.imagedata)!).resizable().renderingMode(.original).frame(width:90, height:90).clipShape(Circle())
                    }
                    
                }
                Spacer()
            }
            .padding(.vertical, 15)
            Text("Enter Username")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.top,12)

                                    
                                    
            TextField("Name",text: self.$name)
                        .keyboardType(.default)
                        .padding()
                        .background(Color("Color"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.top,10)
            
            Text("About")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.top,12)
                                            
                                               
            TextField("About",text: self.$about)
                        .keyboardType(.default)
                        .padding()
                        .background(Color("Color"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.top,10)
            
            if self.loading{
                HStack{
                    Spacer()
                    Indicator()
                    Spacer()
                }
            }
            else{
                Button(action: {
                    
                    if self.name != "" && self.about != "" && self.imagedata.count != 0{
                        self.loading.toggle()
                        CreateUser(name: self.name, about: self.about, imagedata: self.imagedata){ (status) in
                            if status{
                                self.show.toggle()
                            }
                        }
                    }else{
                        self.alert.toggle()
                    }
                  
                          }){
                              Text("Create").frame(width: UIScreen.main.bounds.width - 30, height: 50)
                                  
                              .foregroundColor(.white)
                               .background(Color.orange)
                               .cornerRadius(10)
                          }
            }
          
        }
        .padding()
        .sheet(isPresented: self.$picker, content: {
            ImagePicker(picker: self.$picker, imagedata: self.$imagedata)
        })
        .alert(isPresented: self.$alert){
            Alert(title: Text("Message"), message: Text("Please Fill The Contents"), dismissButton: .default(Text("Ok")))
        }
    }
}
