//
//  Indicator.swift
//  chat
//
//  Created by Canberk BİBİCAN on 25.04.2020.
//  Copyright © 2020 Emre Dereli. All rights reserved.
//

import SwiftUI

struct Indicator : UIViewRepresentable{
    func makeUIView(context: UIViewRepresentableContext<Indicator>) -> UIActivityIndicatorView{
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Indicator>) {
        
    }
}
