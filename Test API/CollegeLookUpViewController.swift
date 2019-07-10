//
//  CollegeLookUpViewController.swift
//  Test API
//
//  Created by Robert Cavallito on 5/30/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CollegeLookUpViewController: UIViewController {

    @IBOutlet weak var collegeSearchByNameTextField: UITextField!
    
    @IBOutlet weak var numberOfUndergradStudentsLabel: UILabel!
    @IBOutlet weak var tuitionAndFeesLabel: UILabel!
    @IBOutlet weak var completionRateLabel: UILabel!
    @IBOutlet weak var earningsLabel: UILabel!
    
    var undergraduateStudents = ""
    var tuitionAndFees = ""
    var completionRate = ""
    var studentEarnings = ""
    
    let apiKey = "&api_key=rH7C2p4T9zTOvjctQOiqvcLiz1CVL21fRmonNiv2"
    let baseURL = "https://api.data.gov/ed/collegescorecard/v1/schools?id="
    
    override func viewDidLoad() {
        super.viewDidLoad()

//Creating a test to ensure fields populate

        if collegeSearchByNameTextField.text != nil {
            
            undergraduateStudents = "43,500"
            tuitionAndFees = "$15,500"
            completionRate = "85%"
            studentEarnings = "75%"
            
        } else {
            
            undergraduateStudents = "10"
            tuitionAndFees = "$20"
            completionRate = "30%"
            studentEarnings = "40%"
            
        }
        
    }
    
    @IBAction func collegeSearchNameButton(_ sender: UIButton) {
    
    numberOfUndergradStudentsLabel.text = undergraduateStudents
    tuitionAndFeesLabel.text = tuitionAndFees
    completionRateLabel.text = completionRate
    earningsLabel.text = studentEarnings
    
    }
    
    @IBAction func goBackToHomeScreen(_ sender: Any) {
        performSegue(withIdentifier: "goBackToHomeScreen", sender: self)
    }
    
    
    
    
}
