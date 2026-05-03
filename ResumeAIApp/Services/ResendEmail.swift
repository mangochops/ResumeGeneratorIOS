import Foundation
import Supabase

// 1. Define what the Edge Function returns
struct ResendResponse: Decodable {
    let message: String
}

@MainActor
class EmailService: ObservableObject {
    @Published var isSending = false
    @Published var lastMessage = ""

    func invokeResendEmail(email: String) async {
        isSending = true
        
        do {
            // 2. Call your local Edge Function
            // Note: Ensure you've created 'resend-email' in VS Code!
            let response: ResendResponse = try await SupabaseManager.shared.client.functions
                .invoke(
                    "resend-email",
                    options: FunctionInvokeOptions(
                        body: ["email": email]
                    )
                )
            
            self.lastMessage = response.message
            print("✅ Success: \(response.message)")
            
        } catch {
            self.lastMessage = "Failed to send: \(error.localizedDescription)"
            print("❌ Error: \(error)")
        }
        
        isSending = false
    }
}
