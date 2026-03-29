// ResumeViewModel.swift
import Foundation
import SwiftUI
import SwiftData

@Observable
class ResumeViewModel {
    // Standard property tracking for @Observable
    var selectedResume: Resume?
    var selectedTemplateID: String = "1"
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    /// Creates a new resume from raw components and syncs to cloud
    func addResume(
            title: String,
            content: Data
        ) {
            // 1. Properly unwrap the optional UUID from Supabase
            guard let currentUserID = SupabaseManager.shared.client.auth.currentSession?.user.id else {
                print("No user logged in")
                return
            }
            
            // 2. Use the exact property names from your Models.swift
            let resume = Resume(
                userId: currentUserID, // Matches 'userId' in Models.swift
                title: title,          // Matches 'title' in Models.swift
                content: content,
                templateId: selectedTemplateID
            )
            
            insertAndSync(resume)
        }
    
    /// Adds an existing Resume instance to local storage and syncs to cloud
    func addResume(_ resume: Resume) {
        insertAndSync(resume)
    }
    
    /// Updates the content of an existing resume and triggers a cloud sync
    func updateResume(_ resume: Resume, newContent: Data) {
        // 1. Update local SwiftData properties
        resume.content = newContent
        
        // 2. Trigger Cloud Sync (Upsert)
        performCloudSync(resume)
    }
    
    func deleteResume(_ resume: Resume) {
        modelContext.delete(resume)
        try? modelContext.save()
        // Note: You may want to add logic here to delete from Supabase as well
    }
    
    // MARK: - Private Helpers
    
    private func insertAndSync(_ resume: Resume) {
        modelContext.insert(resume)
        
        do {
            try modelContext.save()
            performCloudSync(resume)
        } catch {
            print("Failed to save locally: \(error.localizedDescription)")
        }
    }
    
    private func performCloudSync(_ resume: Resume) {
        Task {
            do {
                try await SupabaseManager.shared.syncResume(resume)
                print("Sync successful for: \(resume.title)")
            } catch {
                print("Cloud sync failed: \(error.localizedDescription)")
            }
        }
    }
}

extension ResumeViewModel {
    /// Fetches all resumes sorted by creation date
    var resumes: [Resume] {
        let descriptor = FetchDescriptor<Resume>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed: \(error)")
            return []
        }
    }
}
