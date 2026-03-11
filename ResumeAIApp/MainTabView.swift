//
//  MainTabView.swift
//  ResumeAIApp
//
//  Created by mac on 3/11/26.
//

import SwiftUI

struct MainTabView: View {
    
    var body: some View {
        
        TabView {
            
            HomeView()
                .tabItem {
                    Image(systemName: "doc.text.fill")
                    Text("Resumes")
                }
            
            CoverLetterView()
                .tabItem {
                    Image(systemName: "sparkles")
                    Text("AI Tools")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
    }
}

#Preview {
    MainTabView()
}
