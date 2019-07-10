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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //For the TableViews we add "UITableViewDelegate" and "UITableViewDataSource" and then we need the following code based on this video: https://www.youtube.com/watch?v=fFpMiSsynXM
    @IBOutlet weak var testingTableJSON: UITableView!
    
    var collegeList = ["College 1", "College 2", "College 3", "College 4"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return(collegeList.count)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "testCell")
        cell.textLabel?.text = collegeList[indexPath.row]
        return(cell)
    }
    
    
    //Original part of the code where a function is run to get data and display a manually determined piece of it in the Name of College and Acceptance Rate labels.
    @IBOutlet weak var acceptanceRateLabel: UILabel!
    @IBOutlet weak var nameOfCollege: UILabel!
    
    let apiKey = "pzTiQAuLWx613F6yeC9Kk30q7Yn0g1tgpJdARPhM"
    let baseURL = "https://api.data.gov/ed/collegescorecard/v1/schools?"
    var finalURL = ""
    var collegeSelected = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCollegeLists(name: "CUNY Queens College")
   
    }
    
    func getCollegeLists(zipCode: String? = nil, distanceInMile: Int? = nil, schoolState: String? = nil, perPage: Int? = nil, name: String? = nil, ownership: Int? = nil, additionalFields: [String: String]? = ["_fields": "id,school.ownership,school.name,school.state,latest.admissions.admission_rate.overall"]) {

        var parameters = [
            "api_key": apiKey
        ]
        if let zipCode = zipCode, !zipCode.isEmpty {
            parameters["_zip"] = zipCode
        }
        if let distance = distanceInMile, distance > 0 {
            parameters["_distance"] = "\(distance)mi"
        }
        if let state = schoolState, !state.isEmpty {
            parameters["school.state"] = state
        }
        if let perPage = perPage, perPage > 0 {
            parameters["_per_page"] = "\(perPage)"
        }
        if let name = name, !name.isEmpty {
            parameters["school.name"] = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        }
        if let ownership = ownership {
            parameters["school.ownership"] = "\(ownership)"
        }
        if let additionalFields = additionalFields {
            parameters.merge(additionalFields) { (_, current) in current }
        }
        
        let url = baseURL + buildParameterString(parameters: parameters)
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    let json = JSON(response.result.value!)
                    self.processCollegeList(json: json)
                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.acceptanceRateLabel.text = "Connection Issues"
                }
        }
    }
    
    func buildParameterString(parameters: [String: String]) -> String {
        var arrParameters = [String]()
        for parameter in parameters {
            arrParameters.append("\(parameter.key)=\(parameter.value)")
        }
        let parameterString = arrParameters.joined(separator: "&")
        print(parameterString)
        return parameterString
    }

    //MARK: - JSON Parsing
    func processCollegeList(json: JSON) {
        print(">>>===== Start ========")
        print(json)
        print(">>>===== End ========")
        
        acceptanceRateLabel.text = json["results"][1]["latest.admissions.admission_rate.overall"].stringValue
        nameOfCollege.text = json["results"][1]["school.name"].stringValue
    }
}
