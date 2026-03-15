//
//  LinkedInImportView.swift
//  ResumeAIApp
//
//  Created by mac on 3/14/26.
//

import SwiftUI
import UniformTypeIdentifiers

struct LinkedInImportView: View {
    
    @State private var showFileImporter = false
    @State private var extractedText = ""
    
    var body: some View {
        
        VStack(spacing: 25) {
            
            Image(systemName: "link.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("Import from LinkedIn")
                .font(.title.bold())
            
            Text("Export your LinkedIn profile as a PDF and upload it to automatically generate your resume.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
            
            Button("Upload LinkedIn PDF") {
                showFileImporter = true
            }
            .buttonStyle(.borderedProminent)
            
            if !extractedText.isEmpty {
                
                ScrollView {
                    Text(extractedText)
                        .font(.footnote)
                        .padding()
                }
                .frame(height: 200)
            }
        }
        .padding()
        
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.pdf]
        ) { result in
            
            switch result {
                
            case .success(let url):
                
                if let text = PDFParser.extractText(from: url) {
                    extractedText = text
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    LinkedInImportView()
}
