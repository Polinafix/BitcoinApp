//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
   
    
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbols = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
       
    }

    
    // Place your 3 UIPickerView delegate methods here
    
    //how many columns we want
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //how many rows this picker should have
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    // fill the picker row titles with the Strings from our currencyArray:
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    //when the row is selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print(currencyArray[row])
        finalURL = baseURL + currencyArray[row]
        //print(finalURL)
        getBitcoinData(url: finalURL, currency: currencySymbols[row])
        
    }
    
    //MARK: - Networking
    /***************************************************************/
    
    func getBitcoinData(url: String, currency: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the Bitcoin data")
                    //print(response)
                    let bitcoinJSON : JSON = JSON(response.result.value!)
                    //print("AFTER:   \(bitcoinJSON)")

                    self.updateBitcoinData(json: bitcoinJSON, currencyS:currency)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }

    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateBitcoinData(json : JSON,currencyS: String) {

        if let tempResult = json["ask"].double {
            bitcoinPriceLabel.text = "\(currencyS) \(tempResult)"
        }else{
            bitcoinPriceLabel.text = "Data Unavailable"
        }

        
    }
    

}

