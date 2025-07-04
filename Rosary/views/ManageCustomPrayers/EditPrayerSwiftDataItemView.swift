//
//  EditPrayerSwiftDataItemView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 04/07/2025.
//

import SwiftUI
import SwiftData

struct EditPrayerSwiftDataItemView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Bindable var item: PrayerSwiftDataItem

    @State private var name: String
    @State private var data: String
    @State private var orderIndex: String
    @State private var type: PrayerEnum

    init(item: PrayerSwiftDataItem) {
        self._item = Bindable(wrappedValue: item)
        self._name = State(initialValue: item.name)
        self._data = State(initialValue: item.data)
        self._orderIndex = State(initialValue: String(item.orderIndex))
        self._type = State(initialValue: item.type)
    }

    var body: some View {
        Form {
            
            Section(header: Text("Prayer Info")) {
                TextField("Name", text: $name)

                VStack(alignment: .leading) {
                    Text("Prayer Data")
                        .font(.caption)
                    TextEditor(text: $data)
                        .frame(height: 150)
                }

                TextField("Order Index", text: $orderIndex)
                    .keyboardType(.numberPad)

                Picker("Prayer Type", selection: $type) {
                    ForEach(PrayerEnum.allCases, id: \.self) { currentCase in
                        Text(currentCase.displayName).tag(currentCase)
                    }
                }
            }

            Section {
                Button("Save Changes") {
                    saveChanges()
                }
                .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            }

            Section {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }.foregroundStyle(.red)
            }
        }
        .navigationTitle("Edit Prayer Item")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func saveChanges() {
        item.name = name
        item.data = data
        item.type = type
        if let index = Int(orderIndex) {
            item.orderIndex = index
        }
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("❌ Save failed: \(error)")
        }
    }
}

#Preview {
    EditPrayerSwiftDataItemView(
        item: PrayerSwiftDataItem(name: "Our Father", data: "Our Father", orderIndex: 0)
    ).modelContainer(
        for: [PrayerSwiftDataItem.self, CustomPrayer.self],
        inMemory: true
    ).environmentObject(GlobalSettings())
}
