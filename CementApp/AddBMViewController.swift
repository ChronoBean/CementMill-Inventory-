//
//  AddBMViewController.swift
//  CementApp
//
//  Created by Benjamin Rush on 11/26/24.
//

import UIKit
import Foundation
import SwiftUI

class AddBMViewController: UIViewController {
    
    @IBOutlet weak var CentreDistance: UITextField!
    @IBOutlet weak var EffectiveDiameter: UITextField!
    @IBOutlet weak var GrindingMediaWeight: UITextField!
    @IBOutlet weak var TorqueFactor: UITextField!
    @IBOutlet weak var Speed: UITextField!
    @IBOutlet weak var PercentMotorEfficiency: UITextField!
    @IBOutlet weak var PercentGearboxEfficiency: UITextField!
    @IBOutlet weak var OldProductionRate: UITextField!
    @IBOutlet weak var OldBlaine: UITextField!
    @IBOutlet weak var NewBlaine: UITextField!
    @IBOutlet weak var PercentOldResidue: UITextField!
    @IBOutlet weak var PercentNewResidue: UITextField!
    @IBOutlet weak var TargetSO3Content: UITextField!
    @IBOutlet weak var PercentGypsumPurity: UITextField!
    @IBOutlet weak var PecentSO3ContentInClinker: UITextField!
    @IBOutlet weak var PercentFreeMoistureInGypsum: UITextField!
    @IBOutlet weak var FeedSize: UITextField!
    @IBOutlet weak var SpecificWeightOfFeedMaterial: UITextField!
    @IBOutlet weak var BondsWorkIndex: UITextField!
    @IBOutlet weak var SpeedasCriticalPercent: UITextField!
    @IBOutlet weak var FreeHeight: UITextField!
    @IBOutlet weak var FreshFeedRate: UITextField!
    @IBOutlet weak var CoarseReturn: UITextField!
    @IBOutlet weak var PercentResidueOfCoarseReturn: UITextField!
    @IBOutlet weak var PercentResidueofFines: UITextField!
    @IBOutlet weak var PercentResidueOfSeparatorFeed: UITextField!
    @IBOutlet weak var CirculationFactor: UITextField!
    @IBOutlet weak var PercentResidueOfFreshFeed: UITextField!
    @IBOutlet weak var NewSpecificPower: UITextField!
    @IBOutlet weak var OldSpecificPower: UITextField!
    @IBOutlet weak var ExponentForClose: UITextField!
    @IBOutlet weak var millName: UITextField!
    
    @IBOutlet weak var listofmillsNAME: UILabel!
    
    var millNames: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedMills = UserDefaults.standard.array(forKey: "millNames") as? [String] {
            millNames = savedMills
        } else {
            // Default test data if no mills are saved
            millNames = []
        }

        // If on the "Current Mills Page," update the label
        if navigationItem.title == "Current Mills Page" {
            listofmillsNAME.text = millNames.joined(separator: ", ")
        }
        // Do any additional setup after loading the view
    }
    
    @IBAction func addBMPressed(_ sender: UIButton) {
        // Ensure the text field has a value
                guard let name = millName.text, !name.isEmpty else {
                    print("millName is empty or nil")
                    return
                }

                // Add the mill name to the list
                millNames.append(name)
                print("Added \(name) to millNames: \(millNames)")

                // Save the updated list to UserDefaults
                UserDefaults.standard.set(millNames, forKey: "millNames")

                // Clear the input field
                millName.text = ""
    }

    @IBAction func updateBMPressed(_ sender: UIButton) {
        print("updateBMPressed was triggered")
                print("Current millNames: \(millNames)")

                // Update the label directly from the saved list
                DispatchQueue.main.async {
                    self.listofmillsNAME.text = self.millNames.joined(separator: ", ")
                }
    }
    
}
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

