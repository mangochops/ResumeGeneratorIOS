//
//  Models.swift
//  ResumeAIApp
//

import Foundation
import SwiftData

// MARK: - Profile (matches public.profiles)
public final class Profile: Codable, Identifiable {
    public let id: UUID
    public var fullName: String?
    public var email: String?
    public var avatarUrl: String?
    public var isPro: Bool?
    public var credits: Int?
    public var updatedAt: Date?
    
    public init(id: UUID, fullName: String? = nil, email: String? = nil, avatarUrl: String? = nil, isPro: Bool? = nil, credits: Int? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.avatarUrl = avatarUrl
        self.isPro = isPro
        self.credits = credits
        self.updatedAt = updatedAt
    }
    
    enum CodingKeys: String, CodingKey {
        case id, email, credits
        case fullName = "full_name"
        case avatarUrl = "avatar_url"
        case isPro = "is_pro"
        case updatedAt = "updated_at"
    }
}

// MARK: - Resume (matches public.resumes)
@Model
public final class Resume: Identifiable {
    @Attribute(.unique) public var id: UUID
    public var userId: UUID
    public var title: String
    public var name: String
    public var content: String?
    public var fileUrl: String?
    public var createdAt: Date
    
    public init(id: UUID = UUID(), userId: UUID, title: String, name: String, content: String? = nil, fileUrl: String? = nil, createdAt: Date = Date()) {
        self.id = id
        self.userId = userId
        self.title = title
        self.name = name
        self.content = content
        self.fileUrl = fileUrl
        self.createdAt = createdAt
    }
    
    struct ResumeDTO: Codable {
        let id: UUID
        let userId: String
        let title: String
        let name: String
        let content: String?
        let fileUrl: String?
        let createdAt: Date
        
        enum CodingKeys: String, CodingKey {
            case id
            case userId = "user_id"
            case title
            case name
            case content
            case fileUrl = "file_url"
            case createdAt = "created_at"
        }
        
        func toModel() -> Resume {
            Resume(id: id, userId: UUID(uuidString: userId) ?? UUID(), title: title, name: name, content: content, fileUrl: fileUrl, createdAt: createdAt)
        }
        
        init(from model: Resume) {
            self.id = model.id
            self.userId = model.userId.uuidString
            self.title = model.title
            self.name = model.name
            self.content = model.content
            self.fileUrl = model.fileUrl
            self.createdAt = model.createdAt
        }
    }
}

// MARK: - ResumeContent
public struct ResumeContent: Codable {
    public var text: String?
    
    public init(text: String? = nil) {
        self.text = text
    }
}

// MARK: - CoverLetter (FIXED: Moved out of Resume to Root Level)
@Model
public final class CoverLetter: Identifiable {
    @Attribute(.unique) public var id: UUID
    public var userId: UUID
    public var companyName: String
    public var jobTitle: String
    public var content: String
    public var createdAt: Date
    
    public init(id: UUID = UUID(), userId: UUID, companyName: String, jobTitle: String, content: String, createdAt: Date = Date()) {
        self.id = id
        self.userId = userId
        self.companyName = companyName
        self.jobTitle = jobTitle
        self.content = content
        self.createdAt = createdAt
    }
}

// MARK: - Application (FIXED: Moved out of Resume to Root Level)
@Model
public final class Application: Identifiable {
    @Attribute(.unique) public var id: UUID
    public var userId: UUID
    public var resumeId: UUID?
    public var jobTitle: String?
    public var companyName: String?
    public var jobDescription: String?
    public var atsScore: Int?
    public var tailoredResumeUrl: String?
    public var createdAt: Date
    
    public init(id: UUID = UUID(), userId: UUID, resumeId: UUID? = nil, jobTitle: String? = nil, companyName: String? = nil, jobDescription: String? = nil, atsScore: Int? = nil, tailoredResumeUrl: String? = nil, createdAt: Date = Date()) {
        self.id = id
        self.userId = userId
        self.resumeId = resumeId
        self.jobTitle = jobTitle
        self.companyName = companyName
        self.jobDescription = jobDescription
        self.atsScore = atsScore
        self.tailoredResumeUrl = tailoredResumeUrl
        self.createdAt = createdAt
    }
}
