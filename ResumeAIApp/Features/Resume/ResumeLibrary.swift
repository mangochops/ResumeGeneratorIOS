//
//  ResumeLibrary.swift
//  ResumeAIApp
//
//  Created by mac on 3/13/26.
//

import SwiftUI
import SwiftData

enum LibraryTab {
    case resumes
    case coverLetters
}

struct ResumeLibraryView: View {
    // Environment property wrapper to access the active model context
    @Environment(\.modelContext) private var modelContext
    
    @State private var viewModel: ResumeViewModel?
    @State private var showTemplatePicker = false // New state
    @State private var showEditor = false
    @State private var activeTab: LibraryTab = .resumes
    @State private var showFileImporter = false
    
    let resumes: [Resume]
    let coverLetters: [CoverLetter]
    
    private let backgroundColor = Color(red: 0.07, green: 0.07, blue: 0.08)
    private let cardColor = Color(red: 0.12, green: 0.12, blue: 0.14)
    private let tabSelectorColor = Color(red: 0.18, green: 0.18, blue: 0.20)
    
    var body: some View {
        NavigationStack {
            HeaderTitleView(
                name: "Library"
            )
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    primaryResumeSection
                        .padding(.top, 12)
                    
                    // MARK: - Custom Segmented Control Header View Block
                    HStack(spacing: 0) {
                        tabButton(title: "Resumes", tab: .resumes)
                        tabButton(title: "Cover Letters", tab: .coverLetters)
                    }
                    .padding(4)
                    .background(tabSelectorColor)
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                    
                    // MARK: - Dynamic Tab Segment View Router
                    Group {
                        switch activeTab {
                        case .resumes:
                            if resumes.isEmpty {
                                emptyState(text: "No Resumes Yet", subtitle: "Create your first AI optimized resume")
                            } else {
                                resumeList
                            }
                        case .coverLetters:
                            if coverLetters.isEmpty {
                                emptyState(text: "No Cover Letters Yet", subtitle: "AI hasn't generated any cover letters yet")
                            } else {
                                coverLetterList
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                // Floating Action Button Anchor Frame Layout
//                createButton
            }
            .sheet(isPresented: $showEditor) {
                // Safely falls back to an on-the-fly instance if viewModel is nil
                ResumeEditorView(viewModel: viewModel ?? ResumeViewModel(modelContext: modelContext))
            }
            
            .onAppear {
                if viewModel == nil {
                    // FIX: Passed the environment modelContext into your initializer
                    viewModel = ResumeViewModel(modelContext: modelContext)
                }
                // Custom overrides to clean layout navigation lists styling behavior global frames
                UICollectionView.appearance().backgroundColor = .clear
            }
        }
    }
}

// MARK: - Subviews & Extensions Layout Nodes
extension ResumeLibraryView {
    private var primaryResumeSection: some View {
            let primaryResume = resumes.first
        
        let sectionBorderColor = Color(red: 0.18, green: 0.18, blue: 0.18)
            
            return VStack(alignment: .leading, spacing: 8) {
                Text("PRIMARY CV")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(1.5)
                    .foregroundColor(.gray)
                    .padding(.leading, 20)
                
                VStack(spacing: 0) {
                    HStack(spacing: 16) {
                        // Gold Accent Icon Container Frame Block
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 0.13, green: 0.15, blue: 0.16))
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "star.fill")
                                .font(.system(size: 20))
                                .foregroundColor(Color(red: 1.0, green: 0.84, blue: 0.0))
                        }
                        
                        // Main Meta Label Matrix Block Layout
                        VStack(alignment: .leading, spacing: 4) {
                            Text(primaryResume?.title ?? "No Master CV Set")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(primaryResume?.name ?? "Upload your master copy base file")
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        // Action Trigger Elements Flow Block
                        if primaryResume == nil {
                            Button {
                                showFileImporter = true
                            } label: {
                                Text("Setup")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 6)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding(16)
                }
                .background(cardColor)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(sectionBorderColor, lineWidth: 1)
                )
                .padding(.horizontal, 16)
                .onTapGesture {
                    if let primary = primaryResume {
                        // Navigate directly to your item editor layout anchor node
                        viewModel?.selectedResume = primary
                        showEditor = true
                    } else {
                        showFileImporter = true
                    }
                }
            }
        }
    
    private func tabButton(title: String, tab: LibraryTab) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                activeTab = tab
            }
        } label: {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 38)
                .background(activeTab == tab ? cardColor : Color.clear)
                .cornerRadius(10)
        }
    }
    
    // MARK: - Resume Dynamic List Layout View
    private var resumeList: some View {
        List {
            ForEach(resumes) { resume in
                ResumeCard(resume: resume)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
            }
            .onDelete(perform: deleteResume)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    
    // MARK: - Cover Letters List Layout View
    private var coverLetterList: some View {
        List {
            ForEach(coverLetters) { letter in
                // Custom UI row rendering configuration matching Android style
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(letter.jobTitle)
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("\(letter.jobTitle) at \(letter.companyName)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray.opacity(0.5))
                }
                .padding()
                .background(cardColor)
                .cornerRadius(14)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
            }
            .onDelete(perform: deleteCoverLetter)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    
    // MARK: - Standard Blank Empty State UI Block Element Frame
    private func emptyState(text: String, subtitle: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 54))
                .foregroundColor(.gray.opacity(0.4))
            
            Text(text)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }
    
    // MARK: - Custom Floating Circular Trigger Action Button Context
    private var createButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    showTemplatePicker = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 22, weight: .bold))
                        .padding(18)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: 4)
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 24)
        }
    }
    
    private func deleteResume(at offsets: IndexSet) {
        for index in offsets {
            viewModel?.deleteResume(resumes[index])
        }
    }
    
    private func deleteCoverLetter(at offsets: IndexSet) {
        for index in offsets {
            viewModel?.deleteCoverLetter(coverLetters[index])
        }
    }
}
