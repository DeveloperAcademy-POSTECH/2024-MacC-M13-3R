//
//  ContentView.swift
//  TestProject-3R
//
//  Created by siye on 9/24/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            VStack {
                NavigationLink(destination:SttView()){
                    Text("SttView")
                        .font(.title)
                }.padding()
                
                NavigationLink(destination: GptView()){
                    Text("GptView") 
                        .font(.title)
                }.padding()
                
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
