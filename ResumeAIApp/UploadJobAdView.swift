//
//  UploadJobAdView.swift
//  ResumeAIApp
//
//  Created by mac on 3/12/26.
//

import SwiftUI

struct UploadJobAdView: View {
    
    @State private var jobLink = ""
    @State private var jobDescription = ""
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack(spacing: 20) {
                    
                    Text("Paste Job Advert Link")
                        .font(.headline)
                    
                    TextField("https://company.com/job", text: $jobLink)
                        .textFieldStyle(.roundedBorder)
                    
                    Text("OR paste job description")
                        .font(.headline)
                    
                    TextEditor(text: $jobDescription)
                        .frame(height: 200)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray)
                        )
                    
                    Button("Analyze Job & Tailor CV") {
                        print("Start AI analysis")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            
            .navigationTitle("Job Advert")
        }
    }
}
#Preview {
    UploadJobAdView()
}
