//
//  CompactResumeCard.swift
//  ResumeAIApp
//
//  Created by mac on 5/19/26.
//

import SwiftUI

struct CompactResumeCard: View {
    let resume: Resume
    var onClick: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Document Graphic Base Header
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: "doc.text.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 20))
            }
            
            Spacer(minLength: 0)
            
            // Text Meta Core block
            VStack(alignment: .leading, spacing: 4) {
                Text(resume.title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(resume.name)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
        }
        .padding(16)
        .frame(width: 150, height: 150, alignment: .leading)
        .background(Color(red: 0.11, green: 0.11, blue: 0.13))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
        .contentShape(Rectangle())
        .onTapGesture { onClick() }
    }
}
