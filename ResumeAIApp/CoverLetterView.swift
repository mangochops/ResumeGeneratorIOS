//
//  CoverLetterView.swift
//  ResumeAIApp
//
//  Created by mac on 3/11/26.
//

import SwiftUI

struct CoverLetterView: View {
    
    @State private var jobDescription = ""
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 25) {
                    
                    header
                    
                    jobDescriptionCard
                    
                    generateButton
                    
                    quickTools
                    
                }
                .padding()
            }
            .navigationTitle("AI Tools")
        }
    }
}
    


extension CoverLetterView {
    
    private var header: some View {
        
        VStack(alignment: .leading, spacing: 6) {
            
            Text("Smart tools for job applications")
                .foregroundStyle(.secondary)
        }
    }
}



extension CoverLetterView {
    
    private var jobDescriptionCard: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            Label("Paste Job Description", systemImage: "doc.text")
                .font(.headline)
            
            TextEditor(text: $jobDescription)
                .frame(height: 160)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3))
                )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

extension CoverLetterView {
    
    private var generateButton: some View {
        
        Button {
            
            generateCoverLetter()
            
        } label: {
            
            HStack {
                
                Image(systemName: "sparkles")
                
                Text("Generate AI Cover Letter")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .buttonStyle(.borderedProminent)
    }
}

extension CoverLetterView {
    
    private var quickTools: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Quick AI Tools")
                .font(.title3.bold())
            
            AIQuickTool(
                title: "Rewrite Resume Bullet",
                icon: "pencil"
            )
            
            AIQuickTool(
                title: "Improve Resume Summary",
                icon: "text.alignleft"
            )
            
            AIQuickTool(
                title: "Analyze Job Match",
                icon: "chart.bar"
            )
        }
    }
}



extension CoverLetterView {
    
    func generateCoverLetter() {
        
        print("Generating cover letter with job description:")
        print(jobDescription)
        
        // Send to AI API here
    }
}




#Preview {
    CoverLetterView()
}
