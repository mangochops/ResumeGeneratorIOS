//
//  Paywall.swift
//  ResumeAIApp
//
//  Created by mac on 3/28/26.
//

import SwiftUI
import RevenueCat
import RevenueCatUI

struct DashboardView: View {
    @State private var showPaywall = false
    @State private var isProcessing = false

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "paperplane.fill")
                .font(.largeTitle)
                .foregroundColor(.blue)

            Button(action: {
                checkAccessAndProceed()
            }) {
                if isProcessing {
                    ProgressView()
                } else {
                    Text("Tailor My Resume Now")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
        }
        // Use the boolean binding for manual control, or the entitlement-based one
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
    }

    func checkAccessAndProceed() {
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            // Check if the entitlement "pro_access" is active
            if let entitlements = customerInfo?.entitlements,
               entitlements["pro_access"]?.isActive == true {
                startTailoringProcess()
            } else {
                showPaywall = true
            }
        }
    }

    func startTailoringProcess() {
        print("Starting AI Tailoring for Cv Pilot...")
        isProcessing = true
        
        // This is where you will eventually call your Supabase Edge Function
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isProcessing = false
            print("Resume optimized for ATS!")
        }
    }
}
#Preview {
    let _ = Purchases.configure(withAPIKey: "test_fQmhDabrxyXbYqUbgnOZjERQgVe")
    return DashboardView()
}
