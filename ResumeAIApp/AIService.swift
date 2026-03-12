import Foundation

// MARK: - OpenAI Response Models

struct OpenAIResponse: Decodable {
    let choices: [Choice]
}

struct Choice: Decodable {
    let message: Message
}

struct Message: Decodable {
    let content: String
}


// MARK: - AI Service

class AIService {
    
    let apiKey = "YOUR_OPENAI_KEY"
    
    func tailorResume(
        cv: String,
        jobDescription: String
    ) async throws -> String {
        
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let prompt = """
        Rewrite this CV so it matches the job description.

        CV:
        \(cv)

        JOB DESCRIPTION:
        \(jobDescription)

        Make it ATS optimized with strong bullet points.
        """
        
        let body: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [
                ["role": "user", "content": prompt]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let response = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        
        return response.choices.first?.message.content ?? "No response generated"
    }
}
