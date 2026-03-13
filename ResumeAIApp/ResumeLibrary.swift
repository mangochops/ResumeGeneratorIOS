//
//  ResumeLibrary.swift
//  ResumeAIApp
//
//  Created by mac on 3/13/26.
//

import SwiftUI

struct ResumeLibraryView: View {
    
    @State var resumes: [Resume] = StorageService.shared.load()
    
    var body: some View {
        
        NavigationStack {
            
            List(resumes, id: \.id) { resume in
                
                VStack(alignment: .leading) {
                    
                    Text(resume.title)
                        .font(.headline)
                    
                    Text(String(resume.content.prefix(120)))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("My Resumes")
        }
    }
}

#Preview {
    ResumeLibraryView()
}
