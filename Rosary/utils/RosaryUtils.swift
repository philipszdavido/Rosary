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
            
            PrayerData.constructPrayer(PrayerData.apostlesCreed, name: ""),
            
            Prayer(
            name: "Our Father",
            type: PrayerEnum.single,
            data: PrayerData.ourFather)
        ]
        
        for _ in 0..<3 {
            prayerSequence += [
                PrayerData.constructPrayer(PrayerData.hailMary, name: "Hail Mary"),
            ]
        }
        
        prayerSequence += [
            PrayerData.constructPrayer(PrayerData.gloryBe, name: "Glory Be")
        ];
        
        //  Praying Each Decade:
        // say mystery
        let mystery = RosaryMystery.mystery()
        
        for index in 0..<decade {
            prayerSequence += [
                Prayer( name: mystery[index], type: PrayerEnum.single, data: mystery[index]),
            ]
            prayerSequence += [
                Prayer(
                    name: "Our Father",
                    type: PrayerEnum.single,
                    data: PrayerData.ourFather)
            ]
            
            for _ in 0..<10 {
                prayerSequence += [
                    PrayerData.constructPrayer(PrayerData.hailMary, name: "Hail Mary"),
                ]
            }
            prayerSequence += [
                PrayerData.constructPrayer(PrayerData.gloryBe, name: "Glory Be"),
            ]
        }
                
        // End of the Rosary:
        prayerSequence += [
            PrayerData.constructPrayer(PrayerData.gloryBe, name: "Glory Be"),
            PrayerData.constructPrayer(PrayerData.fatima, name: "Fatima")
        ];
        
        return prayerSequence;

    }
}
