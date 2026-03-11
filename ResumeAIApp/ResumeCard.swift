//
//  ResumeCard.swift
//  ResumeAIApp
//
//  Created by mac on 3/11/26.
//

import SwiftUI

struct ResumeCard: View {
    
    let resume: Resume
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            Text(resume.name)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(resume.title)
                .foregroundColor(.gray)
            
            Text(resume.summary)
                .font(.caption)
                .lineLimit(2)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}

//#Preview {
//    ResumeCard()
//}
