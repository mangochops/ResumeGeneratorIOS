//
//  HeaderTitle.swift
//  ResumeAIApp
//
//  Created by mac on 5/21/26.
//

import SwiftUI

struct HeaderTitleView: View {
    let name: String
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Your")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(name)
                    .font(.system(size: 28, weight: .black))
                    .linearGradientForeground(colors: [.blue, .purple])
            }
            
            Spacer()
            
            
        }
        .padding(.horizontal, 20)
    }
}
