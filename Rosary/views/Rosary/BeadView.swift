//
//  BeadView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 14/06/2025.
//

import SwiftUI

struct BeadView: View {
    let isCompleted: Bool
    let isActive: Bool
    
    @State private var isTapped = false
    
    var body: some View {
        Circle()
            .fill(isCompleted ? Color.green : (isActive ? Color.blue : Color.gray))
            .frame(width: 30, height: 40)
            .overlay(
                Circle().stroke(Color.white, lineWidth: 2)
            )
            .shadow(radius: 5)
            .scaleEffect(isTapped ? 1.4 : (isActive ? 1.2 : 1))
            .animation(.spring(response: 0.3, dampingFraction: 0.4), value: isTapped)
            .onTapGesture {
                isTapped = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    isTapped = false
                }
            }
    }
}

struct OurFatherBeadView: View {
    var isCompleted: Bool
    var isActive: Bool

    @State private var isTapped = false

    var body: some View {
        Circle()
            .fill(isCompleted ? Color.green : (isActive ? Color.blue : Color.gray))
            .frame(width: 40, height: 50)
            .overlay(
                Circle().stroke(Color.white, lineWidth: 2)
            )
            .shadow(radius: 5)
            .scaleEffect(isTapped ? 1.4 : (isActive ? 1.2 : 1))
            .animation(.spring(response: 0.3, dampingFraction: 0.4), value: isTapped)
            .onTapGesture {
                isTapped = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    isTapped = false
                }
            }
    }
}

#Preview {
    BeadView(isCompleted: false, isActive: true)
    BeadView(isCompleted: false, isActive: false)
    BeadView(isCompleted: true, isActive: true)
    OurFatherBeadView(isCompleted: false, isActive: true)
    OurFatherBeadView(isCompleted: true, isActive: true)
}


struct BeadViewV2: View {

    var body: some View {
        Circle()
            //.fill(isCompleted ? Color.green : (isActive ? Color.blue : Color.gray))
            .frame(width: 30, height: 40)
            .overlay(
                Circle().stroke(Color.white, lineWidth: 2)
            )
            .shadow(radius: 5)
            //.scaleEffect(isActive ? 1.2 : 1)  // Make the active bead slightly bigger
            //.animation(.spring(), value: isActive)  // Smooth animation for active beads
    }
}

struct OurFatherBeadViewV2: View {

    var body: some View {
        Circle()
            //.fill(isCompleted ? Color.green : (isActive ? Color.blue : Color.gray))
            .frame(width: 40, height: 50)
            .overlay(
                Circle().stroke(Color.white, lineWidth: 2)
            )
            .shadow(radius: 5)
            //.scaleEffect(isActive ? 1.2 : 1)  // Make the active bead slightly bigger
            //.animation(.spring(), value: isActive)  // Smooth animation for active beads
    }
}

