//
//  ResumeViewModel.swift
//  ResumeAIApp
//
//  Created by mac on 3/11/26.
//

import Foundation
import SwiftUI

class ResumeViewModel: ObservableObject {
    
    @Published var resumes: [Resume] = []
    
    func addResume(resume: Resume) {
        resumes.append(resume)
    }
}
