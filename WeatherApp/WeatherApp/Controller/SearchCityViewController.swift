//
//  SearchCityViewController.swift
//  WeatherApp
//
//  Created by d.chernov on 28/04/2023.
//

import UIKit

class SearchCityViewController: UIViewController {
    var delegate: ChildViewControllerDelegate?
    var dataToSend: String?

    @IBOutlet weak var cityField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func getWeatherBtn(_ sender: Any) {
        dataToSend = cityField.text
        delegate?.sendData(dataToSend!)
        dismiss(animated: true)
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
