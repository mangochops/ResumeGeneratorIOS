//
//  PDFService.swift
//  ResumeAIApp
//
//  Created by mac on 3/11/26.
//

import UIKit

class PDFService {
    
    func generateResumePDF(
        name: String,
        title: String,
        summary: String
    ) -> Data {
        
        let renderer = UIGraphicsPDFRenderer(
            bounds: CGRect(x: 0, y: 0, width: 612, height: 792)
        )
        
        let data = renderer.pdfData { context in
            
            context.beginPage()
            
            let titleFont = UIFont.boldSystemFont(ofSize: 28)
            let textFont = UIFont.systemFont(ofSize: 14)
            
            name.draw(
                at: CGPoint(x: 40, y: 40),
                withAttributes: [.font: titleFont]
            )
            
            title.draw(
                at: CGPoint(x: 40, y: 80),
                withAttributes: [.font: textFont]
            )
            
            summary.draw(
                at: CGPoint(x: 40, y: 120),
                withAttributes: [.font: textFont]
            )
        }
        
        return data
    }
}
