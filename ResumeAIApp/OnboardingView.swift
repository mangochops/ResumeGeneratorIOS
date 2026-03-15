//
//  OnboardingView.swift
//  ResumeAIApp
//
//  Created by mac on 3/13/26.
//

import SwiftUI

struct OnboardingView: View {
    
    @State private var currentPage = 0
    
    let pages: [OnboardingItem] = [
        OnboardingItem(
            image: "doc.text.magnifyingglass",
            title: "Analyze Your Resume",
            description: "Upload your resume and let AI analyze ATS compatibility instantly."
        ),
        
        OnboardingItem(
            image: "brain.head.profile",
            title: "AI Improvements",
            description: "Get smart suggestions and missing keywords for your dream job."
        ),
        
        OnboardingItem(
            image: "checkmark.seal.fill",
            title: "Land More Interviews",
            description: "Create optimized resumes that pass recruiter screening systems."
        )
    ]
    
    var body: some View {
        
        VStack {
            
            TabView(selection: $currentPage) {
                
                ForEach(0..<pages.count, id: \.self) { index in
                    
                    VStack(spacing: 30) {
                        
                        Image(systemName: pages[index].image)
                            .font(.system(size: 90))
                            .foregroundStyle(.tint)
                        
                        Text(pages[index].title)
                            .font(.title.bold())
                        
                        Text(pages[index].description)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page)
            
            Spacer()
            
            Button(action: {
                finishOnboarding()
            }) {
                Text(currentPage == pages.count - 1 ? "Get Started" : "Skip")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.tint)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
    }
    
    func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
    }
}

#Preview {
    OnboardingView()
}
