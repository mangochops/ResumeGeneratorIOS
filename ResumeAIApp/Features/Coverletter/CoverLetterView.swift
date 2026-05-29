//
//  CoverLetterView.swift
//  ResumeAIApp
//
//  Created by mac on 3/11/26.
//

import SwiftUI
import Supabase

struct CoverLetterView: View {
    
    @State private var viewModel: CoverLetterViewModel
    
    // UI local UI presentation state controls only
    @State private var showJobAdEntry = false
    @State private var showCoverLetterEntry = false
    @State private var showOptimizationSheet = false
    @State private var activeOptimizationType: OptimizationType = .bulletRewrite
    @State private var showDocumentPreview = false
    
    @MainActor
    init(supabaseClient: SupabaseClient) {
        _viewModel = State(initialValue: CoverLetterViewModel(supabaseClient: supabaseClient))
    }
    
    // Core Engine Layout Configurations
    enum OptimizationType {
        case bulletRewrite
        case summaryImprove
        case matchAnalysis
        case atsCheck
        
        var title: String {
            switch self {
            case .bulletRewrite: return "Rewrite Resume Bullet"
            case .summaryImprove: return "Improve Professional Summary"
            case .matchAnalysis: return "Analyze Job Match Rating"
            case .atsCheck: return "ATS Check Optimization"
            }
        }
        
        var placeholder: String {
            switch self {
            case .bulletRewrite: return "Paste a bullet point you want to improve (e.g., 'Responsible for managing technical support operations.')"
            case .summaryImprove: return "Paste your current profile bio or professional summary statement..."
            case .matchAnalysis: return "Paste the target job description to run structural comparison matrices..."
            case .atsCheck: return "Paste your text to execute structural compliance scans for layout parsers..."
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // --- HEADER TITLE BLOCKS ---
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Your")
                                .font(.body)
                                .foregroundColor(.gray)
                            
                            Text("AI Workspace")
                                .font(.system(size: 28, weight: .black, design: .default))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.purple, Color.blue],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                        .padding(.top, 12)
                        
                        // Description status line
                        Text("Select an optimized agent to improve your professional application documents.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        // --- SECTION 1: CORE ENGINE POWER GRID ---
                        VStack(alignment: .leading, spacing: 12) {
                            Text("CORE ENGINES")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.secondary)
                                .tracking(1.5)
                            
                            HStack(spacing: 12) {
                                GridToolCard(
                                    title: "Tailor Resume",
                                    description: "Align experiences with an active job description text copy.",
                                    icon: "sparkles",
                                    iconColor: Color(.systemPurple),
                                    bgColor: Color(.systemPurple).opacity(0.08)
                                ) {
                                    viewModel.clearWorkspaceBuffers()
                                    showJobAdEntry = true
                                }
                                  
                                GridToolCard(
                                    title: "Cover Letter",
                                    description: "Draft contextual application statements from standard requirements.",
                                    icon: "envelope.fill",
                                    iconColor: Color(.systemGreen),
                                    bgColor: Color(.systemGreen).opacity(0.08)
                                ) {
                                    viewModel.clearWorkspaceBuffers()
                                    showCoverLetterEntry = true
                                }
                            }
                        }
                        
                        // --- SECTION 2: INDIVIDUAL OPTIMIZERS ---
                        VStack(alignment: .leading, spacing: 12) {
                            Text("RESUME OPTIMIZATION UTILITIES")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.secondary)
                                .tracking(1.5)
                            
                            // Wrapped unified group card container
                            VStack(spacing: 0) {
                                ListToolItem(
                                    title: "Rewrite Resume Bullet",
                                    subtitle: "Enhance responsibility syntax using strong impact verbs.",
                                    icon: "pencil",
                                    iconBgColor: Color(red: 0.12, green: 0.16, blue: 0.23),
                                    iconTextColor: Color(red: 0.22, green: 0.74, blue: 0.97)
                                ) {
                                    openUtilityWorkspace(type: .bulletRewrite)
                                }
                                  
                                Divider()
                                    .padding(.leading, 72)
                                  
                                ListToolItem(
                                    title: "Improve Professional Summary",
                                    subtitle: "Structure high-level personal value declarations.",
                                    icon: "text.alignleft",
                                    iconBgColor: Color(red: 0.18, green: 0.06, blue: 0.40),
                                    iconTextColor: Color(red: 0.75, green: 0.52, blue: 0.99)
                                ) {
                                    openUtilityWorkspace(type: .summaryImprove)
                                }
                                  
                                Divider()
                                    .padding(.leading, 72)
                                  
                                ListToolItem(
                                    title: "Analyze Job Match Rating",
                                    subtitle: "Benchmark resume keyword data matrices against active adverts.",
                                    icon: "chart.bar.fill",
                                    iconBgColor: Color(red: 0.02, green: 0.31, blue: 0.23),
                                    iconTextColor: Color(red: 0.20, green: 0.83, blue: 0.60)
                                ) {
                                    openUtilityWorkspace(type: .matchAnalysis)
                                }
                                  
                                Divider()
                                    .padding(.leading, 72)
                                  
                                ListToolItem(
                                    title: "ATS Check Optimization",
                                    subtitle: "Run deep structural compliance scans to eliminate parsing barriers.",
                                    icon: "checkmark.seal.fill",
                                    iconBgColor: Color(red: 0.27, green: 0.10, blue: 0.01),
                                    iconTextColor: Color(red: 0.98, green: 0.57, blue: 0.24)
                                ) {
                                    openUtilityWorkspace(type: .atsCheck)
                                }
                            }
                            .background(Color(.secondarySystemBackground).opacity(0.4))
                            .cornerRadius(24)
                            .overlay(
                                RoundedCornerShape(cornerRadius: 24)
                                    .stroke(Color(.separator), lineWidth: 1)
                            )
                        }
                        
