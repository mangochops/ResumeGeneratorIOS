//
//  CoverLetterView.swift
//  ResumeAIApp
//
//  Created by mac on 3/11/26.
//

import SwiftUI

struct CoverLetterView: View {
    
    @State private var jobDescription = ""
    
    @State private var result = ""
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack(spacing: 20) {
                    
                    Text("Paste Job Description")
                        .font(.headline)
                    
                    TextEditor(text: $jobDescription)
                        .frame(height: 200)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray)
                        )
                    
                    Button("Generate AI Cover Letter") {
                        generateLetter()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    if !result.isEmpty {
                        
                        Text(result)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
            
            .navigationTitle("AI Tools")
        }
    }
    
    func generateLetter() {
        
        result = """
Dear Hiring Manager,

I am excited to apply for this role. My experience building scalable software applications and solving complex problems aligns well with the needs of this position.

I would welcome the opportunity to contribute my technical expertise and passion for innovation to your team.

Sincerely,
Applicant
"""
    }
}

#Preview {
    CoverLetterView()
}
