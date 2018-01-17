//
//  ViewController.swift
//  Bitcoin Price
//
//  Created by Osama Ahmed on 17/01/2018.
//  Copyright © 2018 Osama Ahmed. All rights reserved.
//

import UIKit
import Alamofire /* ALAMOFIRE POD */
import SwiftyJSON /* SWIFTYJSON POD */

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource { /* USE OF DELEGATES AND PROTOCOLS */
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC" /* URL FOR API */
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"] /* CURRENCY ARRAY */
    
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"] /* CURRENCY SYMBOL ARRAY */
    
    var finalURL = "" /* THIS WILL BE SET WHEN THE USER SELECTS A CURRENCY */

    
    /* FUNCTION RUNS WHEN VIEW CONTROLLER LOADS */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate = self /* SET THE PICKERVIEW DELEGATE TO BE THE CURRENT VIEW CONTROLLER */
        currencyPicker.dataSource = self /* SET THE PICKERVIEW DATASOURCE TO BE THE CURRENT VIEW CONTROLLER */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* FUNCTION FOR NUMBER OF COLUMNS IN THE PICKER VIEW WHICH IS SET TO 1 */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    /* FUNCTION FOR NUMBER OF ROWS IN THE PICKER VIEW WHICH IS SET TO THE NUMBER OF ELEMENTS IN THE CURRENCY ARRAY */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    /* FUNCTION FOR WHAT EACH ROW OF THE PICKER VIEW SHOULD DISPLAY WHICH IS THE CURRENCIES OF THE DIFFERENT COUNTRIES IN THE CURRENCY ARRAY */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    /* FUNCTION TO DETERMINE WHAT SHOULD HAPPEN WHEN A COMPONENT OF THE PICKER VIEW IS SELECTED */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        finalURL = baseURL + currencyArray[row] /* CREATES A URL IN THE CORRECT FORMAT FOR THE API */
        
        getData(url: finalURL, symbol: currencySymbolArray[row]) /* CALLS THE GET DATA FUNCTION PASSING THE FORMATTED URL AND SYMBOL OF THE SELECTED CURRENCY */
    }
    
    /* FUNCTION WHICH USES ALAMOFIRE TO GET THE DATA FROM THE SERVER */
    func getData(url : String, symbol : String){
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess{
                let bitcoinJSON = JSON(response.result.value!) /* CREATION OF JSON WHICH WILL BE PARSED IN THE UPDATE DATA FUNCTION */
                self.updateData(json: bitcoinJSON, symbol: symbol) /* UPDATE DATA FUNCTION IS CALLED WITH JSON AND SYMBOL PASSED TO IT, SELF IS USED AS THIS CALL IS IN A CLOSURE */
            } else {
                self.priceLabel.text = "Cannot Connect" /* IF DATA CANNOT BE RETREIVED FROM THE SERVER THIS IS DISPLAYED */
            }
        }
    }
    
    /* FUNCTION WHICH USES SWIFTYJSON TO PARSE THE DATA RECEIVED FROM THE GET DATA FUNCTION */
    func updateData(json : JSON, symbol : String){
        if let bitcoinResult = json["ask"].double { /* USE OF OPTIONAL BINDING TO SEE IF THE ASK VALUE IN THE DICTIONARY RECEIVED FROM THE SERVER HAS A VALUE, IF SO PROCEED */
            priceLabel.text =  symbol + "\(bitcoinResult)" /* IF ASK HAS A VALUE MAKE THE LABEL SHOW THE PRICE AND THE MATCHING SYMBOL TO THE SELECTED CURRENCY */
        } else {
            priceLabel.text = "Price Unavailable" /* IF ASK HAS NO VALUE SET LABEL TO PRICE UNAVAILABLE */
        }
    }

}

