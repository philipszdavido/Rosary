//
//  EditCustomPrayerView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 04/07/2025.
//

import SwiftUI
import SwiftData

struct EditCustomPrayerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var name: String
    @Bindable var customPrayer: CustomPrayer

    init(customPrayer: CustomPrayer) {
        self._customPrayer = Bindable(wrappedValue: customPrayer)
        self._name = State(initialValue: customPrayer.name)
    }

    var body: some View {
        Form {
            Section(header: Text("Prayer Title")) {
                TextField("Prayer Name", text: $name)
                Toggle(isOn: Binding<Bool>(
                    get: { customPrayer.isRosary },
                    set: { customPrayer.isRosary = $0 }
                )) {
                    Text("Is Rosary")
                }
            }

            Section {
                Button("Save Changes") {
                    saveChanges()
                }
                .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            }

            Section {
                
                Button("Delete All Prayers") {
                    deleteAllPrayers()
                }.foregroundStyle(.red)
                
                Button("Cancel", role: .cancel) {
                    dismiss()
                }.foregroundStyle(.red)
            }
        }
        .navigationTitle("Edit Prayer")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func saveChanges() {
        customPrayer.name = name
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("❌ Failed to save: \(error)")
        }
    }
    
    func deleteAllPrayers() {
        customPrayer.prayerSwiftDataItems = []
        do {
            try modelContext.save()
        } catch {
            print("❌ Failed to save: \(error)")
        }
    }
}

#Preview {
    EditCustomPrayerView(
        customPrayer:
            
            CustomPrayer(
                name: "",
                orderIndex: 0,
                prayerSwiftDataItems: []
            )
        
    )
}
