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
                
                VStack(spacing: 30) {
                    
                    header
                    
                    actionCards
                    
                    recentResumes
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .padding()
            }
//            .navigationTitle("CV Pilot")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(UIColor.systemGroupedBackground).opacity(0.5))
            
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
        
        VStack(alignment: .leading, spacing: 4) {
            
            Text("Get More Interviews")
                .font(.system(.largeTitle, design: .rounded).bold())
            
            Text("Tailor your resume to every job using AI")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 10)
    }
}

extension HomeView {
    
    private var actionCards: some View {
        
        VStack(spacing: 14) {
            
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
        
        VStack(alignment:.leading ,spacing: 16) {
            
            Text("Generated Resumes")
                .font(.title3.bold())
                .padding(.top, 5)
            
            if let vm = viewModel {
                if vm.resumes.isEmpty {
                    emptyState
                } else {
                    // Using LazyVStack for better performance with lists
                    LazyVStack(spacing: 12) {
                        ForEach(vm.resumes) { resume in
                            ResumeCard(resume: resume)
                        }
                    }
                }
            } else {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .padding()
             
        }
    }
}
    private var emptyState: some View {
            VStack(spacing: 12) {
                Image(systemName: "doc.text.magnifyingglass")
                    .font(.system(size: 40))
                    .foregroundStyle(.quaternary)
                
                Text("No resumes yet")
                    .font(.headline)
                
                Text("Generate your first tailored resume above.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundStyle(.quaternary)
            )
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
