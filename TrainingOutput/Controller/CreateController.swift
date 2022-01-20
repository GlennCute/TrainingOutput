//
//  CreateController.swift
//  TrainingOutput
//
//  Created by OPSolutions on 1/17/22.
//

import Foundation
import UIKit
import FirebaseFirestore

class CreateController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        
        createButton.isEnabled = false
            confirmPasswordTextField.delegate = self
            confirmPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if (passwordTextField.text != "") {
            if (passwordTextField.text == confirmPasswordTextField.text) {
                createButton.isEnabled = true
            }
        }
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
            self.view.endEditing(true)
            return true
        }
    
    
    @IBAction func actionRegister(_ sender: Any) {
        
        if  passwordTextField.text != confirmPasswordTextField.text {
            let alert = UIAlertController(title: "Error", message: "Password mismatch", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection("Information").addDocument(data: [
            "ConfirmPassword": confirmPasswordTextField.text ?? "",
            "Email": emailTextField.text ?? "",
            "FirstName": firstNameTextField.text ?? "",
            "LastName": lastNameTextField.text ?? "",
            "Password": passwordTextField.text ?? ""
            
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                let alert = UIAlertController(title: "CreateController", message: "Registration Successful", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
        
}
