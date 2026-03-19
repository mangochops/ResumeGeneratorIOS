//
//  ATSAnalytics.swift
//  ResumeAIApp
//
//  Created by mac on 3/19/26.
//

import SwiftUI

struct ATSAnalyticsView: View {
    @State private var score: Double = 0.85 // Simulate a score
    @State private var isAnalyzing = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Score Gauge
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                    Circle()
                        .trim(from: 0, to: isAnalyzing ? 0 : score)
                        .stroke(score > 0.7 ? Color.green.gradient : Color.orange.gradient, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    
                    VStack {
                        Text("\(Int(score * 100))%")
                            .font(.system(size: 60, weight: .bold, design: .rounded))
                        Text("ATS Score")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(width: 250, height: 250)
                .padding(.top)

                // Detailed Metrics
                VStack(alignment: .leading, spacing: 20) {
                    analysisRow(title: "Keyword Matching", value: "Strong", icon: "checkmark.seal.fill", color: .green)
                    analysisRow(title: "Formatting", value: "Clean", icon: "doc.text.fill", color: .blue)
                    analysisRow(title: "Contact Info", value: "Found", icon: "person.text.rectangle.fill", color: .purple)
                }
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Button("Re-Analyze Resume") {
                    withAnimation(.easeInOut(duration: 1.5)) {
                        isAnalyzing = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isAnalyzing = false
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .navigationTitle("ATS Analytics")
        .background(Color(UIColor.systemGroupedBackground))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 1.5)) { isAnalyzing = false }
            }
        }
    }

    private func analysisRow(title: String, value: String, icon: String, color: Color) -> some View {
        HStack {
            Image(systemName: icon).foregroundStyle(color).font(.title2)
            Text(title).font(.body)
            Spacer()
            Text(value).fontWeight(.bold).foregroundStyle(color)
        }
    }
}

#Preview {
    ATSAnalyticsView()
}
