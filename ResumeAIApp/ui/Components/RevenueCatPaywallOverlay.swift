

//
//  RevenueCatPaywallOverlay.swift
//  ResumeAIApp
//
//  Created by mac on 5/19/26.
//

import SwiftUI
import RevenueCat
import RevenueCatUI

// RENAMED: Changed to RevenueCatPaywallView to prevent redeclaration conflicts
struct RevenueCatPaywallView: View {
    var onDismiss: () -> Void
    var onSuccess: () -> Void
    
    var body: some View {
        PaywallView()
            // Native RevenueCat listener delegate modifiers
            .onPurchaseCompleted { customerInfo in
                // Verifies active entitlement strings before triggering the success block
                if customerInfo.entitlements["premium"]?.isActive == true ||
                   customerInfo.entitlements["pro"]?.isActive == true {
                    onSuccess()
                }
            }
            .onPurchaseFailure { error in
                print("CV_PAYWALL - Purchase failed: \(error.localizedDescription)")
            }
            .onRestoreCompleted { customerInfo in
                if customerInfo.entitlements["premium"]?.isActive == true ||
                   customerInfo.entitlements["pro"]?.isActive == true {
                    onSuccess()
                }
            }
    }
}
