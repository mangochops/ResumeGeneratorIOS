//
//  Resume.swift
//  ResumeAIApp
//
//  Created by mac on 3/11/26.
//

import Foundation

struct Resume: Identifiable, Codable {
    
    var id = UUID()
    var name: String
    var title: String
    var content: String
}
