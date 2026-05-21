//
//  Models.swift
//  ResumeAIApp
//
//  Created by mac on 3/21/26.
//

import Foundation
import Supabase
import SwiftData

// Matches public.profiles
struct Profile: Codable, Identifiable {
    let id: UUID
    var fullName: String?
    var email: String?
    var avatarUrl: String?
    var isPro: Bool?
    var credits: Int?
    var updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, email, credits
        case fullName = "full_name"
        case avatarUrl = "avatar_url"
        case isPro = "is_pro"
        case updatedAt = "updated_at"
    }
}


@Model
final class Resume: Codable {
    @Attribute(.unique) var id: UUID
    var userId: UUID
    var title: String
    var name: String
    var content: Data
    var templateId: String?
    var fileUrl: String?
    var createdAt: Date
    var atsScore: Int?         // Added to match ViewModel
    var atsSuggestions: String? // Added to match ViewModel

    enum CodingKeys: String, CodingKey {
            case id, title, name, content
            case userId = "user_id"
            case templateId = "template_id"
            case fileUrl = "file_url"
            case createdAt = "created_at"
            case atsScore = "ats_score"
            case atsSuggestions = "ats_suggestions"
        }
    
    init(id: UUID = UUID(), userId: UUID, title: String, name: String, content: Data, templateId: String? = nil, fileUrl: String? = nil,atsScore: Int? = nil, atsSuggestions: String? = nil, createdAt: Date = Date()) {
        self.id = id
        self.userId = userId
        self.title = title
        self.name = name
        self.content = content
        self.templateId = templateId
        self.fileUrl = fileUrl
        self.createdAt = createdAt
        self.atsScore = atsScore
        self.atsSuggestions = atsSuggestions
    }
    
    // MARK: - Decodable implementation
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(UUID.self, forKey: .id)
            self.userId = try container.decode(UUID.self, forKey: .userId)
            self.title = try container.decode(String.self, forKey: .title)
            self.name = try container.decode(String.self, forKey: .name)
            self.content = try container.decode(Data.self, forKey: .content)
            self.templateId = try container.decodeIfPresent(String.self, forKey: .templateId)
            self.fileUrl = try container.decodeIfPresent(String.self, forKey: .fileUrl)
            self.createdAt = try container.decode(Date.self, forKey: .createdAt)
            self.atsScore = try container.decodeIfPresent(Int.self, forKey: .atsScore)
            self.atsSuggestions = try container.decodeIfPresent(String.self, forKey: .atsSuggestions)
        }

        // MARK: - Encodable implementation
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(userId, forKey: .userId)
            try container.encode(title, forKey: .title)
            try container.encode(name, forKey: .name)
            try container.encode(content, forKey: .content)
            try container.encode(templateId, forKey: .templateId)
            try container.encode(fileUrl, forKey: .fileUrl)
            try container.encode(createdAt, forKey: .createdAt)
            try container.encode(atsScore, forKey: .atsScore)
            try container.encode(atsSuggestions, forKey: .atsSuggestions)
        }
}

@Model
final class CoverLetter {
    var id: String
    var userId: String
    var title: String
    var companyName: String
    var jobTitle: String
    var content: String
    var createdAt: Date
    
    init(id: String = UUID().uuidString, userId: String, title: String, companyName: String, jobTitle: String, content: String, createdAt: Date = Date()) {
        self.id = id
        self.userId = userId
        self.title = title
        self.companyName = companyName
        self.jobTitle = jobTitle
        self.content = content
        self.createdAt = createdAt
    }
}

struct AnyDecodable: Decodable {
    let value: Any

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let str = try? container.decode(String.self) { value = str }
        else if let int = try? container.decode(Int.self) { value = int }
        else if let bool = try? container.decode(Bool.self) { value = bool }
        else if let dict = try? container.decode([String: AnyDecodable].self) { value = dict.mapValues { $0.value } }
        else if let arr = try? container.decode([AnyDecodable].self) { value = arr.map { $0.value } }
        else { throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported JSONB data layout format") }
    }
}

// Matches public.applications
struct Application: Codable, Identifiable {
    let id: UUID
    let userId: UUID
    var resumeId: UUID?
    var jobTitle: String?
    var companyName: String?
    var jobDescription: String?
    var atsScore: Int?
    var tailoredResumeUrl: String?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id, jobTitle = "job_title", companyName = "company_name"
        case userId = "user_id", resumeId = "resume_id"
        case jobDescription = "job_description", atsScore = "ats_score"
        case tailoredResumeUrl = "tailored_resume_url"
        case createdAt = "created_at"
    }
}

struct ResumeTemplate: Identifiable {
    let id: String
    let name: String
    let image: String // This should match an image name in your Assets.xcassets
}
