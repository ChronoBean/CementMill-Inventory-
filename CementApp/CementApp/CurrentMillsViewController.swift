//
//  CurrentMillsViewController.swift
//  CementApp
//
//  Created by Benjamin Rush on 12/11/24.
//

import UIKit

class CurrentMillsViewController: UIViewController {

    @IBOutlet weak var ListOfMills: UILabel!
    var mills: [Mill] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateMillList()
    }
    
    func updateMillList() {
            
        }
    
    @IBAction func updateML(_ sender: UIButton) {
        let millNames = mills.enumerated().map { index, _ in "Mill\(index + 1)" }
        ListOfMills.text = millNames.joined(separator: ", ")
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
