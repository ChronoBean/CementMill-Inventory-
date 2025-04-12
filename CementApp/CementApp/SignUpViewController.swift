//
//  SignUpViewController.swift
//  CementApp
//
//  Created by Benjamin Rush on 11/25/24.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordTextField2: UITextField!
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupClicked(_ sender: UIButton) {
        
        guard let email = emailTextField.text else {
            self.errorMessageLabel.text = "Enter Email"
            return
        }
        guard let password = passwordTextField.text else {
            self.errorMessageLabel.text = "Password"
            return
        }
        
        // Validation of password
        guard let password2 = passwordTextField2.text else {
            self.errorMessageLabel.text = "Confirm your password"
            return
        }
        
        // Checking if email and password meet standards and throws error message if not
        if !isValidEmail(email) {
                self.errorMessageLabel.text = "Invalid email format."
                return
            }

        if !isValidPassword(password) {
            self.errorMessageLabel.text = "Password must contain at least one special character and no invalid domains."
            return
        }

        if password != password2 {
            self.errorMessageLabel.text = "Passwords do not match."
            return
        }
        
        // Authenticating the user
        Auth.auth().createUser(withEmail: email, password: password) { firebaseResult, error in
            if let e = error {
                
                print("error")
                return
                
            }
            guard let user = firebaseResult?.user else {
                self.errorMessageLabel.text = "User not found after signup."
                    return
            }
            
            // Sending a Verification Email to the User
            user.sendEmailVerification { error in
                    if let error = error {
                        self.errorMessageLabel.text = "Error sending verification email: \(error.localizedDescription)"
                        return
                    }
                self.errorMessageLabel.text = "Verification email sent."
                    self.performSegue(withIdentifier: "emailSent", sender: self)
                    
                }
        }
        
        // Functions to test for valid email and password
        func isValidPassword(_ password: String) -> Bool {
                let passwordRegex = "^(?=.*[!@#$%^&*(),.?\":{}|<>])[A-Za-z0-9!@#$%^&*(),.?\":{}|<>]+$"
                let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
                return passwordPredicate.evaluate(with: password)
        }
        
        func isValidEmail(_ email: String) -> Bool {
                let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.(com|org|gov)$"
                let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
                return emailPredicate.evaluate(with: email)
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
