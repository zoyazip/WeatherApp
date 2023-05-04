//
//  ViewController.swift
//  WeatherApp
//
//  Created by d.chernov on 28/04/2023.
//

import UIKit
import CoreLocation
import SDWebImage

class ViewController: UIViewController, ChildViewControllerDelegate, CLLocationManagerDelegate{
    var currentCity: String?
    let locationManager = CLLocationManager()
    var weather: Weather?
    
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var cityName: UILabel!
    
    @IBOutlet weak var temperature: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
//        getData(city: currentCity ?? "Valmiera")
    }
    func sendData(_ data: String?) {
        guard let updatedData = data else {
            return
        }
        getData(city: updatedData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.startUpdatingLocation()
        getData(city: currentCity ?? "Valmiera")
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Reverse geocoding failed with error: \(error.localizedDescription)")
                    return
                }
                
                guard let placemark = placemarks?.first else {
                    print("No placemark found.")
                    return
                }
                
                if let city = placemark.locality {
                    self.currentCity = city
                    print("Current city: \(city)")
                } else {
                    print("Unable to determine the city.")
                }
                
            }
        }
    
    func getData(city: String){
        
        let key: String = "0a48a3046579a5da02940412d624f461"
        
        let jsonUrl = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(key)&units=metric"
        
        guard let url = URL(string: jsonUrl) else {
            return }
        
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
                
                DispatchQueue.main.async {
                    self.cityName.text = jsonData.name
                    self.temperature.text = "\(Int(jsonData.main.temp)) °C"
                    self.weatherIcon.sd_setImage(with: URL(string: self.getWeatherIconURL(iconCode: jsonData.weather.first?.icon ?? "01d")))
                    
                }
                
            }catch{
                self.showAlert(city: city)
                print("error:::::" , error)
            }
            
        }.resume()
        
    }
    
    func getWeatherIconURL(iconCode: String) -> String {
        let iconURLString = "https://openweathermap.org/img/wn/\(iconCode).png"
        return iconURLString
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getWeatherSegue" {
            if let childViewController = segue.destination as? SearchCityViewController {
                childViewController.delegate = self
            }
        }
    }
    
    func showAlert(city: String) {
        let alertController = UIAlertController(title: "Something went wrong..", message: "Sorry, but we can't find \(city)", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}


