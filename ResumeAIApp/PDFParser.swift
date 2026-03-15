//
//  PDFParser.swift
//  ResumeAIApp
//
//  Created by mac on 3/14/26.
//

import PDFKit

struct PDFParser {
    
    static func extractText(from url: URL) -> String? {
        
        guard let document = PDFDocument(url: url) else {
            return nil
        }
        
        var fullText = ""
        
        for pageIndex in 0..<document.pageCount {
            
            guard let page = document.page(at: pageIndex) else { continue }
            
            if let pageText = page.string {
                fullText += pageText + "\n"
            }
        }
        
        return fullText
    }
}
