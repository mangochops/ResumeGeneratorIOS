//
//  ActionCard.swift
//  ResumeAIApp
//
//  Created by mac on 3/12/26.
//

import SwiftUI

struct ActionCard: View {
    
    var title: String
    var subtitle: String
    var icon: String
    var color: Color
    var action: () -> Void
    
    var body: some View {
        
        Button(action: {
            // Trigger haptic feedback
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            action()
        }) {
            
            HStack(spacing: 16) {
                
                // Fixed-size Icon Container
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 48, height: 48) // Ensures circles are identical
                        .background(color.gradient)   // Use gradient for extra polish
                        .clipShape(Circle())
                
//                Image(systemName: icon)
//                    .font(.title)
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(color)
//                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.secondary.opacity(0.5))
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.primary.opacity(0.05), lineWidth: 1) // Subtle border
                ))
            .cornerRadius(18)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
#Preview {
    ZStack {
        Color.gray.opacity(0.1).ignoresSafeArea() // Background to show off thin material
        VStack {
            ActionCard(
                title: "Edit Primary CV",
                subtitle: "Store your master resume",
                icon: "person.crop.rectangle",
                color: .blue
            ) {
                print("Action tapped")
            }
        }
        .padding()
    }
}
//#Preview {
//    ActionCard(
//            title: "Edit Primary CV",
//            subtitle: "Store your master resume",
//            icon: "person.crop.rectangle",
//            color: .blue
//        ) {
//            print("Action tapped")
//        }
//}
