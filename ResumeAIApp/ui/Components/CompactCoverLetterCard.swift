//
//  CompactCoverLetterCard.swift
//  ResumeAIApp
//
//  Created by mac on 5/19/26.
//

import SwiftUI

struct CompactCoverLetterCard: View {
    let letter: CoverLetter
    var onClick: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Envelope Action Icon Layout
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.green.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: "envelope.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 18))
            }
            
            Spacer(minLength: 0)
            
            // Details meta frame
            VStack(alignment: .leading, spacing: 4) {
                Text(letter.companyName ?? "Target Company")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(letter.jobTitle ?? "Position Title")
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
