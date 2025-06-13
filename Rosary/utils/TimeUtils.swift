//
//  TimeUtils.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 12/06/2025.
//

import Foundation

func formattedToday() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE, MMMM d" // Example: "Monday, June 12"
    formatter.locale = Locale(identifier: "en_US_POSIX") // Ensures consistent formatting

    let dateString = formatter.string(from: Date())
    return dateString.uppercased() // "MONDAY, JUNE 12"
}
