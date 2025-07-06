//
//  AddCustomRosaryV2.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 30/06/2025.
//

import SwiftUI
import SwiftData

enum ActionType: Int {
    case markSectionAsDecade;
    case deleteSection;
    case setAsBead;
    case removeAsBead;
    case addPrayerToSection
    case deletePrayerFromSection;
    case populateSectionWithDecadePrayer;
}

enum PrayerSectionType: String, Codable, CaseIterable {
    case decade
    case normal
}

struct PrayerSection: Identifiable, Codable {

    var id = UUID()
    var name: String
    var type: PrayerSectionType
    var prayers: [Prayer]

    init(
        id: UUID = UUID(),
        name: String,
        type: PrayerSectionType,
        prayers: [Prayer]
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.prayers = prayers
    }
    
}

extension View {
    func setStyle() -> some View {
        return self.padding(9)
            .background(.gray)
            .cornerRadius(10.0)
            .foregroundStyle(.white)
    }
}

struct AddCustomRosaryV2: View {
    
    @Environment(\.dismiss) private var dismiss;
    @Environment(\.modelContext) private var modelContext;
    @State var prayers: [Prayer] = [];
    @State private var sheetIsPresented: Bool = false
    @State private var sheetPrayerTitleIsPresented = false
    @Query var prayerSwiftDataItems: [PrayerSwiftDataItem]
    
    @State var searchText = ""
    @State public var prayerTitle: String
    
    @State var prayerSections: [PrayerSection]

    init(
        prayerTitle: String,
        prayerSections: [PrayerSection]
    ) {
        self.prayerTitle = prayerTitle
        self.prayerSections = prayerSections
    }
    
    init(prayerTitle: String) {
        self.prayerTitle = prayerTitle
        self.prayerSections = [
            PrayerSection(
                name: "0",
                type: PrayerSectionType.normal,
                prayers: [
                    PrayerData.constructPrayer(
                        PrayerData.signOfTheCross,
                        name: "Sign of the Cross"
                    )
                ]
            )
        ]
    }
    
    func decade() -> [Prayer] {
        
        var decadePrayers: [Prayer] = []
        
        decadePrayers += [
            PrayerData.ourFatherPrayer(.bead)
        ]
        
        for _ in 0..<10 {
            decadePrayers += [
                PrayerData.hailMaryPrayer(.bead),
            ]
        }
        decadePrayers += [
            PrayerData.gloryBePrayer()
        ]
        
        return decadePrayers
        
    }
        
    var body: some View {
        
        NavigationView {
            ScrollView {
                
                ForEach(prayerSections.indices.filter {
                    searchText.isEmpty || prayerSections[$0].name.lowercased().contains(searchText.lowercased())
                }, id: \.self) { index in
                    PrayerSectionView(
                        section: $prayerSections[index],
                        prayers: $prayers,
                        action: action
                    )
                    Divider()
                }
                
                HStack {
                    Button("Add new section") {
                        prayerSections += [
                            PrayerSection(
                                name: "New section",
                                type: PrayerSectionType.normal,
                                prayers: []
                            )
                        ]
                    }.setStyle()
                    Button("Add new decade section") {
                        prayerSections += [
                            PrayerSection(
                                name: "New decade",
                                type: PrayerSectionType.decade,
                                prayers: decade()
                            )
                        ]
                    }.setStyle()
                    Spacer()
                }.padding(.top)
                
            }
            .padding(.horizontal)
            .searchable(text: $searchText)
            .onAppear {
                prayers = PrayerData.loadPrayers(using: modelContext)
            }
            .toolbar {
                
                ToolbarItem(
                    placement: ToolbarItemPlacement.topBarLeading) {
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.left")
                            }
                            Text(prayerTitle)
                        }
                    }

                ToolbarItem(
                    placement: ToolbarItemPlacement.topBarTrailing,
                    content: {
                        SaveButtonToolBar(
                            sections: $prayerSections,
                            title: $prayerTitle
                        )
                    }
                )
            }

        }
        .toolbar(.hidden, for: .tabBar)
    }
    
    func action(
        _ section: PrayerSection,
        _ prayer: Prayer?,
        _ actionType: ActionType
    ) {

        switch actionType {
            
        case .markSectionAsDecade:
            
            prayerSections = prayerSections.map({ PrayerSection in
                
                var p = PrayerSection
                
                if PrayerSection.id == section.id {
                    p.type = .decade
                    return p
                }
                
                return PrayerSection
            })
            break;

        case .deleteSection:
            
            prayerSections.removeAll { PrayerSection in
                PrayerSection.id == section.id
            }
            break;

        case .setAsBead:
            
            prayerSections = prayerSections.map({ PrayerSection in
                
                var p = PrayerSection
                
                if p.id == section.id {
                    
                    p.prayers = p.prayers.map({ Prayer in
                        
                        var foundPrayer = Prayer
                        
                        if foundPrayer.id == prayer?.id {
                            
                            foundPrayer.type = .bead
                        }
                        
                        return foundPrayer
                        
                    })
                    
                    return p
                }
                
                return p
                
            })
            
            break;
            
        case .removeAsBead:
            
            prayerSections = prayerSections.map({ PrayerSection in
                
                var p = PrayerSection
                
                if p.id == section.id {
                    
                    p.prayers = p.prayers.map({ Prayer in
                        
                        var foundPrayer = Prayer
                        
                        if foundPrayer.id == prayer?.id {
                            
                            foundPrayer.type = .single
                        }
                        
                        return foundPrayer
                        
                    })
                    
                    return p
                }
                
                return p
                
            })
            break;

        case .addPrayerToSection:
            
            if let _prayer = prayer {
                
                prayerSections = prayerSections.map({ PrayerSection in
                    
                    var p = PrayerSection
                    
                    if p.id == section.id {
                        
                        p.prayers += [_prayer]
                        
                        return p
                    }
                    
                    return p
                    
                })

            }
            break;

        case .deletePrayerFromSection:
            
            var found = prayerSections.first { PrayerSection in
                PrayerSection.id == section.id
            }
            
            found?.prayers.removeAll(where: { Prayer in
                Prayer.id == prayer?.id
            })
            break;

        case .populateSectionWithDecadePrayer:
            
            prayerSections = prayerSections.map({ PrayerSection in
                
                var p = PrayerSection
                
                if p.id == section.id {
                    
                    p.prayers += decade()
                    
                    return p
                }
                
                return p
                
            })

            break;

        }
    }
    
}

