//
//  ContentView.swift
//  ResumeAIApp
//
//  Created by mac on 3/11/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        TabView {
            
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            ResumeLibraryView()
                .tabItem {
                    Image(systemName: "folder.fill")
                    Text("Resumes")
                }
            
            CoverLetterView()
                .tabItem {
                    Image(systemName: "sparkles")
                    Text("AI Tools")
                }
            
            
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
    }
}


#Preview {
    ContentView()
}
