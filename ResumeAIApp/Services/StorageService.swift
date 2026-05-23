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
        let dtos = resumes.map { Resume.ResumeDTO(from: $0) }
        
        if let data = try? JSONEncoder().encode(dtos) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func load() -> [Resume] {
        
        guard let data = UserDefaults.standard.data(forKey: key),
              let decodedDTOs = try? JSONDecoder().decode([Resume.ResumeDTO].self, from: data)
        else {
            return []
        }
        
        return decodedDTOs.map { $0.toModel() }
    }
}