                        Spacer(minLength:40)
                    }
                    .padding(.horizontal, 20)
                }
            }
            // --- MODAL INTERACTION SHEET SYSTEMS ---
            
            // 1. Unified Utility Processing Sheet
            .sheet(isPresented: $showOptimizationSheet) {
                NavigationStack {
                    @Bindable var vm = viewModel
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Text(activeOptimizationType.title)
                                .font(.title2.bold())
                                .padding(.top)
                            
                            TextEditor(text: $vm.textInputBuffer)
                                .frame(height: 140)
                                .padding(8)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(12)
                                .overlay(
                                    Group {
                                        if vm.textInputBuffer.isEmpty {
                                            Text(activeOptimizationType.placeholder)
                                                .foregroundColor(.gray)
                                                .font(.subheadline)
                                                .padding(.init(top: 16, leading: 12, bottom: 0, trailing: 0))
                                        }
                                    }, alignment: .topLeading
                                )
                            
                            Button {
                                viewModel.runAIUtilityProcessing(type: activeOptimizationType)
                            } label: {
                                if viewModel.isProcessingAI {
                                    ProgressView().tint(.white)
                                } else {
                                    Text("Analyze with AI").font(.headline)
                                }
                            }
                            .frame(maxWidth: .infinity).frame(height: 50)
                            .background(vm.textInputBuffer.isEmpty ? Color.gray : Color.blue)
                            .foregroundColor(.white).cornerRadius(12)
                            .disabled(vm.textInputBuffer.isEmpty || viewModel.isProcessingAI)
                            
                            if !viewModel.aiResultOutput.isEmpty {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("AI Analysis Output").font(.headline)
                                    Text(viewModel.aiResultOutput)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.blue.opacity(0.08)).cornerRadius(12)
                                        .textSelection(.enabled)
                                }
                            }
                        }
                        .padding()
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Done") { showOptimizationSheet = false }
                        }
                    }
                }
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
            
            // 2. Cover Letter Workspace Sheet
            .sheet(isPresented: $showCoverLetterEntry) {
                NavigationStack {
                    @Bindable var vm = viewModel
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Generate Custom Cover Letter")
                                .font(.title2.bold())
                                .padding(.top)
                            
                            TextField("Company Name", text: $vm.companyName)
                                .textFieldStyle(.roundedBorder)
                            
                            TextField("Job Title Target", text: $vm.jobTitle)
                                .textFieldStyle(.roundedBorder)
                            
                            Text("Paste requirements or full Job Specification:")
                                .font(.subheadline).foregroundColor(.secondary)
                            
                            TextEditor(text: $vm.jobAdBuffer)
                                .frame(height: 140).padding(4)
                                .background(Color(.secondarySystemBackground)).cornerRadius(12)
                            
                            Button {
                                viewModel.generateCoverLetterWithAI()
                            } label: {
                                if viewModel.isProcessingAI {
                                    ProgressView().tint(.white)
                                } else {
                                    Text("Draft Statements").font(.headline)
                                }
                            }
                            .frame(maxWidth: .infinity).frame(height: 50)
                            .background(vm.jobAdBuffer.isEmpty || vm.companyName.isEmpty ? Color.gray : Color.green)
                            .foregroundColor(.white).cornerRadius(12)
                            .disabled(vm.jobAdBuffer.isEmpty || vm.companyName.isEmpty || viewModel.isProcessingAI)
                            
                            if !viewModel.aiResultOutput.isEmpty {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Generated Letter Preview").font(.headline)
                                    Text(viewModel.aiResultOutput)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.green.opacity(0.08)).cornerRadius(12)
                                        .textSelection(.enabled)
                                }
                            }
                        }
                        .padding()
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Close") { showCoverLetterEntry = false }
                        }
                    }
                }
            }
            
            // 3. Tailor Resume Workspace Sheet
            .sheet(isPresented: $showJobAdEntry) {
                            NavigationStack {
                                @Bindable var vm = viewModel
                                ScrollView {
                                    VStack(alignment: .leading, spacing: 20) {
                                        Text("Tailor Resume Target")
                                            .font(.title2.bold())
                                            .padding(.top)
                                        
                                        // Check if the engine completed optimization processing successfully
                                        if !viewModel.aiResultOutput.isEmpty && !viewModel.isProcessingAI && viewModel.aiResultOutput.contains("✅") {
                                            
                                            // Success Notice Display Panel
                                            VStack(spacing: 16) {
                                                ZStack {
                                                    Circle()
                                                        .fill(Color.purple.opacity(0.1))
                                                        .frame(width: 80, height: 80)
                                                    Image(systemName: "doc.plaintext.fill")
                                                        .font(.system(size: 32))
                                                        .foregroundColor(.purple)
                                                }
                                                
                                                Text("Optimization Engine Complete")
                                                    .font(.headline)
                                                
                                                Text(viewModel.aiResultOutput)
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                                    .multilineTextAlignment(.center)
                                                    .padding(.horizontal)
                                            }
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 30)
                                            
                                            // SUCCESS ACTION CONTROLS: "Preview" and "Start Over"
                                            VStack(spacing: 12) {
                                                Button {
                                                    showDocumentPreview = true
                                                } label: {
                                                    HStack {
                                                        Image(systemName: "eye.fill")
                                                        Text("Preview Resume")
                                                    }
                                                    .font(.headline)
                                                }
                                                .frame(maxWidth: .infinity).frame(height: 52)
                                                .background(Color.purple)
                                                .foregroundColor(.white)
                                                .cornerRadius(12)
                                                
                                                Button {
                                                    viewModel.clearWorkspaceBuffers()
                                                } label: {
                                                    Text("Start Over")
                                                        .font(.headline)
                                                        .foregroundColor(.purple)
                                                }
                                                .frame(maxWidth: .infinity).frame(height: 52)
                                                .background(Color.purple.opacity(0.08))
                                                .cornerRadius(12)
                                            }
                                            .padding(.top, 10)
                                            
                                        } else {
                                            // Default input form view while waiting for compilation
                                            VStack(alignment: .leading, spacing: 16) {
                                                TextField("Job Title Target", text: $vm.jobTitle)
                                                    .textFieldStyle(.roundedBorder)
                                                
                                                Text("Paste target raw Job Description below:")
                                                    .font(.subheadline).foregroundColor(.secondary)
                                                
                                                TextEditor(text: $vm.jobAdBuffer)
                                                    .frame(height: 180).padding(4)
                                                    .background(Color(.secondarySystemBackground)).cornerRadius(12)
                                                
                                                Button {
                                                    viewModel.executeResumeTailoringEngine()
                                                } label: {
                                                    if viewModel.isProcessingAI {
                                                        ProgressView().tint(.white)
                                                    } else {
                                                        Text("Optimize Experience Matrix").font(.headline)
                                                    }
                                                }
                                                .frame(maxWidth: .infinity).frame(height: 50)
                                                .background(vm.jobAdBuffer.isEmpty ? Color.gray : Color.purple)
                                                .foregroundColor(.white).cornerRadius(12)
                                                .disabled(vm.jobAdBuffer.isEmpty || viewModel.isProcessingAI)
                                                
                                                // Error display box if the connection fails or needs an upgrade
                                                if !viewModel.aiResultOutput.isEmpty {
                                                    Text(viewModel.aiResultOutput)
                                                        .font(.subheadline)
                                                        .foregroundColor(.red)
                                                        .padding()
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        .background(Color.red.opacity(0.05))
                                                        .cornerRadius(12)
                                                }
                                            }
                                        }
                                    }
                                    .padding()
                                }
                                .toolbar {
                                    ToolbarItem(placement: .topBarTrailing) {
                                        Button("Close") { showJobAdEntry = false }
                                    }
                                }
                            }
                            // Nested layout modal view presentation mapping
                            .sheet(isPresented: $showDocumentPreview) {
                                DocumentPreviewWorkspaceView(rawTextData: viewModel.aiResultOutput)
                            }
            }
        }
    }
    
    @MainActor
    private func openUtilityWorkspace(type: OptimizationType) {
        viewModel.clearWorkspaceBuffers()
        activeOptimizationType = type
        showOptimizationSheet = true
    }
}

