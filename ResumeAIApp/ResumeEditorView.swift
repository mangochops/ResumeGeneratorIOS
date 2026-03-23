import SwiftUI
import PDFKit
import UniformTypeIdentifiers
import SwiftData

struct ResumeEditorView: View {
    @Environment(\.dismiss) var dismiss
    // Change: Use var for Observable viewModels unless binding to properties
    var viewModel: ResumeViewModel
    
    @State private var name = ""
    @State private var title = ""
    @State private var content: String = ""
    @State private var atsScore: Int? = nil
    @State private var atsSuggestions = ""
    
    @State private var isImporting = false
    @State private var isAnalyzing = false
    @State private var errorMessage: String?
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if content.isEmpty {
                        initialUploadState
                            .padding(.top, 40)
                    } else {
                        fileHeader
                        
                        Picker("View", selection: $selectedTab) {
                            Text("Resume").tag(0)
                            Text("AI Insights").tag(1)
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        
                        if selectedTab == 0 {
                            contentEditor
                        } else {
                            aiInsightsView
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(content.isEmpty ? "Create Resume" : "Edit Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    saveButton
                }
            }
            .fileImporter(
                isPresented: $isImporting,
                allowedContentTypes: [.pdf],
                allowsMultipleSelection: false
            ) { result in
                handleImport(result: result)
            }
            .onAppear {
                if let existingResume = viewModel.selectedResume {
                    self.name = existingResume.name
                    self.title = existingResume.title
                    self.atsScore = existingResume.atsScore
                    self.atsSuggestions = existingResume.atsSuggestions ?? ""
                    
                    if let decodedString = String(data: existingResume.content, encoding: .utf8) {
                        self.content = decodedString
                    }
                }
            }
            .onDisappear {
                // If we are editing an existing resume, sync it when leaving
                if let existingResume = viewModel.selectedResume {
                    let contentData = content.data(using: .utf8) ?? Data()
                    viewModel.updateResume(existingResume, newContent: contentData)
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var initialUploadState: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "doc.badge.plus")
                    .font(.system(size: 50))
                    .foregroundStyle(Color.blue.gradient)
            }
            
            VStack(spacing: 8) {
                Text("Upload Your Resume")
                    .font(.title2.bold())
                Text("Support for PDF files only")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Button {
                isImporting = true
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Choose PDF File")
                }
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.primary.opacity(0.1), lineWidth: 1))
    }
    
    private var fileHeader: some View {
        HStack {
            Image(systemName: "doc.text.fill")
                .font(.title2)
                .foregroundStyle(Color.blue)
            
            VStack(alignment: .leading) {
                TextField("Resume Name", text: $name)
                    .font(.headline)
                Text("Imported from PDF")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button("Replace") {
                isImporting = true
            }
            .font(.caption.bold())
            .buttonStyle(.bordered)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var contentEditor: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Verify Parsed Content")
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)
            
            TextEditor(text: $content)
                .frame(minHeight: 400)
                .padding(12)
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.primary.opacity(0.1), lineWidth: 1))
        }
    }
    
    private var aiInsightsView: some View {
        VStack(spacing: 20) {
            if let score = atsScore {
                atsResultSection(score: score)
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "sparkles")
                        .font(.largeTitle)
                        .foregroundStyle(Color.purple)
                    Text("No AI Analysis yet")
                        .font(.headline)
                    Button("Analyze ATS Compatibility") {
                        Task { await analyzeATS() }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.purple)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            }
        }
    }

    private func atsResultSection(score: Int) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("ATS Score").font(.title2.bold())
                Spacer()
                Text("\(score)/100")
                    .font(.title.bold())
                    .foregroundColor(score >= 80 ? .green : (score >= 60 ? .orange : .red))
            }
            if !atsSuggestions.isEmpty {
                Text("Suggestions").font(.headline)
                Text(atsSuggestions).font(.subheadline).foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 5)
    }

    private var saveButton: some View {
        Button("Save") {
            let contentData = content.data(using: .utf8) ?? Data()
            
            // If we are editing, update the existing one
            if let existing = viewModel.selectedResume {
                existing.name = name
                existing.title = title
                viewModel.updateResume(existing, newContent: contentData)
            } else {
                // Otherwise, create new
                viewModel.addResume(
                    name: name,
                    title: title,
                    content: contentData,
                    atsScore: atsScore,
                    atsSuggestions: atsSuggestions
                )
            }
            dismiss()
        }
        .disabled(content.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func handleImport(result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }
            Task {
                do {
                    let parsed = try await parsePDF(from: url)
                    content = parsed
                    name = url.deletingPathExtension().lastPathComponent
                } catch {
                    errorMessage = "Failed to parse PDF: \(error.localizedDescription)"
                }
            }
        case .failure(let error):
            errorMessage = "Import failed: \(error.localizedDescription)"
        }
    }
    
    private func parsePDF(from url: URL) async throws -> String {
        guard url.startAccessingSecurityScopedResource() else {
            throw NSError(domain: "FileAccess", code: 1)
        }
        defer { url.stopAccessingSecurityScopedResource() }
        
        guard let doc = PDFDocument(url: url) else {
            throw NSError(domain: "PDFKit", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid PDF"])
        }
        
        let fullText = NSMutableAttributedString()
        for i in 0..<doc.pageCount {
            guard let page = doc.page(at: i),
                  let pageText = page.attributedString else { continue }
            fullText.append(pageText)
            fullText.append(NSAttributedString(string: "\n\n"))
        }
        
        return fullText.string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func analyzeATS() async {
        isAnalyzing = true
        defer { isAnalyzing = false }
        
        do {
            let (score, suggestions) = try await AIService().analyzeForATS(cvText: content)
            atsScore = score
            atsSuggestions = suggestions
        } catch {
            errorMessage = "AI analysis failed: \(error.localizedDescription)"
        }
    }
}
