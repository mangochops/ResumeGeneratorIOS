//
//  ProfileViewModel.swift
//  ResumeAIApp
//
//  Created by mac on 3/22/26.
//

import Foundation
import SwiftUI

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var profile: Profile?
    @Published var isLoading = false
    
    func loadUserData() async {
        isLoading = true
        
        print("DEBUG: Current Auth UID: \(AuthService.shared.currentUser?.id.uuidString ?? "No User")")
        do {
            self.profile = try await AuthService.shared.getProfile()
        } catch {
            print("Error: \(error)")
        }
        isLoading = false
    }
}
