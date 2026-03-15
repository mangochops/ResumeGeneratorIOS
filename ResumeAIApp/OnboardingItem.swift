//
//  OnboardingItem.swift
//  ResumeAIApp
//
//  Created by mac on 3/13/26.
//

import Foundation

struct OnboardingItem: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let description: String
}
