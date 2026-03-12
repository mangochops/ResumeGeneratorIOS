//
//  TailoredResumeView.swift
//  ResumeAIApp
//
//  Created by mac on 3/12/26.
//

import SwiftUI

struct TailoredResumeView: View {
    
    var tailoredCV: String
    
    var body: some View {
        
        ScrollView {
            
            Text(tailoredCV)
                .padding()
        }
        .navigationTitle("Tailored Resume")
    }
}

#Preview {
    TailoredResumeView(
        tailoredCV: """
        John Doe
        Software Engineer
        
        Summary
        Results-driven software engineer with experience building scalable applications using modern technologies.
        
        Experience
        • Developed full-stack web applications using React and Node.js
        • Improved system performance by 35%
        • Collaborated with cross-functional teams
        
        Skills
        Swift, JavaScript, React, Node.js, SQL, Git
        """
    )
}
