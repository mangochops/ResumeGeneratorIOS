import SwiftUI
import UniformTypeIdentifiers

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    
    @State private var showLinkedInImport = false
    @State private var showJobAdEntry = false
    @State private var showCoverLetterEntry = false
    @State private var showFilePicker = false
    
    var onSeeAllResumes: () -> Void
    
    // Luxury Premium Color Definitions matching Kotlin Theme
    private let backgroundColor = Color(red: 0.05, green: 0.05, blue: 0.06)
    private let surfaceColor = Color(red: 0.11, green: 0.11, blue: 0.13)
    private let onSurfaceVariant = Color.gray
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    
                    // 1. Context Greetings + Token Coin Counter Header Row View
                    HeaderSectionView(
                        name: viewModel.userProfile?.firstName ?? "User",
                        credits: viewModel.userCredits
                    )
                    
                    // 2. Action Grid Core Engines
                    VStack(spacing: 14) {
                        ActionCard(
                            title: "Upload your primary CV",
                            subtitle: "Store your master resume",
                            iconName: "doc.text.fill",
                            accentColor: Color(hex: 0x2196F3)
                        ) {
                            showFilePicker = true
                        }
                        
                        ActionCard(
                            title: "Tailor CV for Job",
                            subtitle: "Paste job description",
                            iconName: "wand.and.stars",
                            accentColor: Color(hex: 0x9C27B0)
                        ) {
                            if !viewModel.recentResumes.isEmpty && viewModel.selectedResumeFullText.isEmpty {
                                let firstResume = viewModel.recentResumes.first
                                if let data = firstResume?.content,
                                   let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                                   let text = json["text"] as? String {
                                    viewModel.selectedResumeFullText = text
                                }
                            }
                            showJobAdEntry = true
                        }
                        
                        ActionCard(
                            title: "Generate cover letter",
                            subtitle: "Generate a cover letter for an application",
                            iconName: "envelope.fill",
                            accentColor: Color(hex: 0x4CAF50)
                        ) {
                            showCoverLetterEntry = true
                        }
                    }
                    
                    // 3. Horizontal Swiper Timeline: Recent Resumes Section
                    VStack(alignment: .leading, spacing: 10) {
                        SectionHeaderView(title: "Recent Resumes") {
                            onSeeAllResumes()
                        }
                        
                        if viewModel.isLoading {
                            HorizontalScrollContainer {
                                ForEach(0..<3, id: \.self) { _ in
                                    CompactResumeSkeletonCard()
                                }
                            }
                        } else if viewModel.recentResumes.isEmpty {
                            Text("No generations yet. Try tailoring a CV!")
                                .font(.body)
                                .foregroundColor(onSurfaceVariant)
                                .padding(16)
                        } else {
                            HorizontalScrollContainer {
                                ForEach(viewModel.recentResumes) { resume in
                                    CompactResumeCard(resume: resume) {
                                        // FIXED: Directly deserialize the non-optional data block
                                        if let json = try? JSONSerialization.jsonObject(with: resume.content) as? [String: Any],
                                           let text = json["text"] as? String {
                                            viewModel.selectedResumeFullText = text
                                        }
                                        showJobAdEntry = true
                                    }
                                }
                            }
                        }
                    }
                    
                    // 4. Horizontal Swiper Timeline: Recent Cover Letters Section
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeaderView(title: "Recent Cover Letters") {
                            onSeeAllResumes()
                        }
                        
                        if viewModel.isLoading {
                            HorizontalScrollContainer {
                                ForEach(0..<3, id: \.self) { _ in
                                    CompactCoverLetterSkeletonCard()
                                }
                            }
                        } else if viewModel.recentCoverLetters.isEmpty {
                            Text("Your generated letters will appear here.")
                                .font(.body)
                                .foregroundColor(onSurfaceVariant)
                                .padding(.horizontal, 16)
                        } else {
                            HorizontalScrollContainer {
                                ForEach(viewModel.recentCoverLetters) { letter in
                                    CompactCoverLetterCard(letter: letter) {
                                        print("Selected letter for \(letter.companyName ?? "")")
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, 24)
            }
        }
        // Bottom Overlay Sheets Sheet Presenters Block Layer
        
        .sheet(isPresented: $showJobAdEntry) {
            UploadJobAdView(
                selectedResumeContent: viewModel.selectedResumeFullText,
                onDismiss : { showJobAdEntry = false },
                onSelectResume : { showJobAdEntry = false },
                onShowPaywall : {
                    showJobAdEntry = false
                    viewModel.triggerPaywall()
                }
            )
        }
        .sheet(isPresented: $showCoverLetterEntry) {
            CoverLetterSheetContent { showCoverLetterEntry = false }
        }
        .sheet(isPresented: $viewModel.showPaywall) {
            // FIXED: Removed editor placeholder block and mapped onSuccess to view model logic
            RevenueCatPaywallView {
                viewModel.dismissPaywall()
            } onSuccess: {
                viewModel.dismissPaywall()
                // Refresh premium states securely here if needed
            }
        }
        .fileImporter(
            isPresented: $showFilePicker,
            allowedContentTypes: [UTType.pdf],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let selectedProductionURL = urls.first {
                    viewModel.uploadResumeToSupabase(fileURL: selectedProductionURL)
                }
            case .failure(let error):
                print("Picker Context Error: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Component Extraction UI Elements

struct HeaderSectionView: View {
    let name: String
    let credits: Int
    
    private var greetingMessage: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12:  return "Good Morning,"
        case 12..<17: return "Good Afternoon,"
        case 17..<21: return "Good Evening,"
        default:      return "Good Night,"
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(greetingMessage)
                    .font(.body)
                    .foregroundColor(.gray)
                
                Text(name)
                    .font(.system(size: 38, weight: .black))
                    .linearGradientForeground(colors: [.blue, .purple])
            }
            
            Spacer()
            
            // Premium Floating Token Counter Balance Badge View Component
            HStack(spacing: 6) {
                Image(systemName: "crown.fill") // or alternative custom premium token glyph icons
                    .foregroundColor(Color(red: 1.0, green: 0.84, blue: 0.0))
                    .font(.system(size: 14))
                Text("\(credits)")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color(red: 0.12, green: 0.12, blue: 0.14))
            .cornerRadius(18)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
        }
        .padding(.horizontal, 20)
    }
}



struct SectionHeaderView: View {
    let title: String
    var onSeeAll: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            Spacer()
            Button(action: onSeeAll) {
                Text("See All")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal, 20)
    }
}

struct HorizontalScrollContainer<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                content
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Extension Text Linear Gradient Brush Helpers
extension View {
    func linearGradientForeground(colors: [Color]) -> some View {
        self.overlay(
            LinearGradient(
                colors: colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .mask(self)
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double(hex & 0xff) / 255,
            opacity: alpha
        )
    }
}
