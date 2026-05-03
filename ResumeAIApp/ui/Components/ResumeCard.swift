//
//  ResumeCard.swift
//  ResumeAIApp
//
//  Created by mac on 3/11/26.
//

import SwiftUI
import SwiftData

struct ResumeCard: View {
    let resume: Resume
    
    private var contentPreview: String {
        String(data: resume.content, encoding: .utf8) ?? "No content available"
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: resume.createdAt)
    }

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            // File Icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.15))
                    .frame(width: 50, height: 60)
                
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 26))
                    .foregroundStyle(Color.blue.gradient)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text(formattedDate)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    if resume.userId != nil {
                        Image(systemName: "icloud.fill")
                            .font(.caption2)
                            .foregroundColor(.blue)
                    }
                }

                Text(resume.name.isEmpty ? "Untitled Resume" : resume.name)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(resume.title.isEmpty ? "No Title" : resume.title)
                    .font(.caption)
                    .foregroundColor(.blue)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Capsule())
                
                Text(contentPreview)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.footnote)
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.regularMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.primary.opacity(0.05), lineWidth: 1)
        )
    }
}

// MARK: - Preview Logic
#Preview {
    // 1. Create an in-memory container for the preview
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Resume.self, configurations: config)
    
    // 2. Create a sample resume with dummy Data
    let sampleData = "Experience: Senior iOS Developer at Apple...".data(using: .utf8)!
    
    let sampleResume = Resume(
        id: UUID(),
        userId: UUID(), // Error 1 fix: Must be a UUID, not a String
        title: "Senior iOS Developer",
        name: "Software_Engineer_CV.pdf", // Error 2 fix: Name is a String
        content: sampleData // Error 2 fix: Content is the Data object
    )
    
    // 3. Return the card wrapped in a list for context
    return List {
        ResumeCard(resume: sampleResume)
    }
    .modelContainer(container)
}
