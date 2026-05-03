//
//  TemplatePickerView.swift
//  ResumeAIApp
//
//  Created by mac on 3/23/26.
//

import SwiftUI
import SwiftData

struct TemplatePickerView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedTemplateIndex = 0
    
    var viewModel: ResumeViewModel
    
    @Binding var isPresented: Bool
    @Binding var shouldOpenEditor: Bool
    
    // Example template data
    let templates = [
        ResumeTemplate(id: "1", name: "Modern Minimalist", image: "temp_modern"),
        ResumeTemplate(id: "2", name: "Executive Professional", image: "temp_exec"),
        ResumeTemplate(id: "3", name: "Creative Bold", image: "temp_creative")
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Large Preview Gallery
                TabView(selection: $selectedTemplateIndex) {
                    ForEach(0..<templates.count, id: \.self) { index in
                        TemplateCard(template: templates[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(height: 450)
                
                // Details and Selection
                VStack(spacing: 8) {
                    Text(templates[selectedTemplateIndex].name)
                        .font(.title2.bold())
                    
                    Text("Optimized for tech and software roles.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Button(action: {
                    // Close this picker
                    isPresented = false
                    viewModel.selectedTemplateID = templates[selectedTemplateIndex].id
                                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        shouldOpenEditor = true
                    }
                }) {
                    Text("Use This Template")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("Choose a Design")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    // You'll need to mock a modelContext for the preview VM
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Resume.self, configurations: config)
    
    return TemplatePickerView(
        viewModel: ResumeViewModel(modelContext: container.mainContext), isPresented: .constant(true),
        shouldOpenEditor: .constant(false)
    )
}
