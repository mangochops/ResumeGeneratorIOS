//
//  ResumeLibrary.swift
//  ResumeAIApp
//
//  Created by mac on 3/13/26.
//

import SwiftUI
import SwiftData

struct ResumeLibraryView: View {
    @State private var viewModel: ResumeViewModel?
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Resume.createdAt, order: .reverse)
    private var resumes: [Resume]
    
    @State private var showEditor = false
    
    var body: some View {
        NavigationStack {
            
            
            ZStack {
                
                if resumes.isEmpty {
                    emptyState
                } else {
                    resumeList
                }
                
                createButton
            }
            .navigationTitle("My Resumes")
            .sheet(isPresented: $showEditor) {
                            if let vm = viewModel {
                                ResumeEditorView(viewModel: vm)
                            }
                        }
            .onAppear {
                if viewModel == nil {
                    viewModel = ResumeViewModel(modelContext: modelContext)
                }
            }
        }
    }
}

extension ResumeLibraryView {
    
    // MARK: Resume List
    
    private var resumeList: some View {
        List {
            ForEach(resumes) { resume in
                ResumeCard(resume: resume)
                    .listRowSeparator(.hidden)
            }
            .onDelete(perform: deleteResume)
        }
        .listStyle(.plain)
    }
    
    // MARK: Empty State
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.6))
            
            Text("No Resumes Yet")
                .font(.title2.bold())
            
            Text("Create your first AI optimized resume")
                .foregroundStyle(.secondary)
            
            Button {
                showEditor = true
            } label: {
                Label("Create Resume", systemImage: "plus")
                    .padding()
                    .frame(maxWidth: 220)
                    .background(.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
    
    // MARK: Floating Button
    
    private var createButton: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    showEditor = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title2)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
            }
            .padding()
        }
    }
    
    // MARK: Delete
    
    private func deleteResume(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(resumes[index])
        }
    }
}


#Preview {
    ResumeLibraryView()
}
