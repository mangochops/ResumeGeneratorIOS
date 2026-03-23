//
//  Models.swift
//  ResumeAIApp
//
//  Created by mac on 3/21/26.
//

import Foundation
import Supabase

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

// Matches public.resumes
struct UserResume: Codable, Identifiable {
    let id: UUID
    let userId: UUID
    var title: String
    var content: Data
    var templateId: String?
    var fileUrl: String?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id, title, content
        case userId = "user_id"
        case fileUrl = "file_url"
        case templateId = "template_id"
        case createdAt = "created_at"
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
