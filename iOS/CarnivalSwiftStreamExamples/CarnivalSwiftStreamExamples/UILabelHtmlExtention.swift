//
//  UILabelHtmlExtention.swift
//  CarnivalSwiftStreamExamples
//
//  Created by Affian on 5/07/16.
//  Copyright © 2016 Carnival Mobile. All rights reserved.
//

import Foundation

extension UILabel {
    
    private func hexStringFromColor(color: UIColor) -> String {
        let components = color.cgColor.components
        
        let r = Float(components![0])
        let g = Float(components![1])
        let b = Float(components![2])
        
        return String.localizedStringWithFormat("#%02lX%02lX%02lX",
                                                  lroundf(r * 255),
                                                  lroundf(g * 255),
                                                  lroundf(b * 255));
    }
    
    public func setHtmlFromString(html: String) -> Void {
        
        let string = html.appendingFormat("<style>body{font-family: '%@'; font-size:%fpx; color: %@;}</style>",
                                                  self.font.fontName,
                                                  self.font.pointSize,
                                                  self.hexStringFromColor(color: self.textColor));
        
        do {
            try self.attributedText = NSAttributedString.init(data: string.data(using: String.Encoding.unicode)!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            
        }
        

    }
}
