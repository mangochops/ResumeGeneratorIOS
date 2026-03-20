//
//  ResendEmail.swift
//  ResumeAIApp
//
//  Created by mac on 3/19/26.
//

import Foundation
import Supabase

struct Response: Decodable {
  // Expected response definition
}

func invokeResendEmail() async throws {
    let response: Response = try await SupabaseManager.shared.client.functions
        .invoke(
            "resend-email",
            options: FunctionInvokeOptions(
                body: ["name": "Functions"]
            )
        )
}
