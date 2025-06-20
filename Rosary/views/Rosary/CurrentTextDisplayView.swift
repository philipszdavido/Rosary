//
//  CurrentTextDisplayView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 14/06/2025.
//

import SwiftUI

#Preview {
    CurrentTextDisplayViewV2(
        currentText: "My Word is the Truth",
        range: NSRange(location: 8, length: 5)
    )

}

struct CurrentTextDisplayViewV2: View {
    
    public var currentText: String
    public var range: NSRange?
    
    func attributedText(fullText: String, range: NSRange?) -> AttributedString {
        
        if let range = range {

            let attributedString = NSMutableAttributedString(string: fullText)
            
            attributedString.setAttributes(
                [NSAttributedString.Key.foregroundColor: UIColor.orange],
                range: range
            )
                        
            return AttributedString(attributedString)

        }
        
        return AttributedString(fullText)
        
    }
    
    var body: some View {
        
        Text(attributedText(fullText: currentText, range: range))
            .font(
                Font?.init(
                    .system(
                        size: 20,
                        weight: .bold,
                        design: .default
                    )
                )
            )
            .font(.body)
            .fontWeight(.regular)
            
            .padding(.top, 3.0)
            .foregroundColor(.gray)
        
    }
}
