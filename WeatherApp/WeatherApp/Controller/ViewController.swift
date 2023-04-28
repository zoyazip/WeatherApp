//
//  ViewController.swift
//  WeatherApp
//
//  Created by d.chernov on 28/04/2023.
//

import UIKit
import CoreLocation


class ViewController: UIViewController {
    let geocoder = CLGeocoder()
    var weather: Weather?
    
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var cityName: UILabel!
    
    @IBOutlet weak var temperature: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData(city: "Riga")
        print(weather)
        
    }
    
    
    func getData(city: String){
        var lat: Double = 56.949650
        var lon: Double = 24.105186
        
        //        geocoder.geocodeAddressString(city) { placemark, error in
        //            if let error = error {
        //                print("Geocoding error: \(error.localizedDescription)")
        //                return
        //            }
        //            if let placemark = placemark?.first, let location = placemark.location{
        //                lat = location.coordinate.latitude
        //                lon = location.coordinate.longitude
        //            }
        //        }
        let key: String = "0a48a3046579a5da02940412d624f461"
        
        
        let jsonUrl = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(key)"
        
        guard let url = URL(string: jsonUrl) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        
        URLSession(configuration: config).dataTask(with: request) { data, response, error in
            if error != nil {
                print((error?.localizedDescription)!)
            }
            
            guard let data = data else {
                print(String(describing: error))
                return
            }
            
            do {
                let jsonData = try JSONDecoder().decode(Weather.self, from: data)
                //dump(jsonData)
                self.weather = jsonData
                
            }catch{
                print("error:::::" , error)
            }
            
        }.resume()
        
    }
}