struct PrayerSectionView: View {
    
    @Binding var section: PrayerSection
    @Environment(\.modelContext) private var modelContext;
    @State var showSheet = false
    @State var currentSection: PrayerSection? = nil

    @Binding var prayers: [Prayer]
    var action: (
        _ section: PrayerSection,
        _ prayer: Prayer?,
        _ type: ActionType
    ) -> Void;
    
    var body: some View {
        Group {
            
            VStack(alignment: .leading) {
                
                VStack(alignment: .leading) {
                    
                    HStack {
                        Text(section.name)
                        Spacer()
                        HStack {
                            
                            if section.type != .decade {
                                Button("Mark as decade") {
                                    action(section, nil, .markSectionAsDecade)
                                }
                            }
                            
                            Button("Delete") {
                                action(section, nil, .deleteSection)
                            }

                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(3))
                    Divider()

                    ForEach(section.prayers) { _prayer in
                        SectionPrayerItemView(
                            prayer: _prayer,
                            section: section,
                            action: { PrayerSection, Prayer, ActionType in
                                action(PrayerSection, Prayer, ActionType)
                            }
                        )
                    }
                    
                    
                }.frame(maxWidth: .infinity)
                    .border(Color.black, width: 1)
                
                HStack {
                    Button("Add prayer +") {
                        currentSection = section
                        showSheet.toggle()
                    }.setStyle()
                        
                    Button("Populate with decade") {
                        action(section, nil, .populateSectionWithDecadePrayer)
                    }.setStyle()
                }
            }
            
                        
        }.sheet(isPresented: $showSheet, onDismiss: {
            currentSection = nil
        }) {
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showSheet.toggle()
                        currentSection = nil
                    } label: {
                        Text("Done")
                    }
                }.padding()
                
                List {
                    ForEach(prayers) { prayer in
                        Button {
                            if currentSection != nil {
                                action(currentSection!, prayer, .addPrayerToSection)
                            }
                        } label: {
                            Text(prayer.name)
                        }
                    }
                }.listStyle(.plain)
                
                Spacer()

            }
        }
    }
}

struct SectionPrayerItemView: View {

    var prayer: Prayer
    var section: PrayerSection

    var action: (
        _ section: PrayerSection,
        _ prayer: Prayer?,
        _ type: ActionType
    ) -> Void;

    var body: some View {
        
        HStack {
            Text(prayer.name)
            Spacer()
            
            if prayer.type == .bead {
                Button("Remove as Bead") {
                    action(section, prayer, .removeAsBead)
                }
                Image(systemName: "smallcircle.fill.circle.fill")
            }
            
            if prayer.type != .bead {
                Button("Set as Bead") {
                    action(section, prayer, .setAsBead)
                }
            }
            
        }
        .padding(.horizontal)
        .frame(height: 40)
        
        Divider()

    }
}

struct SaveButtonToolBar: View {

    @Environment(\.modelContext) private var modelContext;

    @Binding var sections: [PrayerSection]
    @Binding var title: String;
    
    @State var uuid: UUID?
    
    var body: some View {
        Button {
            save()
        } label: {
            Text("Save")
        }
    }
    
    func save() {
        do {
            let customPrayer: CustomPrayer

            if let id = uuid {
                let existing = try modelContext.fetch(
                    FetchDescriptor<CustomPrayer>(
                        predicate: #Predicate { $0.id == id }
                    )
                ).first

                if let found = existing {
                    // Update existing
                    customPrayer = found
                    customPrayer.prayerSwiftDataItems.removeAll()
                } else {
                    // Create new
                    customPrayer = CustomPrayer(name: title, orderIndex: 0, prayerSwiftDataItems: [])
                    customPrayer.isRosary = true
                    modelContext.insert(customPrayer)
                }
            } else {
                // No UUID, create new
                customPrayer = CustomPrayer(name: title, orderIndex: 0, prayerSwiftDataItems: [])
                customPrayer.isRosary = true
                modelContext.insert(customPrayer)
            }

            // Build prayers
            var prayers: [PrayerSwiftDataItem] = []

            for section in sections {
                for prayer in section.prayers {
                    prayers.append(
                        PrayerSwiftDataItem(
                            name: prayer.name,
                            data: prayer.data,
                            orderIndex: 0,
                            type: prayer.type,
                            sectionId: prayer.sectionId ?? UUID(),
                            customPrayer: customPrayer
                        )
                    )
                }
            }

            customPrayer.prayerSwiftDataItems = prayers
            uuid = customPrayer.id

            try modelContext.save()

        } catch {
            print("❌ Save failed: \(error)")
        }
    }

}

#Preview {
        AddCustomRosaryV2(prayerTitle: "Ten Decades")
}
