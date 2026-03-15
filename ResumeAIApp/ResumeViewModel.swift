// ResumeViewModel.swift
import Foundation
import SwiftUI
import SwiftData

@Observable
class ResumeViewModel {
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func addResume(
        name: String,
        title: String,
        content: String,
        atsScore: Int? = nil,
        atsSuggestions: String? = nil
    ) {
        let resume = Resume(
            name: name,
            title: title,
            content: content,
            atsScore: atsScore,
            atsSuggestions: atsSuggestions
        )
        
        modelContext.insert(resume)
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save resume: \(error.localizedDescription)")
        }
    }
    
    // Optional: convenience method if you already have a Resume instance
    func addResume(_ resume: Resume) {
        modelContext.insert(resume)
        try? modelContext.save()
    }
    
    func deleteResume(_ resume: Resume) {
        modelContext.delete(resume)
        try? modelContext.save()
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
