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
        
        Button(action: action) {
            
            HStack(spacing: 16) {
                
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(color)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    
                    Text(title)
                        .font(.headline)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(18)
        }
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
