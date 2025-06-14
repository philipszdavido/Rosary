//
//  FullRosaryView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 14/06/2025.
//

import Foundation
import SwiftUI

struct FullRosaryView: View {
    @State private var currentBead = 0
    let totalBeads = 59  // 1 start bead + 5 decades of 10 beads each (50) + 4 Our Father beads

    var body: some View {
        VStack(spacing: 20) {
            Text("Rosary - \(currentBead)/\(totalBeads) beads")
                .font(.title)
                .padding()

            VStack {
                RosaryDecadeView(decadeNumber: 1, currentBead: currentBead)
                RosaryDecadeView(decadeNumber: 2, currentBead: currentBead)
                RosaryDecadeView(decadeNumber: 3, currentBead: currentBead)
                RosaryDecadeView(decadeNumber: 4, currentBead: currentBead)
                RosaryDecadeView(decadeNumber: 5, currentBead: currentBead)
            }
            
            HStack {
                Button("Previous") {
                    if currentBead > 0 {
                        currentBead -= 1
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                Spacer()

                Button("Next") {
                    if currentBead < totalBeads {
                        currentBead += 1
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
}
