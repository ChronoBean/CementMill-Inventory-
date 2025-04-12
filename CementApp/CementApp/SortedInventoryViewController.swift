//
//  SortedInventoryViewController.swift
//  CementApp
//
//  Created by Benjamin Rush on 12/12/24.
//

import UIKit

class SortedInventoryViewController: UIViewController {

    @IBOutlet weak var sortedInventory: UILabel!
    
    var inventoryArray: [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateSortedInventoryLabel()
    }
    func updateSortedInventoryLabel() {
            let isSortedDescending = inventoryArray == inventoryArray.sorted(by: >)
            
            if isSortedDescending {
                let descriptors = [
                    "Number of 10kg Steel Balls",
                    "Number of 20kg Steel Balls",
                    "Number of 30kg Steel Balls",
                    "Target Production Rate",
                    "Current Load Percentage",
                    "Feed Material in Storage",
                    "Gypsum Stock Level"
                ]
                
                // Display the values in the correct order
                var inventoryText = ""
                for (index, value) in inventoryArray.enumerated() {
                    if index < descriptors.count {
                        inventoryText += "\(descriptors[index]): \(value)\n"
                    } else {
                        inventoryText += "Additional Value \(index + 1): \(value)\n"
                    }
                }
                
                sortedInventory.text = inventoryText
            } else {
                sortedInventory.text = "Inventory not sorted"
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
