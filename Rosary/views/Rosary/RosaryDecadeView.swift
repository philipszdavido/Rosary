//
//  RosaryDecadeView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 14/06/2025.
//

import SwiftUI

struct RosaryDecadeViewV2: View {
    
    private let beads = 59;
    
    private func isOurFather(index: Int) -> Bool {
        if index == 0 || index == 4 { return true };
        return true
    }
    
    var body: some View {
        HStack {
            ForEach(0..<10, id: \.self) { index in

                if isOurFather(index: index) {
                    
                    OurFatherBeadViewV2()
                        .onTapGesture {
                        }
                    
                } else {
                    
                    BeadViewV2()
                        .onTapGesture {
                        }
                    
                }
            }
        }
    }
}

struct RosaryBeadView: View {
    let beadCount: Int
    let radius: CGFloat
    let beadSize: CGFloat
    let highlightIndex: Int?
    let sideLength: CGFloat = 300;
    
    var body: some View {

            
            ZStack {
                GeometryReader {geometry in
                    ForEach(0..<beadCount, id: \.self) { i in
                        Circle()
                            .fill(i == highlightIndex ? Color.orange : Color.gray.opacity(0.7))
                            .frame(width: beadSize, height: beadSize)
                            .position(self.positionForBead2(index: i))
                    }
                }
            }
            .frame(width: radius * 2 + beadSize, height: radius * 2 + beadSize)
            .background(Color.green.opacity(0.1))
        
        
    }

    func positionForBead(index: Int) -> CGPoint {
        let angle = 2 * .pi / CGFloat(beadCount) * CGFloat(index)
        let x = radius * cos(angle) + radius + beadSize / 2
        let y = radius * sin(angle) + radius + beadSize / 2
        return CGPoint(x: x, y: y)
    }
    
    func positionForBeadSquare(index: Int) -> CGPoint {
            let beadsPerSide = beadCount / 4
            let spacing = (sideLength - beadSize) / CGFloat(beadsPerSide)

            if index < beadsPerSide {
                // Top
                return CGPoint(x: CGFloat(index) * spacing + beadSize / 2, y: beadSize / 2)
            } else if index < beadsPerSide * 2 {
                // Right
                let i = index - beadsPerSide
                return CGPoint(x: sideLength - beadSize / 2, y: CGFloat(i) * spacing + beadSize / 2)
            } else if index < beadsPerSide * 3 {
                // Bottom
                let i = index - beadsPerSide * 2
                return CGPoint(x: sideLength - CGFloat(i) * spacing - beadSize / 2, y: sideLength - beadSize / 2)
            } else {
                // Left
                let i = index - beadsPerSide * 3
                return CGPoint(x: beadSize / 2, y: sideLength - CGFloat(i) * spacing - beadSize / 2)
            }
        }
    
    func positionForBead2(index: Int) -> CGPoint {
        
        if index >= 0 && index <= (4 + 11) {
            return CGPoint(
                x: 0,
                y: CGFloat(index) * CGFloat(beadSize) * 1.1
            )
        }
        
        if index >= (4 + 11) && index <= (4 + 11 + 16) {
            let y = CGFloat(4 + 11) * CGFloat(beadSize) * 1.1
            return CGPoint(
                x: CGFloat(index - (4 + 11)) * CGFloat(beadSize) * 1.1,
                y: y
            )
        }
        
        return CGPoint(
            x: 0,
            y: CGFloat(index) * CGFloat(beadSize) * 1.1
        )
        
    }
}

struct ContentViewP: View {
    @State private var currentBead = 0
    let totalBeads = 59

    var body: some View {
        VStack {
            RosaryBeadView(
                beadCount: totalBeads,
                radius: 170,
                beadSize: 20,
                highlightIndex: currentBead
            )

            Spacer()

            Button("Next Bead") {
                currentBead = (currentBead + 1) % totalBeads
            }
            .padding()
        }
    }
}


#Preview {
    ContentViewP()
}
