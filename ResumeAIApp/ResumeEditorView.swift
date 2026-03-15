import SwiftUI
import PDFKit
import UniformTypeIdentifiers
import SwiftData

struct ResumeEditorView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
//    @ObservedObject var viewModel: ResumeViewModel
    @Bindable var viewModel: ResumeViewModel
    
    @State private var name = ""
    @State private var title = ""
    @State private var content = ""                 // parsed CV text
    @State private var atsScore: Int? = nil
    @State private var atsSuggestions = ""
    
    @State private var isImporting = false
    @State private var isAnalyzing = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Upload area
                    uploadSection
                    
                    // Parsed content preview + editor
                    if !content.isEmpty {
                        contentSection
                    }
                    
                    // ATS results
                    if let score = atsScore {
                        atsResultSection(score: score)
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
            .navigationTitle("Create Resume")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
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
            .overlay {
                if isAnalyzing {
                    ProgressView("Analyzing with AI...")
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .alert("Error", isPresented: Binding(
                get: { errorMessage != nil },
                set: { _ in errorMessage = nil }
            )) {
                Button("OK") { }
            } message: {
                Text(errorMessage ?? "Unknown error")
            }
        }
    }
    
    private var uploadSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "doc.text.fill")
                .font(.system(size: 60))
                .foregroundStyle(.tint)
            
            Text("Upload Your Resume (PDF)")
                .font(.title3.bold())
            
            Button("Choose PDF File") {
                isImporting = true
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Parsed Resume Content")
                .font(.headline)
            
            TextEditor(text: $content)
                .font(.body)
                .frame(minHeight: 220)
                .padding(8)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3)))
            
            if !isAnalyzing {
                Button("Analyze ATS Compatibility") {
                    Task { await analyzeATS() }
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
    
    private func atsResultSection(score: Int) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("ATS Score")
                    .font(.title2.bold())
                Spacer()
                Text("\(score)/100")
                    .font(.title.bold())
                    .foregroundColor(scoreColor(for: score))
            }
            
            if !atsSuggestions.isEmpty {
                Text("Suggestions to Improve ATS Score")
                    .font(.headline)
                
                Text(atsSuggestions)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 2)
    }
    
    private var saveButton: some View {
        Button("Save") {
            let resume = Resume(
                name: name.isEmpty ? "Untitled" : name,
                title: title,
                content: content,
                atsScore: atsScore,
                atsSuggestions: atsSuggestions
            )
            viewModel.addResume(resume)
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
    
    private func scoreColor(for score: Int) -> Color {
        switch score {
        case 80...100: return .green
        case 60..<80:  return .orange
        default:       return .red
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: Resume.self)
    let context = container.mainContext
    
    return ResumeEditorView(
        viewModel: ResumeViewModel(modelContext: context)
    )
    .modelContainer(container)
}
