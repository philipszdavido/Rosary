//
//  RosaryDecadeView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 14/06/2025.
//

import SwiftUI

struct RosaryDecadeView: View {
    var decadeNumber: Int
    var currentBead: Int // Keeps track of the current bead
    var body: some View {
        HStack {
            ForEach(0..<10, id: \.self) { index in
                BeadView(isCompleted: index < currentBead, isActive: index == currentBead)
                    .onTapGesture {
                        // Action when a bead is tapped (optional, e.g., mark as prayed)
                    }
                if index == 4 { // Our Father bead in the middle
                    //Spacer()
                        //.frame(width: 20)
                }
            }
        }
    }
}

#Preview {
    RosaryDecadeView(decadeNumber: 0, currentBead: 4)
}
