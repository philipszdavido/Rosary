//
//  AddCustomSinglePrayer.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 22/06/2025.
//

import SwiftUI

struct AddCustomSinglePrayer: View {
    
    public var prayerTitle: String;
    @State private var inputText: String = ""
    @State private var selection: TextSelection? = nil
    @State private var wordCount: Int = 0

    var body: some View {
        VStack {
//            Text("Prayer Data")
            ZStack(alignment: .topTrailing) {
                VStack {
                    TextEditor(text: $inputText)
                        .font(.body)
                        .padding()
                        .padding(.top, 20)
                        .onChange(of: inputText) { value in
                            
                        }
                        .background(Color(.systemGray6))
                }
                
                HStack {
                    Text("Enter your prayer")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.trailing)
                    Spacer()
                    Text("\(wordCount) words")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.trailing)
                }
            }
        }
            .toolbar {
                ToolbarItem(
                    
                    placement: ToolbarItemPlacement.topBarLeading) {
                        Text(prayerTitle)
                    }
                
                ToolbarItem(
                    placement: ToolbarItemPlacement.topBarTrailing) {
                        Button("Done") {
                            
                        }
                    }
            }
        

        
    }
}

#Preview {
    AddCustomSinglePrayer(prayerTitle: "Single prayer")
}

#Preview {
    TextE()
}

struct TextE: View {

    @State private var inputText: String = ""

    var body: some View {
        VStack {
            //Text("Prayer Data")
            TextEditor(text: $inputText)
                .font(.body)
                .padding()
                //.padding(.top, 20)
                .onChange(of: inputText) { value in
                    
                }
                .background(Color(.systemGray6))
        }.toolbar {
            ToolbarItem(
                placement: ToolbarItemPlacement.topBarTrailing) {
                    Button("Done") {
                        
                    }
                }
        }

    }
}
