//
//  Resume.swift
//  ResumeAIApp
//
//  Created by mac on 3/11/26.
//

import Foundation
import SwiftData

@Model
final class Resume: Codable, Identifiable {
    
    @Attribute(.unique) var id: UUID
    var userID: UUID?
    var name: String
    var title: String
    var content: Data
    var atsScore: Int?
    var atsSuggestions: String?
    var createdAt: Date
    var templateID: String = "1"
    
    enum CodingKeys: CodingKey {
            case id, userID,name, title, content, atsScore, atsSuggestions, createdAt, templateID
        }
    init(
        id: UUID = UUID(),
        userID: UUID? = nil,
        name: String,
        title: String,
        content: Data,
        atsScore: Int? = nil,
        atsSuggestions: String? = nil,
        templateID: String = "1",
        createdAt: Date = Date()
    ) {
        self.id = id
        self.userID = userID
        self.name = name
        self.title = title
        self.content = content
        self.atsScore = atsScore
        self.atsSuggestions = atsSuggestions
        self.createdAt = createdAt
        self.templateID = templateID
    }
    required init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: CodingKeys.self)

            id = try container.decode(UUID.self, forKey: .id)
            userID = try container.decodeIfPresent(UUID.self, forKey: .userID)
            name = try container.decode(String.self, forKey: .name)
            title = try container.decode(String.self, forKey: .title)
            content = try container.decode(Data.self, forKey: .content)
            atsScore = try container.decodeIfPresent(Int.self, forKey: .atsScore)
            atsSuggestions = try container.decodeIfPresent(String.self, forKey: .atsSuggestions)
            createdAt = try container.decode(Date.self, forKey: .createdAt)
            templateID = try container.decode(String.self, forKey: .templateID)
        }

        func encode(to encoder: Encoder) throws {

            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(id, forKey: .id)
            try container.encodeIfPresent(userID, forKey: .userID)
            try container.encode(name, forKey: .name)
            try container.encode(title, forKey: .title)
            try container.encode(templateID, forKey: .templateID)
            try container.encode(content, forKey: .content)
            try container.encodeIfPresent(atsScore, forKey: .atsScore)
            try container.encodeIfPresent(atsSuggestions, forKey: .atsSuggestions)
            try container.encode(createdAt, forKey: .createdAt)
        }
}
