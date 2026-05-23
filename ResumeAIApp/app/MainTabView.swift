//
//  MainTabView.swift
//  ResumeAIApp
//
//  Created by mac on 3/11/26.
//

import SwiftUI
import Supabase

struct MainTabView: View {
    @State private var homeViewModel: HomeViewModel
    @State private var selectedTab = 0
    
    private let supabaseClient: SupabaseClient
    
    @MainActor
    init(supabaseClient: SupabaseClient) {
        self.supabaseClient = supabaseClient
        // FIXED: Safely initializing StateObject with your injected Supabase dependency
        _homeViewModel = State(wrappedValue: HomeViewModel(supabaseClient: supabaseClient))
    }
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            HomeView(
                viewModel: homeViewModel,
                onSeeAllResumes: {
                                    selectedTab = 0  // Or whatever tab index your Files/Library tab is
                                    // Or present a sheet: showLibrarySheet = true
                                }
                )
                .tabItem {
                    Image(systemName: "doc.text.fill")
                    Text("Files")
                }
                .tag(0)
            
            CoverLetterView(supabaseClient: supabaseClient)
                .tabItem {
                    Image(systemName: "sparkles")
                    Text("AI Tools")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(2)
        }
    }
}

