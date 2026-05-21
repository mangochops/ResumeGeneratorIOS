//
//  CompactResumeSkeletonCard.swift
//  ResumeAIApp
//
//  Created by mac on 5/19/26.
//

import SwiftUI

struct CompactResumeSkeletonCard: View {
    @State private var phase: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Icon Placeholder
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.06))
                .frame(width: 44, height: 44)
            
            Spacer(minLength: 0)
            
            // Text Row 1 Placeholder
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white.opacity(0.06))
                .frame(width: 100, height: 14)
            
            // Text Row 2 Placeholder
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white.opacity(0.04))
                .frame(width: 70, height: 10)
        }
        .padding(16)
        .frame(width: 150, height: 150, alignment: .leading)
        .background(Color(red: 0.11, green: 0.11, blue: 0.13))
        .cornerRadius(20)
        .modifier(ShimmerModifier(phase: phase))
        .onAppear {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                phase = 1.0
            }
        }
    }
}

struct ShimmerModifier: ViewModifier {
    var phase: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        colors: [.clear, .white.opacity(0.05), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(width: geo.size.width * 2)
                    .offset(x: -geo.size.width + (geo.size.width * 2 * phase))
                }
            )
            .mask(content)
    }
}
