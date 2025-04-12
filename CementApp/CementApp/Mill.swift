//
//  Mill.swift
//  CementApp
//
//  Created by Benjamin Rush on 12/11/24.
//

import Foundation

// Mill Class
struct Mill {
    let centreDistance: Double
    let effectiveDiameter: Double
    let grindingMediaWeight: Double
    let torqueFactor: Double
    let speed: Double
    let percentMotorEfficiency: Double
    let percentGearboxEfficiency: Double
    let oldProductionRate: Double
    let oldBlaine: Double
    let newBlaine: Double
    let percentOldResidue: Double
    let percentNewResidue: Double
    let targetSO3Content: Double
    let percentGypsumPurity: Double
    let percentSO3ContentInClinker: Double
    let percentFreeMoistureInGypsum: Double
    let feedSize: Double
    let specificWeightOfFeedMaterial: Double
    let bondsWorkIndex: Double
    let speedAsCriticalPercent: Double
    let freeHeight: Double
    let freshFeedRate: Double
    let coarseReturn: Double
    let percentResidueOfCoarseReturn: Double
    let percentResidueOfFines: Double
    let percentResidueOfSeparatorFeed: Double
    let circulationFactor: Double
    let percentResidueOfFreshFeed: Double
    let newSpecificPower: Double
    let oldSpecificPower: Double
    let exponentForClose: Double
    let millName: String
}

var mills: [Mill] = []
