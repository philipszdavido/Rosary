//
//  EmptyUIView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 04/07/2025.
//

import SwiftUI

struct EmptyUIView: View {
    var body: some View {
        Group {
            HStack(alignment: .center) {
                Spacer()
                VStack(alignment: .center) {
                    Image(systemName: "cup.and.saucer")
                        .font(.largeTitle)
                        .foregroundStyle(.gray)
                    Text("Empty")
                        .fontDesign(.rounded)
                        .foregroundStyle(.gray)
                }
                Spacer()
            }
            .padding(.top)
        }    }
}

#Preview {
    EmptyUIView()
}
