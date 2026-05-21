//
//  ActionCard.swift
//  ResumeAIApp
//
//  Created by mac on 3/12/26.
//

import SwiftUI

struct ActionCard: View {
    let title: String
    let subtitle: String
    let iconName: String
    let accentColor: Color
    var onClick: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(accentColor.opacity(0.12))
                    .frame(width: 48, height: 48)
                
                Image(systemName: iconName)
                    .foregroundColor(accentColor)
                    .font(.system(size: 20, weight: .semibold))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray.opacity(0.5))
                .font(.system(size: 14, weight: .semibold))
        }
        .padding(16)
        .background(Color(red: 0.11, green: 0.11, blue: 0.13))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
        .padding(.horizontal, 20)
        .onTapGesture { onClick() }
    }
}
