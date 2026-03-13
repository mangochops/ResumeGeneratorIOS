//
//  StorageService.swift
//  ResumeAIApp
//
//  Created by mac on 3/13/26.
//

import Foundation

class StorageService {
    
    static let shared = StorageService()
    
    private let key = "saved_resumes"
    
    func save(resumes: [Resume]) {
        
        if let data = try? JSONEncoder().encode(resumes) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func load() -> [Resume] {
        
        guard let data = UserDefaults.standard.data(forKey: key),
              let resumes = try? JSONDecoder().decode([Resume].self, from: data)
        else {
            return []
        }
        
        return resumes
    }
}
