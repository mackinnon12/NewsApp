//
//  ContentView.swift
//  NewsApp
//
//  Created by Jacob MacKinnon on 2021-12-23.
//

import SwiftUI

struct ContentView: View {
    var newsChoice = "bbc"
    
    var body: some View {
        
        TabView() {
            NewsView(newsChoice: "cbc")
                .tabItem {
                    Image("cbcLogo")
                    Text("CBC")
                }
            NewsView(newsChoice: "bbc")
                .tabItem {
                    Image("bbcLogo")
                    Text("BBC")
                }
                .tag("bbc")
            //SettingsView()
            Text("Settings")
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
