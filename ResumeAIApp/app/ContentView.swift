//
//  ContentView.swift
//  ResumeAIApp
//
//  Created by mac on 3/11/26.
//

import SwiftUI
import Supabase
import SwiftData

struct ContentView: View {
    // 1. Keep track of the active selected tab index
    @State private var selectedTab = 0
    
    // 2. StateObject to manage the lifecycle of HomeViewModel
    @State private var homeViewModel: HomeViewModel
    @State private var resumeViewModel: ResumeViewModel
    
    private let supabaseClient: SupabaseClient
    
    // 3. Inject SupabaseClient through the initializer
    @MainActor
    init(supabaseClient: SupabaseClient, modelContext: ModelContext) {
        self.supabaseClient = supabaseClient
        self._homeViewModel = State(wrappedValue: HomeViewModel(supabaseClient: supabaseClient))
        self._resumeViewModel = State(wrappedValue: ResumeViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        
       
        // Bind the TabView to control programmatic switching
        TabView(selection: $selectedTab) {
            
            
                HomeView(viewModel: homeViewModel) {
                    // When "See All" is tapped, jump to the Files tab (index 1)
                    selectedTab = 1
                }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0) // Explicit tags map to our index state
                
                ResumeLibraryView(
                    resumes: resumeViewModel.resumes,
                    coverLetters: homeViewModel.recentCoverLetters
                )
                .tabItem {
                    Image(systemName: "folder.fill")
                    Text("Files")
                }
                .tag(1)
            
            
            CoverLetterView(supabaseClient: supabaseClient)
                .tabItem {
                    Image(systemName: "sparkles")
                    Text("AI Tools")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
                .tag(3)
        }
    }
}


