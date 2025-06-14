//
//  CurrentTextDisplayView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 14/06/2025.
//

import SwiftUI

struct CurrentTextDisplayView: View {
    let words: [String]
    let highlightIndex: Int
    
    let settings = GlobalSettings()
    private var highlightColor: Color {
        return settings.highlightColor
    }
    
    var body: some View {
        
        // Combine Text views for each word
        words.enumerated().reduce(Text(""), { (result, pair) in
            
            let (index, word) = pair
            
            let styledWord: Text = index == highlightIndex
            ? Text(word + " ")
                .foregroundColor(highlightColor)
                .bold()
                : Text(word + " ")
            
            return result + styledWord
            
        })
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

#Preview {
    CurrentTextDisplayView(words: ["My Word", "is the Truth"], highlightIndex: 0)
}
