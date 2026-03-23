//
//  TemplateCard.swift
//  ResumeAIApp
//
//  Created by mac on 3/23/26.
//

import SwiftUI

struct TemplateCard: View {
    let template: ResumeTemplate
    
    var body: some View {
        VStack {
            // Placeholder for your template image
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                Image(template.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                
                // If image is missing, show a placeholder icon
                if template.image.isEmpty {
                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 40) // Gives it the "card" feel in the TabView
        }
    }
}

#Preview {
    TemplateCard(template: ResumeTemplate(
            id: "preview_id",
            name: "Modern Minimalist",
            image: "" // Leaving this empty will trigger your doc.text.fill icon
        ))
}
