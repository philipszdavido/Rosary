//
//  AddCustomSinglePrayer.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 22/06/2025.
//

import SwiftUI
import SwiftData

struct AddCustomSinglePrayer: View {
    
    public var prayerTitle: String;
    @State private var inputText: String = ""
    @State private var selection: TextSelection? = nil
    @State private var wordCount: Int = 0
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var uuid: UUID?

    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                VStack {
                    TextEditor(text: $inputText)
                        .font(.body)
                        .padding(.horizontal)
                        .padding(.top, 50)
                        .onChange(of: inputText) { value in
                            wordCount = inputText.count
                        }
                        .background(Color(.systemGray6))
                }
                
                HStack {
                    Text("Enter your prayer")
                        .font(.headline)
                    Spacer()
                    Text("\(wordCount) words")
                        .font(.headline)
                }.padding(.top, 20)
                    .padding(.horizontal)
            }
        }
            .toolbar {
                ToolbarItem(
                    
                    placement: ToolbarItemPlacement.topBarLeading) {
                        HStack {
                            Text(prayerTitle)
                        }
                    }
                
                ToolbarItem(
                    placement: ToolbarItemPlacement.topBarTrailing) {
                        
                        Button("Done") {
                            guard !prayerTitle.trimmingCharacters(in: .whitespaces).isEmpty,
                                  !inputText.trimmingCharacters(in: .whitespaces).isEmpty else {
                                print("Title or data is empty")
                                return
                            }

                            do {
                                
                                let existing = try modelContext.fetch(
                                    FetchDescriptor<PrayerSwiftDataItem>(
                                        predicate: #Predicate { $0.id == uuid! }
                                    )
                                )

                                guard existing.isEmpty else {
                                    print("Prayer with title already exists")
                                    return
                                }

                                let prayerToSave = PrayerSwiftDataItem(
                                    name: prayerTitle,
                                    data: inputText,
                                    orderIndex: 0
                                )
                                
                                uuid = prayerToSave.id
                                
                                modelContext.insert(prayerToSave)
                                try modelContext.save()

                                withAnimation {
                                    dismiss()
                                }

                            } catch {
                                print("❌ Error saving single prayer: \(error.localizedDescription)")
                            }
                        }.disabled(inputText.count == 0)
                        
                    }
            }
        

        
    }
}

#Preview {
    NavigationView {
        AddCustomSinglePrayer(prayerTitle: "Single prayer")
    }
}
