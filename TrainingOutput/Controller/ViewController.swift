//
//  ViewController.swift
//  TrainingOutput
//
//  Created by OPSolutions on 1/14/22.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController {
    
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        stackView.setCustomSpacing(18, after: emailText)
        stackView.setCustomSpacing(24, after: passText)
        
//        versionLbl.font = UIFont(name: Fonts.regular, size: 16)
        
        let attributedString = NSMutableAttributedString(string: "Just click here to register", attributes: nil)
//        let justRange = (attributedString.string as NSString).range(of: "Just")
        let dontRange = (attributedString.string as NSString).range(of: "click here")
        attributedString.setAttributes([
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.blue
        ], range: dontRange)
//        attributedString.setAttributes([
//            .font: UIFont.boldSystemFont(ofSize: 10),
////            .link: ""
//            .foregroundColor: UIColor.red
//        ], range: justRange)
//        versionLbl.attributedText = attributedString
//        versionLbl.isUserInteractionEnabled = true
//
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapLabel(tap:)))
//        versionLbl.addGestureRecognizer(tap)
    }
    
    
    @IBAction func actionLogin(_ sender: Any) {
        
        let email = emailText.text ?? ""
        let password = passText.text ?? ""
        if email == "" || password == "" {
            let alert = UIAlertController(title: "Error", message: "Email or Password is required", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let db = Firestore.firestore()
        var isRegistered = false
        let userRef = db.collection("Information")
        userRef.whereField("Email", isEqualTo: email)
            .whereField("Password", isEqualTo: password)
            .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    isRegistered = true
                }
                
                if isRegistered {
                    print("Login")
                    let storyboard = UIStoryboard(name: "HomeController", bundle: nil)
                    let detailVC = storyboard.instantiateViewController(withIdentifier: "HomeController") as! HomeController
                    detailVC.modalPresentationStyle = .fullScreen
                    self.present(detailVC, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Invalid Login", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
    }
    
}

}
