//
//  BeadView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 14/06/2025.
//

import SwiftUI

struct BeadView: View {
    var isCompleted: Bool
    var isActive: Bool

    var body: some View {
        Circle()
            .fill(isCompleted ? Color.green : (isActive ? Color.blue : Color.gray))
            .frame(width: 30, height: 40)
            .overlay(
                Circle().stroke(Color.white, lineWidth: 2)
            )
            .shadow(radius: 5)
            .scaleEffect(isActive ? 1.2 : 1)  // Make the active bead slightly bigger
            .animation(.spring(), value: isActive)  // Smooth animation for active beads
    }
}

struct OurFatherBeadView: View {
    var isCompleted: Bool
    var isActive: Bool

    var body: some View {
        Circle()
            .fill(isCompleted ? Color.green : (isActive ? Color.blue : Color.gray))
            .frame(width: 40, height: 50)
            .overlay(
                Circle().stroke(Color.white, lineWidth: 2)
            )
            .shadow(radius: 5)
            .scaleEffect(isActive ? 1.2 : 1)  // Make the active bead slightly bigger
            .animation(.spring(), value: isActive)  // Smooth animation for active beads
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
