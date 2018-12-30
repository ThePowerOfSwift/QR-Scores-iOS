//
//  Survey+UIActivityViewController.swift
//  QR Scores
//
//  Created by Erick Sanchez on 11/11/18.
//  Copyright © 2018 LinnierGames. All rights reserved.
//

import UIKit.UIActivityViewController

extension UIActivityViewController {
    
    /**
     generates a pdf page from the survey
     */
    convenience init?(surveyQRCode survey: Survey) {
        /**
         TODO: qrCodeTemplate-use the options defined there to create the page
         */
        
        var generator = QRCodeGenerator(url: survey.generatedUrl)
        guard let qrImage = generator.generateImage() else {
            return nil
        }
        
        do {
            var pdf = PDFGenerator()
            try pdf.addGridPage(with: qrImage, imageSize: CGSize(width: 64, height: 64))
            
            guard let pdfData = pdf.pdf() else {
                throw PDFGenerator.Errors.failedToGeneratePDFData
            }
            
            self.init(activityItems: [pdfData], applicationActivities: [])
        } catch {
            assertionFailure(error.localizedDescription)
            
            return nil
        }
    }
    
    convenience init(surveyURL survey: Survey) {
        self.init(activityItems: [survey.generatedUrl], applicationActivities: [])
    }
}
