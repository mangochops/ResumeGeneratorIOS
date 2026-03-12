import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel = ResumeViewModel()
    
    @State private var showEditor = false
    @State private var showJobAd = false
    
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
                ResumeEditorView(viewModel: viewModel)
            }
            .sheet(isPresented: $showJobAd) {
                UploadJobAdView()
            }
        }
    }
}

extension HomeView {
    
    var header: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            Text("Get More Interviews")
                .font(.largeTitle.bold())
            
            Text("Tailor your resume to every job using AI")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    
    var actionCards: some View {
        
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
        }
    }
    
    
    var recentResumes: some View {
        
        VStack(alignment: .leading) {
            
            Text("Generated Resumes")
                .font(.title2.bold())
            
            ForEach(viewModel.resumes) { resume in
                ResumeCard(resume: resume)
            }
        }
    }
}

#Preview {
    HomeView()
}
