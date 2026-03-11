//
//  HomeView.swift
//  ResumeAIApp
//
//  Created by mac on 3/11/26.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel = ResumeViewModel()
    
    @State private var showEditor = false
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack(spacing: 16) {
                    
                    ForEach(viewModel.resumes) { resume in
                        ResumeCard(resume: resume)
                    }
                }
                .padding()
            }
            
            .navigationTitle("My Resumes")
            
            .toolbar {
                
                Button {
                    showEditor.toggle()
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
            }
            
            .sheet(isPresented: $showEditor) {
                ResumeEditorView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    HomeView()
}
