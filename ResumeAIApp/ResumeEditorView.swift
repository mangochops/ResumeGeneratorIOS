//
//  ResumeEditorView.swift
//  ResumeAIApp
//
//  Created by mac on 3/11/26.
//

import SwiftUI

struct ResumeEditorView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: ResumeViewModel
    
    @State private var name = ""
    @State private var title = ""
    @State private var summary = ""
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                Section("Personal Info") {
                    
                    TextField("Full Name", text: $name)
                    
                    TextField("Job Title", text: $title)
                }
                
                Section("Professional Summary") {
                    
                    TextEditor(text: $summary)
                        .frame(height: 120)
                    
                    Button("Improve with AI") {
                        improveSummary()
                    }
                }
            }
            
            .navigationTitle("New Resume")
            
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button("Save") {
                        
                        let resume = Resume(
                            name: name,
                            title: title,
                            summary: summary
                        )
                        
                        viewModel.addResume(resume: resume)
                        
                        dismiss()
                    }
                }
            }
        }
    }
    
    func improveSummary() {
        
        summary = "Results-driven professional experienced in building scalable software, improving performance, and delivering impactful digital products."
    }
}

#Preview {
    ResumeEditorView( viewModel: ResumeViewModel())
}
