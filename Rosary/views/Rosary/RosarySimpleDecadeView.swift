//
//  RosarySimpleDecadeView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 16/06/2025.
//

import SwiftUI

struct RosarySimpleDecadeView: View {
    
    public var currentBeadIndex: Int
    
    let columns = [
        GridItem(.adaptive(minimum: 20), spacing: 20)
    ]
    
    func isOurFather(index: Int) -> Bool {
        if index == 0 {
            return true // First Our Father bead
        }
        
        // After first 5 intro beads, every 11th bead is an Our Father bead
        let startOfDecades = 4
        return (index - startOfDecades) % 11 == 0 && index >= startOfDecades
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(0..<59, id: \.self) { index in
                if isOurFather(index: index) {
                    OurFatherBeadView(
                        isCompleted: index == currentBeadIndex,
                        isActive: index < currentBeadIndex
                    )
                } else {
                    BeadView(
                        isCompleted: index == currentBeadIndex,
                        isActive: index < currentBeadIndex
                    )
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    RosarySimpleDecadeView(currentBeadIndex: 2)
}


