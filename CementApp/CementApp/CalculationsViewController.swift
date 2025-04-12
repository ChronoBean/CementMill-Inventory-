//
//  CalculationsViewController.swift
//  CementApp
//
//  Created by Benjamin Rush on 12/13/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class CalculationsViewController: UIViewController {

    @IBOutlet weak var armOfGravity: UILabel!
    @IBOutlet weak var torqueFactorMatrix: UILabel!
    @IBOutlet weak var netPowerConsumption: UILabel!
    @IBOutlet weak var grossPowerConsumption: UILabel!
    @IBOutlet weak var newProductionRate: UILabel!
    @IBOutlet weak var gypsumSetPoint: UILabel!
    @IBOutlet weak var maximumBallSize: UILabel!
    @IBOutlet weak var percentFilling: UILabel!
    @IBOutlet weak var circulationFactor: UILabel!
    @IBOutlet weak var circulationLoad: UILabel!
    @IBOutlet weak var separatorEfficiency: UILabel!
    @IBOutlet weak var criticalSpeed: UILabel!
    @IBOutlet weak var newSpecifcPowerConsumption: UILabel!
    
    var mills: [Mill] = []
    
    @IBOutlet weak var millNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadCalculationsFromFirestore()
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
            // Retrieve mill name from the text field
            guard let millName = millNameTextField.text, !millName.isEmpty else {
                return
            }

            // Find the mill with the matching name
            guard let selectedMill = mills.first(where: { $0.millName == millName }) else {
                return
            }

            // Perform calculations and update labels
            updateCalculations(for: selectedMill)
        }
        
        func updateCalculations(for mill: Mill) {
            armOfGravity.text = "Arm of Gravity: \(calculateArmOfGravity(mill: mill))"
            torqueFactorMatrix.text = "Torque Factor Matrix: \(calculateTorqueFactorMatrix(mill: mill))"
            netPowerConsumption.text = "Net Power Consumption: \(calculateNetPowerConsumption(mill: mill))"
            grossPowerConsumption.text = "Gross Power Consumption: \(calculateGrossPowerConsumption(mill: mill))"
            newProductionRate.text = "New Production Rate: \(calculateNewProductionRate(mill: mill))"
            gypsumSetPoint.text = "Gypsum Set Point: \(calculateGypsumSetPoint(mill: mill))"
            maximumBallSize.text = "Maximum Ball Size: \(calculateMaximumBallSize(mill: mill))"
            percentFilling.text = "Percent Filling: \(calculatePercentFilling(mill: mill))"
            circulationFactor.text = "Circulation Factor: \(calculateCirculationFactor(mill: mill))"
            circulationLoad.text = "Circulation Load: \(calculateCirculationLoad(mill: mill))"
            separatorEfficiency.text = "Separator Efficiency: \(calculateSeparatorEfficiency(mill: mill))"
            criticalSpeed.text = "Critical Speed: \(calculateCriticalSpeed(mill: mill))"
            newSpecifcPowerConsumption.text = "New Specific Power Consumption: \(calculateNewSpecificPowerConsumption(mill: mill))"
        }
    

        // Function to handle error state
        func setLabelsToError(message: String) {
            armOfGravity.text = message
            torqueFactorMatrix.text = message
            netPowerConsumption.text = message
            grossPowerConsumption.text = message
            newProductionRate.text = message
            gypsumSetPoint.text = message
            maximumBallSize.text = message
            percentFilling.text = message
            circulationFactor.text = message
            circulationLoad.text = message
            separatorEfficiency.text = message
            criticalSpeed.text = message
            newSpecifcPowerConsumption.text = message
        }
    
    func performCalculations() {
        // Perform your calculations (replace with actual calculations)
        let calculationsData: [String: Any] = [
            "armOfGravity": 0.578,
            "netPowerConsumption": 2538,
            "grossPowerConsumption": 2715,
            "newProductionRate": 88,
            "gypsumSetPoint": 4.52,
            "maximumBallSize": 90,
            "percentFilling": 37.3,
            "circulationFactor": 2.48,
            "circulationLoad": 148,
            "separatorEfficiency": 68.8,
            "criticalSpeed": 20.8,
            "newSpecificPowerConsumption": 43.44
        ]

        // Update UI (e.g., labels) with the calculated data
        armOfGravity.text = "Arm of Gravity: \(calculationsData["armOfGravity"] ?? 0)"
        netPowerConsumption.text = "Net Power Consumption: \(calculationsData["netPowerConsumption"] ?? 0)"
        // ... update other labels similarly

        // Save calculations to Firestore
        saveCalculationsToFirestore(calculatedData: calculationsData)
    }
    
    @IBAction func calculatePressed2(_ sender: UIButton) {
        performCalculations()
    }

    func loadCalculationsFromFirestore() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userID)

        userRef.getDocument { document, error in
            if let error = error {
                print("Error fetching calculations: \(error.localizedDescription)")
                return
            }

            if let document = document, document.exists {
                let data = document.data()?["calculations"] as? [String: Any] ?? [:]

                // Populate labels with fetched data
                self.armOfGravity.text = "Arm of Gravity: \(data["armOfGravity"] ?? 0)"
                self.netPowerConsumption.text = "Net Power Consumption: \(data["netPowerConsumption"] ?? 0)"
                // ... update other labels similarly
            } else {
                print("Calculations document does not exist")
            }
        }
    }


        
        // MARK: - Calculation Functions
        func calculateArmOfGravity(mill: Mill) -> Double {
            let R = mill.centreDistance / mill.effectiveDiameter
            return 0.666 * pow((1 - 4 * pow(R, 2)), 1.5)
        }

        func calculateTorqueFactorMatrix(mill: Mill) -> Double {
            // Placeholder for torque factor calculation
            return 0.0
        }

        func calculateNetPowerConsumption(mill: Mill) -> Double {
            return 0.514 * mill.grindingMediaWeight * mill.torqueFactor * mill.speed * mill.effectiveDiameter * calculateArmOfGravity(mill: mill)
        }

        func calculateGrossPowerConsumption(mill: Mill) -> Double {
            let netPower = calculateNetPowerConsumption(mill: mill)
            return netPower * 100 / (mill.percentMotorEfficiency * mill.percentGearboxEfficiency)
        }

        func calculateNewProductionRate(mill: Mill) -> Double {
            return mill.oldProductionRate * pow((mill.oldBlaine / mill.newBlaine), 1.3)
        }

        func calculateGypsumSetPoint(mill: Mill) -> Double {
            return 21500 * (mill.targetSO3Content - mill.percentSO3ContentInClinker) / (mill.percentGypsumPurity * (100 - mill.percentFreeMoistureInGypsum))
        }

        func calculateMaximumBallSize(mill: Mill) -> Double {
            return 36 * sqrt(mill.feedSize) * pow((mill.specificWeightOfFeedMaterial * mill.bondsWorkIndex) / (mill.speed * sqrt(mill.effectiveDiameter)), 1/3.0)
        }

        func calculatePercentFilling(mill: Mill) -> Double {
            return 112.5 - (125 * mill.freeHeight / mill.effectiveDiameter)
        }

        func calculateCirculationFactor(mill: Mill) -> Double {
            return (mill.freshFeedRate + mill.coarseReturn) / mill.freshFeedRate
        }

        func calculateCirculationLoad(mill: Mill) -> Double {
            return (calculateCirculationFactor(mill: mill) - 1) * 100
        }

        func calculateSeparatorEfficiency(mill: Mill) -> Double {
            // Placeholder for separator efficiency calculation
            return 0.0
        }

        func calculateCriticalSpeed(mill: Mill) -> Double {
            return 42.3 / sqrt(mill.effectiveDiameter)
        }

        func calculateNewSpecificPowerConsumption(mill: Mill) -> Double {
            let exponent = 1.3
            return mill.oldSpecificPower * pow((mill.newBlaine / mill.oldBlaine), exponent)
        }
    
    func saveCalculationsToFirestore(calculatedData: [String: Any]) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userID)

        // Save calculations data to Firestore
        userRef.setData(["calculations": calculatedData], merge: true) { error in
            if let error = error {
                print("Error saving calculations: \(error.localizedDescription)")
            } else {
                print("Calculations saved successfully!")
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

}
