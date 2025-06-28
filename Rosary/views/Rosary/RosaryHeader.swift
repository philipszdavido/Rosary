//
//  RosaryHeader.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 14/06/2025.
//

import SwiftUI

struct RosaryHeader: View {
    
    @Environment(\.dismiss) var dismiss
    public var prayer: Prayer
    public var rosaryType: RosaryType
    @ObservedObject public var speaker: RosarySpeaker;

    var title: String {
        return "\(prayer.name) - \(RosaryMystery.today())"
    }
    
    var rosaryTypeTitle: String {
        switch rosaryType {
        case .auto:
            return "Auto"
        case .manual:
            return "Manual"
        case .none:
            return ""
        }
    }
    
    var body: some View {
        HStack(alignment: .center) {
            
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
            }
            
            Spacer()

            Text("\(speaker.bead < 0 ? 0 : speaker.bead)")
                .padding(.horizontal, 10)
                .padding(.vertical, 3)
                .foregroundStyle(.white)
                .background(Color.blue)
                .cornerRadius(10.0)
                .font(.caption)

            Text(title)
                .font(
                    Font?.init(
                        .system(
                            size: 20,
                            weight: .regular,
                            design: .default
                        )
                    )
                )
            
            Spacer()
                        
        }.padding(.horizontal)
        Divider()
    }
}

#Preview {
    RosaryHeader(
        prayer: Prayer(name: "Test", type: .rosary, data: ""),
        rosaryType: RosaryType.auto,
        speaker: RosarySpeaker()
    )
}
