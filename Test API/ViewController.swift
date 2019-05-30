//
//  ViewController.swift
//  Test API
//
//  Created by Robert Cavallito on 4/24/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var collegePicker: UIPickerView!
    @IBOutlet weak var acceptanceRateLabel: UILabel!
    
    let apiKey = "&api_key=rH7C2p4T9zTOvjctQOiqvcLiz1CVL21fRmonNiv2"
    let baseURL = "https://api.data.gov/ed/collegescorecard/v1/schools?id="
    let collegeArray = ["Boston College", "Texas A&M", "Duke University", "University of Texas", "New York University", "Fordham University", "University of Southern California", "University of Oregon", "University of Alabama", "University of Florida", "University of Virginia"]
    let collegeIdArray = ["164924", "228723", "198419", "228778", "193900", "191241", "123961", "209551", "100751", "134130", "234076"]
    var finalURL = ""
    var collegeSelected = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collegePicker.delegate = self
        collegePicker.dataSource = self
        
    }
    
    //MARK: UIPickerView delegate methods are here
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return collegeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return collegeArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(collegeArray[row])
        
        finalURL = baseURL + collegeIdArray[row] + apiKey
        collegeSelected = collegeIdArray[row]
        print(finalURL)
        
        getCollegeAcceptanceRate(url: finalURL)
        
    }
    
    //MARK: Networking

        func getCollegeAcceptanceRate(url: String) {

        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    let acceptanceRateJSON : JSON = JSON(response.result.value!)

                    self.updateAcceptanceRate(json: acceptanceRateJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.acceptanceRateLabel.text = "Connection Issues"
                }
        }
    }


    //MARK: - JSON Parsing

    func updateAcceptanceRate(json : JSON) {

        if let acceptanceRateResult = json["results"][0]["latest"]["admissions"]["admission_rate"]["overall"].double {
        acceptanceRateLabel.text = ("\(acceptanceRateResult * 100)%")
        }

        else {
        acceptanceRateLabel.text = "Fail!"

        }
    }
}

