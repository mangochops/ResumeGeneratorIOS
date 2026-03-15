import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var viewModel: ResumeViewModel?
    
    @State private var showEditor = false
    @State private var showJobAd = false
    @State private var showLinkedInImport = false
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack(spacing: 25) {
                    
                    header
                    
                    actionCards
                    
                    recentResumes
                    
                }
                .padding()
            }
            .navigationTitle("ResumeAI")
            
            .sheet(isPresented: $showEditor) {
                if let vm = viewModel {
                    ResumeEditorView(viewModel: vm)
                }
            }
            
            .sheet(isPresented: $showJobAd) {
                UploadJobAdView()
            }
            
            .sheet(isPresented: $showLinkedInImport) {
                LinkedInImportView()
            }
            
            .onAppear {
                if viewModel == nil {
                    viewModel = ResumeViewModel(modelContext: modelContext)
                }
            }
        }
    }
}

extension HomeView {
    
    private var header: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            Text("Get More Interviews")
                .font(.largeTitle.bold())
            
            Text("Tailor your resume to every job using AI")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension HomeView {
    
    private var actionCards: some View {
        
        VStack(spacing: 16) {
            
            ActionCard(
                title: "Edit Primary CV",
                subtitle: "Store your master resume",
                icon: "person.crop.rectangle",
                color: .blue
            ) {
                showEditor.toggle()
            }
            
            ActionCard(
                title: "Tailor CV for Job",
                subtitle: "Paste job link or upload PDF",
                icon: "sparkles",
                color: .purple
            ) {
                showJobAd.toggle()
            }
            
            ActionCard(
                title: "Import from LinkedIn",
                subtitle: "Upload LinkedIn profile PDF",
                icon: "link",
                color: .green
            ) {
                showLinkedInImport.toggle()
            }
        }
    }
}

extension HomeView {
    
    private var recentResumes: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Generated Resumes")
                .font(.title2.bold())
            
            if let vm = viewModel {
                
                if vm.resumes.isEmpty {
                    
                    VStack(spacing: 10) {
                        
                        Image(systemName: "doc.text")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        
                        Text("No resumes yet")
                            .font(.headline)
                        
                        Text("Generate your first tailored resume.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 20)
                    
                } else {
                    
                    ForEach(vm.resumes) { resume in
                        ResumeCard(resume: resume)
                    }
                }
                
            } else {
                ProgressView("Loading...")
            }
        }
    }
}

#Preview {
    
    let container = try! ModelContainer(
        for: Resume.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    
    return HomeView()
        .modelContainer(container)
}
