//
//  PriceTableViewController.swift
//  Test API
//
//  Created by Robert Cavallito on 7/9/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class PriceTableViewController: UITableViewController {

    var currency = [String]()
    var currencyURL = "https://data.fixer.io/api/latest?"
    var accessKey = "d36b5e61e31cbf09fcd96f66557fbb83"
    var base = "EUR"
    var symbols = "&symbols=USD,AUD,CAD,PLN"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let params = ["access_key":accessKey, "base" : base]
        getExchangePrices(url: currencyURL,parameters: params)

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currency.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "priceCell")
        cell?.textLabel?.text = currency[indexPath.row]

        return cell!
    }

    func getExchangePrices(url: String, parameters:[String:String])
    {
        Alamofire.request(url, method: .get,parameters: parameters).responseJSON { response in
            
            if response.result.isSuccess {
                print("Success")
                print(url, parameters)
                let priceJSON: JSON = JSON(response.result.value!)
                self.updatePrices(json: priceJSON)
            } else {
                print("Error \(String(describing: response.result.error))")
            }
            self.tableView.reloadData()
        }
        
    }
    
    func updatePrices(json: JSON){
        for (name,prices) in json["rates"]{
            let curr = ("\(name)    \(prices)")
            
            currency.append(curr)
        }
    }
}
