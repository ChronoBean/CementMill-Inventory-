//
//  ExportViewController.swift
//  CementApp
//
//  Created by Benjamin Rush on 12/13/24.
//

import UIKit
import MessageUI

class ExportViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var reciverEmailAddress: UITextField!
    
    var inventoryData: [[String: Any]] = [] // Replace with your inventory structure
    var calculationsData: [[String: Any]] = [] // Replace with your calculations structure
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func exportPressed(_ sender: UIButton) {
        guard let email = reciverEmailAddress.text, !email.isEmpty else {
                    showAlert(title: "Error", message: "Please enter a valid email address.")
                    return
                }
                
                // Generate Excel file
                guard let fileURL = createExcelFile() else {
                    showAlert(title: "Error", message: "Failed to create Excel file.")
                    return
                }
                
                // Send email with the Excel file as attachment
                sendEmail(to: email, attachmentURL: fileURL)
    }
    
    func createExcelFile() -> URL? {
            // Use a library like CoreXLSX or write raw XML for an Excel file
            let fileName = "InventoryAndCalculations.xlsx"
            let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            
            // Create data for the Excel file (example using CSV for simplicity)
            var csvContent = "Category,Key,Value\n"
            
            // Add inventory data
            for item in inventoryData {
                for (key, value) in item {
                    csvContent += "Inventory,\(key),\(value)\n"
                }
            }
            
            // Add calculations data
            for item in calculationsData {
                for (key, value) in item {
                    csvContent += "Calculations,\(key),\(value)\n"
                }
            }
            
            do {
                try csvContent.write(to: fileURL, atomically: true, encoding: .utf8)
                return fileURL
            } catch {
                print("Error writing to file: \(error)")
                return nil
            }
        }
        
        // MARK: - Send Email
        func sendEmail(to email: String, attachmentURL: URL) {
            guard MFMailComposeViewController.canSendMail() else {
                showAlert(title: "Error", message: "Mail services are not available.")
                return
            }
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setToRecipients([email])
            mailComposer.setSubject("Inventory and Calculations")
            mailComposer.setMessageBody("Please find attached the inventory and calculations spreadsheet.", isHTML: false)
            
            do {
                let fileData = try Data(contentsOf: attachmentURL)
                mailComposer.addAttachmentData(fileData, mimeType: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", fileName: attachmentURL.lastPathComponent)
                present(mailComposer, animated: true)
            } catch {
                showAlert(title: "Error", message: "Failed to attach the file.")
            }
        }
        
        // MARK: - MFMailComposeViewControllerDelegate
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true) {
                if let error = error {
                    self.showAlert(title: "Error", message: "Failed to send email: \(error.localizedDescription)")
                    return
                }
                
                switch result {
                case .sent:
                    self.showAlert(title: "Success", message: "Email sent successfully.")
                case .failed:
                    self.showAlert(title: "Error", message: "Failed to send email.")
                default:
                    break
                }
            }
        }
        
        // MARK: - Show Alert
        func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
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
