//
//  ATSScoreView.swift
//  ResumeAIApp
//
//  Created by mac on 3/13/26.
//

import SwiftUI

struct ATSScoreView: View {
    
    var resume: String
    var jobDescription: String
    
    let atsService = ATSService()
    
    var body: some View {
        
        let score = atsService.scoreResume(resume: resume, jobDescription: jobDescription)
        
        VStack(spacing: 30) {
            
            Text("ATS Match Score")
                .font(.title)
                .fontWeight(.bold)
            
            ZStack {
                
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                
                Circle()
                    .trim(from: 0, to: CGFloat(score) / 100)
                    .stroke(Color.green, lineWidth: 20)
                    .rotationEffect(.degrees(-90))
                
                Text("\(score)%")
                    .font(.largeTitle)
                    .bold()
            }
            .frame(width: 180, height: 180)
            
            if score < 50 {
                Text("Your resume needs more keywords from the job description.")
                    .foregroundColor(.red)
            } else if score < 75 {
                Text("Good match. Improve a few keywords.")
            } else {
                Text("Excellent ATS match.")
                    .foregroundColor(.green)
            }
        }
        .padding()
    }
}

#Preview {
    ATSScoreView(
        resume: """
        iOS Developer with experience in SwiftUI, REST APIs, Firebase,
        and mobile application development.
        """,
        jobDescription: """
        We are looking for an iOS developer with experience in Swift,
        SwiftUI, API integration, and mobile development.
        """
    )
}
