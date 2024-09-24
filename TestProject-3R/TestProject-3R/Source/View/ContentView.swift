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
                Button{
                    NavigationLink(destination:SttView())
                } label: {
                    Text("SttView")
                }
                
                Button{
                    NavigationLink(destination: GptView())
                } label: {
                    Text("GptView")
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
