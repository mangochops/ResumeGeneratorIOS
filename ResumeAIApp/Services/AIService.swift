import Foundation

// MARK: - OpenAI Response Models

struct OpenAIResponse: Decodable {
    let choices: [Choice]
}

struct Choice: Decodable {
    let message: Message
}

struct Message: Decodable {
    let content: String?
}

// Error shape from OpenAI
struct OpenAIErrorResponse: Decodable {
    let error: OpenAIError?
}

struct OpenAIError: Decodable {
    let message: String
    let type: String?
    let code: String?
    let param: String?      // optional
}

// Dedicated model for ATS analysis JSON response
struct ATSAnalysisResponse: Decodable {
    let ats_score: Int
    let improvement_suggestions: String
}

// MARK: - AI Service

class AIService {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func analyzeForATS(cvText: String) async throws -> (score: Int, suggestions: String) {
        guard let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"],
              !apiKey.isEmpty else {
            throw AIServiceError.missingAPIKey
        }
        
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            throw AIServiceError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let prompt = """
        You are an expert ATS optimization specialist.
        Analyze the following resume text strictly for ATS compatibility.

        Resume:
        \(cvText)

        Return **JSON only** — no markdown, no explanations, no code fences, nothing outside the JSON object.
        Use this exact structure:
        {
          "ats_score": integer between 0 and 100,
          "improvement_suggestions": "A detailed bullet-point list (using - or * ) of specific, actionable recommendations to improve ATS-friendliness. Include keyword optimization, formatting advice, section headings, common ATS pitfalls, etc."
        }
        """
        
        let body: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [["role": "user", "content": prompt]],
            "temperature": 0.3,          // Low for strict JSON adherence
            "max_tokens": 1200,
            "response_format": ["type": "json_object"]   // JSON mode (reliable on gpt-4o-mini)
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AIServiceError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let errorResp = try? JSONDecoder().decode(OpenAIErrorResponse.self, from: data),
               let errorMessage = errorResp.error?.message {
                throw AIServiceError.apiError(statusCode: httpResponse.statusCode, message: errorMessage)
            } else {
                throw AIServiceError.httpError(statusCode: httpResponse.statusCode)
            }
        }
        
        // Decode the JSON response
        let analysis = try JSONDecoder().decode(ATSAnalysisResponse.self, from: data)
        
        // Safety: clamp score to valid range
        let clampedScore = max(0, min(100, analysis.ats_score))
        
        return (clampedScore, analysis.improvement_suggestions)
    }
    
    func tailorResume(
        cv: String,
        jobDescription: String
    ) async throws -> String {
        
        guard let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"],
              !apiKey.isEmpty else {
            throw AIServiceError.missingAPIKey
        }
        
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            throw AIServiceError.invalidURL
        }
        
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
        Use action verbs, quantify achievements where possible, and keep formatting clean.
        """
        
        let body: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [["role": "user", "content": prompt]],
            "temperature": 0.7,
            "max_tokens": 1800
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AIServiceError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let errorResp = try? JSONDecoder().decode(OpenAIErrorResponse.self, from: data),
               let errorMessage = errorResp.error?.message {
                throw AIServiceError.apiError(statusCode: httpResponse.statusCode, message: errorMessage)
            } else {
                throw AIServiceError.httpError(statusCode: httpResponse.statusCode)
            }
        }
        
        do {
            let openAIResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
            guard let content = openAIResponse.choices.first?.message.content else {
                throw AIServiceError.noContentGenerated
            }
            return content
        } catch {
            throw AIServiceError.decodingFailed(underlying: error)
        }
    }
}

// MARK: - Custom Errors

enum AIServiceError: Error, LocalizedError {
    case missingAPIKey
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case apiError(statusCode: Int, message: String)
    case noContentGenerated
    case decodingFailed(underlying: Error)
    
    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "OPENAI_API_KEY environment variable is missing or empty."
        case .invalidURL:
            return "Invalid OpenAI API URL."
        case .invalidResponse:
            return "Invalid HTTP response."
        case .httpError(let code):
            return "HTTP error with status code \(code)."
        case .apiError(_, let message):
            return "OpenAI API error: \(message)"
        case .noContentGenerated:
            return "No content was generated by the model."
        case .decodingFailed(let error):
            return "Failed to decode OpenAI response: \(error.localizedDescription)"
        }
    }
}
