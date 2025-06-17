//
//  RosaryPrem.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 14/06/2025.
//

import SwiftUI

struct RosaryPrem: View {
    
    var currentBead = 0;
    
    var body: some View {
        HStack {
            ForEach(0...4, id: \.self) { index in
                
                if index == 0 || index == 4 {
                    OurFatherBeadView(isCompleted: true, isActive: index == currentBead)
                        .onTapGesture {
                            // Action when a bead is tapped (optional, e.g., mark as prayed)
                        }
                } else {
                    
                    BeadView(isCompleted: true, isActive: index == currentBead)
                        .onTapGesture {
                            // Action when a bead is tapped (optional, e.g., mark as prayed)
                        }
                }
            }
        }
    }
}

#Preview {
    RosaryPrem()
}
