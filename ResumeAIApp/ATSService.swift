//
//  ATSService.swift
//  ResumeAIApp
//
//  Created by mac on 3/13/26.
//

import Foundation

class ATSService {
    
    func extractKeywords(from jobDescription: String) -> [String] {
        
        let words = jobDescription
            .lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
        
        let keywords = words.filter { $0.count > 4 }
        
        return Array(Set(keywords))
    }
    
    func scoreResume(resume: String, jobDescription: String) -> Int {
        
        let keywords = extractKeywords(from: jobDescription)
        let resumeLower = resume.lowercased()
        
        var matches = 0
        
        for keyword in keywords {
            if resumeLower.contains(keyword) {
                matches += 1
            }
        }
        
        guard keywords.count > 0 else { return 0 }
        
        let score = Double(matches) / Double(keywords.count)
        
        return Int(score * 100)
    }
}
