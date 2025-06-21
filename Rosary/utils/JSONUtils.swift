//
//  JSONUtils.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 21/06/2025.
//

import Foundation

func getDocumentsDirectory() -> URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
}

func savePrayers(_ prayers: [Prayer]) {
    let url = getDocumentsDirectory().appendingPathComponent("prayers.json")

    do {
        let data = try JSONEncoder().encode(prayers)
        try data.write(to: url)
        print("Saved to: \(url)")
    } catch {
        print("Failed to save: \(error)")
    }
}

func loadPrayers() -> [Prayer] {

    let url = getDocumentsDirectory().appendingPathComponent("prayers.json")
    
    print(url, getDocumentsDirectory().pathComponents)

    guard FileManager.default.fileExists(atPath: url.path) else {
        print("File not found")
        return []
    }

    do {
        let data = try Data(contentsOf: url)
        let prayers = try JSONDecoder().decode([Prayer].self, from: data)
        return prayers
    } catch {
        print("Failed to load: \(error)")
        return []
    }
}

func decode(_ file: String) -> [Prayer] {
    guard let url = Bundle.main.url(forResource: file, withExtension: nil) else {
        fatalError("Faliled to locate \(file) in bundle")
    }
    
    guard let data = try? Data(contentsOf: url) else {
        fatalError("Failed to load file from \(file) from bundle")
    }
    
    let decoder = JSONDecoder()
    
    guard let loadedFile = try? decoder.decode([Prayer].self, from: data) else {
        fatalError("Failed to decode \(file) from bundle")
    }
    
    return loadedFile
}

