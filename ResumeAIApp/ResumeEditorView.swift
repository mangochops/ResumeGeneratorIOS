import SwiftUI

struct ResumeEditorView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: ResumeViewModel
    
    @State private var name = ""
    @State private var title = ""
    @State private var content = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Personal Info") {
                    TextField("Full Name", text: $name)
                    TextField("Job Title", text: $title)
                }
                
                Section("Professional Summary") {
                    TextEditor(text: $content)
                        .frame(height: 120)
                    
                    Button("Improve with AI") {
                        improveSummary()
                    }
                }
            }
            .navigationTitle("New Resume")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {     // or .navigationBarTrailing
                    Button("Save") {
                        let resume = Resume(
                            name: name,
                            title: title,
                            content: content
                        )
                        
                        viewModel.addResume(resume: resume)
                        dismiss()
                    }
                }
            }
        }
    }
    
    func improveSummary() {
        content = "Results-driven professional experienced in building scalable software, improving performance, and delivering impactful digital products."
    }
}

#Preview {
    ResumeEditorView(viewModel: ResumeViewModel())
}
