import SwiftUI
import UniformTypeIdentifiers

struct LinkedInImportView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showFileImporter = false
    @State private var extractedText = ""
    @State private var isProcessing = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color to match your app's theme
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Instruction Card
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.1))
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "link.badge.plus")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundStyle(Color.green.gradient)
                        }
                        
                        VStack(spacing: 8) {
                            Text("LinkedIn to Resume")
                                .font(.title2.bold())
                            
                            Text("Export your LinkedIn profile as a PDF and we'll handle the rest.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        
                        // Action Button - Fixed with HStack
                        Button {
                            showFileImporter = true
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.up.doc.fill")
                                Text("Upload LinkedIn PDF")
                            }
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                        .controlSize(.large)
                    }
                    .padding(30)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 32))
                    .overlay(RoundedRectangle(cornerRadius: 32).stroke(Color.primary.opacity(0.1), lineWidth: 1))
                    .padding(.horizontal)
                    
                    // Progress or Preview Section
                    if isProcessing {
                        VStack(spacing: 12) {
                            ProgressView()
                            Text("Scanning Profile...")
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)
                        }
                    } else if !extractedText.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            // Fixed the Label error here by using an HStack
                            HStack(spacing: 6) {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Extracted Content")
                            }
                            .font(.caption.bold())
                            .foregroundStyle(.green)
                            
                            ScrollView {
                                Text(extractedText)
                                    .font(.system(.footnote, design: .monospaced))
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(height: 150)
                            .background(Color(UIColor.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .padding(.horizontal)
                        .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .opacity))
                    }
                    
                    // Helpful Hint
                    HStack(spacing: 12) {
                        Image(systemName: "info.circle")
                            .foregroundStyle(.blue)
                        Text("Go to your LinkedIn Profile > More > Save to PDF")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    
                    Spacer()
                }
                .padding(.top, 40)
            }
            .navigationTitle("Import")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                if !extractedText.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Continue") {
                            // Add your navigation logic here to pass extractedText to your editor
                        }
                        .bold()
                    }
                }
            }
            .fileImporter(
                isPresented: $showFileImporter,
                allowedContentTypes: [.pdf],
                allowsMultipleSelection: false
            ) { result in
                handleImport(result: result)
            }
        }
    }
    
    // 1. Update the function signature to [URL]
    private func handleImport(result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            // 2. Safely get the first URL from the array
            guard let url = urls.first else { return }
            
            // 3. Start security-scoped access
            guard url.startAccessingSecurityScopedResource() else { return }
            
            isProcessing = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                // Ensure you use the single 'url' here
                if let text = PDFParser.extractText(from: url) {
                    withAnimation {
                        extractedText = text
                    }
                }
                isProcessing = false
                // 4. Stop access when done
                url.stopAccessingSecurityScopedResource()
            }
        case .failure(let error):
            print("Import failed: \(error.localizedDescription)")
        }
    }
}

#Preview {
    LinkedInImportView()
}
