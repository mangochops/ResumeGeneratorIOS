//
//  CoverLetterView.swift
//  ResumeAIApp
//
//  Created by mac on 3/11/26.
//

import SwiftUI
import Supabase

struct CoverLetterView: View {
    
    let supabaseClient: SupabaseClient
    
    // UI Local State Sheet Toggles
    @State private var showJobAdEntry = false
    @State private var showCoverLetterEntry = false
    @State private var showOptimizationSheet = false
    @State private var activeOptimizationType: OptimizationType = .bulletRewrite
    
    // Core Engine Layout Configurations
    enum OptimizationType {
        case bulletRewrite
        case summaryImprove
        case matchAnalysis
        case atsCheck
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
                                    showJobAdEntry = true
                                }
                                
                                GridToolCard(
                                    title: "Cover Letter",
                                    description: "Draft contextual application statements from standard requirements.",
                                    icon: "envelope.fill",
                                    iconColor: Color(.systemGreen),
                                    bgColor: Color(.systemGreen).opacity(0.08)
                                ) {
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
                                    activeOptimizationType = .bulletRewrite
                                    showOptimizationSheet = true
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
                                    activeOptimizationType = .summaryImprove
                                    showOptimizationSheet = true
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
                                    activeOptimizationType = .matchAnalysis
                                    showOptimizationSheet = true
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
                                    activeOptimizationType = .atsCheck
                                    showOptimizationSheet = true
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
            .sheet(isPresented: $showOptimizationSheet) {
                Text("Prompt Optimization Sheet Content - \(String(describing: activeOptimizationType))")
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showCoverLetterEntry) {
                Text("Cover Letter Generation Workspace Entry")
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showJobAdEntry) {
                Text("Upload/Parse Job Advertisement Interface")
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

// --- SUBCOMPONENT 1: DYNAMIC CORE GRID COMPONENT ---
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
                // Top Custom Icon Plate
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(bgColor)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(iconColor)
                }
                .frame(width: 40, height: 40)
                
                Spacer()
                
                // Bottom Text Hierarchy Group
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
                // Custom Icon Plate container matching material design spec
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(iconBgColor)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(iconTextColor)
                }
                .frame(width: 44, height: 44)
                
                // Label groups
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
                
                // Chevron decoration
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