// --- SUBCOMPONENTS ---

struct DocumentPreviewWorkspaceView: View {
    let rawTextData: String
    @Environment(\.dismiss) var dismissAction
    @State private var isDownloading = false
    @State private var showDownloadAlert = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Mimics a mock structural page container viewport
                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("DOCUMENT PREVIEW")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.secondary)
                                .tracking(1.0)
                            Spacer()
                            Label("PDF Saved", systemImage: "checkmark.circle.fill")
                                .font(.caption.bold())
                                .foregroundColor(.green)
                        }
                        .padding(.bottom, 8)
                        
                        Text("Tailored Resume Profile Framework")
                            .font(.title3.bold())
                        
                        Divider()
                        
                        Text("Your tailored resume optimization pipeline has run successfully. A structured version matching your target requirements is now compiled into your storage nodes.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                        
                        Text(rawTextData)
                            .font(.caption)
                            .foregroundColor(.primary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemBackground))
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
                    }
                    .padding(24)
                }
                .background(Color(.secondarySystemBackground).opacity(0.5))
                
                // Bottom Download Actions Container bar
                VStack {
                    Button {
                        isDownloading = true
                        // Trigger async file saving simulator tasks
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isDownloading = false
                            showDownloadAlert = true
                        }
                    } label: {
                        HStack(spacing: 10) {
                            if isDownloading {
                                ProgressView().tint(.white)
                            } else {
                                Image(systemName: "square.and.arrow.down.fill")
                                Text("Download Tailored PDF Document")
                            }
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    .disabled(isDownloading)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                .background(Color(.systemBackground))
            }
            .navigationTitle("Document Preview")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Dismiss") { dismissAction() }
                }
            }
            .alert("Download Completed", isPresented: $showDownloadAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your optimized workspace PDF summary file has been saved to your Local Files Storage directory.")
            }
        }
    }
}
struct GridToolCard: View {
    let title: String
    let description: String
    let icon: String
    let iconColor: Color
    let bgColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(bgColor)
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(iconColor)
                }
                .frame(width: 40, height: 40)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                    Text(description)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(2)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, minHeight: 170, maxHeight: 170, alignment: .leading)
            .background(Color(.secondarySystemBackground).opacity(0.4))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(.separator), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// --- SUBCOMPONENT 2: SEAMLESS ROW ITEM UTILITY ---
struct ListToolItem: View {
    let title: String
    let subtitle: String
    let icon: String
    let iconBgColor: Color
    let iconTextColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(iconBgColor)
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(iconTextColor)
                }
                .frame(width: 44, height: 44)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.primary)
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(.placeholderText).opacity(0.5))
            }
            .padding(16)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Helper structure to handle cleanly rendered custom border lines
struct RoundedCornerShape: Shape {
    var cornerRadius: CGFloat
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        return Path(path.cgPath)
    }
}
