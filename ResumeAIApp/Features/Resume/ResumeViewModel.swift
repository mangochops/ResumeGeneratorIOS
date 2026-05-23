import Foundation
import SwiftUI
import SwiftData

@Observable
class ResumeViewModel {
    var selectedResume: Resume?
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func addResume(title: String, name: String, contentText: String) {
        guard let currentUserID = SupabaseManager.shared.client.auth.currentSession?.user.id else {
            print("No user logged in")
            return
        }
        
        
        
        let resume = Resume(
            id: UUID(),
            userId: currentUserID,
            title: title,
            name: name,
            content: contentText,
            fileUrl: nil,
            createdAt: Date()
        )
        
        insertAndSync(resume)
    }
    
    func addResume(_ resume: Resume) {
        insertAndSync(resume)
    }
    
    func updateResume(_ resume: Resume, newContentText: String) {
        resume.content = newContentText
        performCloudSync(resume)
    }
    
    func deleteResume(_ resume: Resume) {
        modelContext.delete(resume)
        try? modelContext.save()
    }
    
    func deleteCoverLetter(_ letter: CoverLetter) {
        modelContext.delete(letter)
        try? modelContext.save()
    }
    
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
