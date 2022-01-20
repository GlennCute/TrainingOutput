//
//  ForgotController.swift
//  TrainingOutput
//
//  Created by OPSolutions on 1/16/22.
//

import UIKit
import UIKit
import FirebaseFirestore

class ForgotController: UIViewController, UITextViewDelegate, UITextFieldDelegate{
    
    
    @IBOutlet weak var forgotEmailText: UITextField!
    @IBOutlet weak var newpassText: UITextField!
    @IBOutlet weak var confirmpassText: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    
    override func viewDidLoad() {
        updateButton.isEnabled = false
        confirmpassText.delegate = self
        confirmpassText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if (newpassText.text != "") {
            if (newpassText.text == confirmpassText.text) {
                updateButton.isEnabled = true
            } else {
                updateButton.isEnabled = false
            }
        }
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func actionUpdate(_ sender: Any) {
        
        let email = forgotEmailText.text ?? ""
        
        if  newpassText.text != confirmpassText.text {
            let alert = UIAlertController(title: "Error", message: "Password mismatch", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("Information")
        userRef.whereField("Email", isEqualTo: email)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        //                    isRegistered = true
                    }
                    
                }
            }
 
        db.collection("Information").document("6fSj9slEzMQmXRQ2o1Oj").updateData([
            "Password": newpassText.text ?? ""
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
    }
}
