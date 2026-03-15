//
//  AIQuickTool.swift
//  ResumeAIApp
//
//  Created by mac on 3/14/26.
//

import SwiftUI

struct AIQuickTool: View {
    
    let title: String
    let icon: String
    
    var body: some View {
        
        Button {
            
        } label: {
            
            HStack(spacing: 12) {
                
                Image(systemName: icon)
                    .frame(width: 28)
                    .foregroundColor(.accentColor)
                
                Text(title)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(.secondarySystemBackground))
            )
        }
        .buttonStyle(.plain)
    }
}
