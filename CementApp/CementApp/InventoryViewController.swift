//
//  InventoryViewController.swift
//  CementApp
//
//  Created by Benjamin Rush on 12/12/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import MessageUI
import CoreXLSX

class InventoryViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    //Inventory
    @IBOutlet weak var num10kSteelBalls: UITextField!
    @IBOutlet weak var num20kSteelBalls: UITextField!
    @IBOutlet weak var num30kSteelBalls: UITextField!
    @IBOutlet weak var percentLinerLeft: UITextField!
    @IBOutlet weak var lubricantQuantity: UITextField!
    @IBOutlet weak var targetProductionRate: UITextField!
    @IBOutlet weak var currentLoadPercentage: UITextField!
    @IBOutlet weak var feedMaterialInStorage: UITextField!
    @IBOutlet weak var gypsumStockLevel: UITextField!
    
    //Calculations
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
    @IBOutlet weak var newSpecificPowerConsumption: UILabel!
    
    //Export
    @IBOutlet weak var targetEmailAddress: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        num10kSteelBalls?.text = UserDefaults.standard.string(forKey: "num10kSteelBalls") ?? ""
        num20kSteelBalls?.text = UserDefaults.standard.string(forKey: "num20kSteelBalls") ?? ""
        num30kSteelBalls?.text = UserDefaults.standard.string(forKey: "num30kSteelBalls") ?? ""
        percentLinerLeft?.text = UserDefaults.standard.string(forKey: "percentLinerLeft") ?? ""
        lubricantQuantity?.text = UserDefaults.standard.string(forKey: "lubricantQuantity") ?? ""
        targetProductionRate?.text = UserDefaults.standard.string(forKey: "targetProductionRate") ?? ""
        currentLoadPercentage?.text = UserDefaults.standard.string(forKey: "currentLoadPercentage") ?? ""
        feedMaterialInStorage?.text = UserDefaults.standard.string(forKey: "feedMaterialInStorage") ?? ""
        gypsumStockLevel?.text = UserDefaults.standard.string(forKey: "gypsumStockLevel") ?? ""
    }
    
    // Sets inventory to nothing
    @IBAction func resetInventory(_ sender: UIButton) {
        num10kSteelBalls.text = ""
        num20kSteelBalls.text = ""
        num30kSteelBalls.text = ""
        percentLinerLeft.text = ""
        lubricantQuantity.text = ""
        targetProductionRate.text = ""
        currentLoadPercentage.text = ""
        feedMaterialInStorage.text = ""
        gypsumStockLevel.text = ""
        
        // Clear saved inventory in UserDefaults
        UserDefaults.standard.removeObject(forKey: "num10kSteelBalls")
        UserDefaults.standard.removeObject(forKey: "num20kSteelBalls")
        UserDefaults.standard.removeObject(forKey: "num30kSteelBalls")
        UserDefaults.standard.removeObject(forKey: "percentLinerLeft")
        UserDefaults.standard.removeObject(forKey: "lubricantQuantity")
        UserDefaults.standard.removeObject(forKey: "targetProductionRate")
        UserDefaults.standard.removeObject(forKey: "currentLoadPercentage")
        UserDefaults.standard.removeObject(forKey: "feedMaterialInStorage")
        UserDefaults.standard.removeObject(forKey: "gypsumStockLevel")
    }
    
    @IBAction func saveInventory(_ sender: UIButton) {
        UserDefaults.standard.set(num10kSteelBalls.text, forKey: "num10kSteelBalls")
        UserDefaults.standard.set(num20kSteelBalls.text, forKey: "num20kSteelBalls")
        UserDefaults.standard.set(num30kSteelBalls.text, forKey: "num30kSteelBalls")
        UserDefaults.standard.set(percentLinerLeft.text, forKey: "percentLinerLeft")
        UserDefaults.standard.set(lubricantQuantity.text, forKey: "lubricantQuantity")
        UserDefaults.standard.set(targetProductionRate.text, forKey: "targetProductionRate")
        UserDefaults.standard.set(currentLoadPercentage.text, forKey: "currentLoadPercentage")
        UserDefaults.standard.set(feedMaterialInStorage.text, forKey: "feedMaterialInStorage")
        UserDefaults.standard.set(gypsumStockLevel.text, forKey: "gypsumStockLevel")
        
        print("Inventory saved to UserDefaults")
    }
    
    @IBAction func calculate(_ sender: UIButton) {
        // Provide default values if missing data
        let centreDistance = Double(UserDefaults.standard.string(forKey: "centreDistance") ?? "5.0") ?? 5.0
        let effectiveDiameter = Double(UserDefaults.standard.string(forKey: "effectiveDiameter") ?? "2.0") ?? 2.0
        
        let R = centreDistance / effectiveDiameter
        let armOfGravityValue = 0.666 * pow((1 - 4 * pow(R, 2)), 1.5)
        armOfGravity.text = "Arm of Gravity: \(armOfGravityValue)"
        
        let grindingMediaWeight = Double(UserDefaults.standard.string(forKey: "grindingMediaWeight") ?? "1000") ?? 1000.0
        let torqueFactor = Double(UserDefaults.standard.string(forKey: "torqueFactor") ?? "1.0") ?? 1.0
        let speed = Double(UserDefaults.standard.string(forKey: "speed") ?? "20") ?? 20.0
        let netPowerConsumptionValue = 0.514 * grindingMediaWeight * torqueFactor * speed * effectiveDiameter * armOfGravityValue
        netPowerConsumption.text = "Net Power Consumption: \(netPowerConsumptionValue)"
        
        let percentMotorEfficiency = Double(UserDefaults.standard.string(forKey: "percentMotorEfficiency") ?? "95") ?? 95.0
        let percentGearboxEfficiency = Double(UserDefaults.standard.string(forKey: "percentGearboxEfficiency") ?? "90") ?? 90.0
        let grossPowerConsumptionValue = netPowerConsumptionValue * 100 / (percentMotorEfficiency * percentGearboxEfficiency)
        grossPowerConsumption.text = "Gross Power Consumption: \(grossPowerConsumptionValue)"
        
        let oldProductionRate = Double(UserDefaults.standard.string(forKey: "oldProductionRate") ?? "500") ?? 500.0
        let oldBlaine = Double(UserDefaults.standard.string(forKey: "oldBlaine") ?? "3500") ?? 3500.0
        let newBlaine = Double(UserDefaults.standard.string(forKey: "newBlaine") ?? "4000") ?? 4000.0
        let newProductionRateValue = oldProductionRate * pow((oldBlaine / newBlaine), 1.3)
        newProductionRate.text = "New Production Rate: \(newProductionRateValue)"
        
        let targetSO3Content = Double(UserDefaults.standard.string(forKey: "targetSO3Content") ?? "2.5") ?? 2.5
        let percentSO3ContentInClinker = Double(UserDefaults.standard.string(forKey: "percentSO3ContentInClinker") ?? "0.5") ?? 0.5
        let percentGypsumPurity = Double(UserDefaults.standard.string(forKey: "percentGypsumPurity") ?? "85") ?? 85.0
        let percentFreeMoistureInGypsum = Double(UserDefaults.standard.string(forKey: "percentFreeMoistureInGypsum") ?? "2") ?? 2.0
        let gypsumSetPointValue = 21500 * (targetSO3Content - percentSO3ContentInClinker) / (percentGypsumPurity * (100 - percentFreeMoistureInGypsum))
        gypsumSetPoint.text = "Gypsum Set Point: \(gypsumSetPointValue)"
        
        let feedSize = Double(UserDefaults.standard.string(forKey: "feedSize") ?? "1.5") ?? 1.5
        let specificWeightOfFeedMaterial = Double(UserDefaults.standard.string(forKey: "specificWeightOfFeedMaterial") ?? "2.8") ?? 2.8
        let bondsWorkIndex = Double(UserDefaults.standard.string(forKey: "bondsWorkIndex") ?? "12") ?? 12.0
        let maximumBallSizeValue = 36 * sqrt(feedSize) * pow((specificWeightOfFeedMaterial * bondsWorkIndex) / (speed * sqrt(effectiveDiameter)), 1/3.0)
        maximumBallSize.text = "Maximum Ball Size: \(maximumBallSizeValue)"
        
        let freeHeight = Double(UserDefaults.standard.string(forKey: "freeHeight") ?? "0.8") ?? 0.8
        let percentFillingValue = 112.5 - (125 * freeHeight / effectiveDiameter)
        percentFilling.text = "Percent Filling: \(percentFillingValue)"
        
        let freshFeedRate = Double(UserDefaults.standard.string(forKey: "freshFeedRate") ?? "50") ?? 50.0
        let coarseReturn = Double(UserDefaults.standard.string(forKey: "coarseReturn") ?? "25") ?? 25.0
        let circulationFactorValue = (freshFeedRate + coarseReturn) / freshFeedRate
        circulationFactor.text = "Circulation Factor: \(circulationFactorValue)"
        
        let circulationLoadValue = (circulationFactorValue - 1) * 100
        circulationLoad.text = "Circulation Load: \(circulationLoadValue)"
        
        let criticalSpeedValue = 42.3 / sqrt(effectiveDiameter)
        criticalSpeed.text = "Critical Speed: \(criticalSpeedValue)"
        
        let oldSpecificPower = Double(UserDefaults.standard.string(forKey: "oldSpecificPower") ?? "15") ?? 15.0
        let newSpecificPowerConsumptionValue = oldSpecificPower * pow((newBlaine / oldBlaine), 1.3)
        newSpecificPowerConsumption.text = "New Specific Power Consumption: \(newSpecificPowerConsumptionValue)"
    }
    
    @IBAction func sendExcelFile(_ sender: UIButton) {
        var inventoryData: [[String]] = []
        inventoryData.append(["Item", "Value"])
        inventoryData.append(["10k Steel Balls", "1000"])
        inventoryData.append(["20k Steel Balls", "2000"])
        inventoryData.append(["30k Steel Balls", "3000"])
        inventoryData.append(["Percent Liner Left", "50"])
        inventoryData.append(["Lubricant Quantity", "10"])
        inventoryData.append(["Target Production Rate", "500"])
        inventoryData.append(["Current Load Percentage", "75"])
        inventoryData.append(["Feed Material in Storage", "100"])
        inventoryData.append(["Gypsum Stock Level", "20"])

        var calculationData: [[String]] = []
        calculationData.append(["Calculation", "Value"])
        calculationData.append(["Arm of Gravity", "0.5"])
        calculationData.append(["Net Power Consumption", "500"])
        calculationData.append(["Gross Power Consumption", "550"])
        calculationData.append(["New Production Rate", "450"])
        calculationData.append(["Gypsum Set Point", "5.0"])
        calculationData.append(["Maximum Ball Size", "25"])
        calculationData.append(["Percent Filling", "40"])
        calculationData.append(["Circulation Factor", "1.5"])
        calculationData.append(["Circulation Load", "50"])
        calculationData.append(["Critical Speed", "22"])
        calculationData.append(["New Specific Power Consumption", "15"])

            // Create the CSV content
            var csvContent = "Inventory Data\n"
            for row in inventoryData {
                csvContent += row.joined(separator: ",") + "\n"
            }

            csvContent += "\nCalculation Data\n"
            for row in calculationData {
                csvContent += row.joined(separator: ",") + "\n"
            }

            // Save the CSV file to a temporary directory
            let fileName = "CementAppData.csv"
            let filePath = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

            do {
                try csvContent.write(to: filePath, atomically: true, encoding: .utf8)
                print("CSV file created at: \(filePath)")

                // Send email
                if let email = targetEmailAddress.text, !email.isEmpty {
                    sendEmail(with: filePath, to: email)
                } else {
                    print("No target email address provided")
                }
            } catch {
                print("Error creating CSV file: \(error)")
            }
        }

        private func sendEmail(with filePath: URL, to recipient: String) {
            guard MFMailComposeViewController.canSendMail() else {
                print("Mail services are not available")
                return
            }

            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setSubject("CementApp Data")
            mailComposer.setMessageBody("Please find the attached CSV file with the inventory and calculation data.", isHTML: false)
            mailComposer.setToRecipients([recipient])

            do {
                let fileData = try Data(contentsOf: filePath)
                mailComposer.addAttachmentData(fileData, mimeType: "text/csv", fileName: filePath.lastPathComponent)
            } catch {
                print("Error attaching file: \(error)")
                return
            }

            present(mailComposer, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        switch result {
        case .sent:
            print("Email sent successfully")
        case .cancelled:
            print("Email cancelled")
        case .failed:
            print("Failed to send email: \(error?.localizedDescription ?? "Unknown error")")
        default:
            break
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
