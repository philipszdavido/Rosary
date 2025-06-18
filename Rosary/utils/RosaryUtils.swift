//
//  RosaryUtils.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 13/06/2025.
//

import Foundation

class RosaryUtils {
    
    public func constructRosary(decade: Int = 5) -> [Prayer] {

        var prayerSequence: [Prayer] = []

        // Starting the Rosary:
        prayerSequence += [
            
            Prayer(name: "Sign Of The Cross", type: PrayerEnum.single, data: PrayerData.signOfTheCross),
            
            PrayerData.constructPrayer(PrayerData.apostlesCreed, name: "Apostles Creed"),
            
            PrayerData.ourFatherPrayer
        ]
        
        for _ in 0..<3 {
            prayerSequence += [
                PrayerData.hailMaryPrayer,
            ]
        }
        
        prayerSequence += [
            PrayerData.gloryBePrayer
        ];
        
        //  Praying Each Decade:
        // say mystery
        let mystery = RosaryMystery.mystery()
        
        for index in 0..<decade {
            
            prayerSequence += [
                Prayer(
                    name: "",
                    type: PrayerEnum.single,
                    data: RosaryMystery.mysteryTitle(index: index)
                ),
                Prayer( name: mystery[index], type: PrayerEnum.single, data: mystery[index]),
            ]
            
            prayerSequence += [
                PrayerData.ourFatherPrayer
            ]
            
            for _ in 0..<10 {
                prayerSequence += [
                    PrayerData.hailMaryPrayer,
                ]
            }
            prayerSequence += [
                PrayerData.gloryBePrayer
            ]
        }
                
        // End of the Rosary:
        prayerSequence += [
            PrayerData.gloryBePrayer,
            PrayerData.constructPrayer(PrayerData.fatima, name: "Fatima")
        ];
        
        return prayerSequence;

    }
}
