//
//  ViewController.swift
//  wthr
//
//  Created by abdulrhman urabi on 22/04/2025.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        weatherManager.delegate = self
        locationManager.requestLocation()
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        weatherManager.fetchWeather(city: searchTextField.text!)
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}
//MARK: - UItextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(false)
        if let text = textField.text{
            weatherManager.fetchWeather(city: text)
            print("From return delegate")
            return true
        }else{
            print("forom return delegate empty")
            return false
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != ""{
            print("from shouldEndEditing text != empty ")
            return true
        }else{
            return false
        }
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        weatherManager.fetchWeather(city: textField.text!)
    }
}
//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weatherModel: WeatherModel) {
        DispatchQueue.main.async {
            self.cityLabel.text = weatherModel.cityName
            self.tempLabel.text = weatherModel.temperatureString
            self.conditionImage.image = UIImage(systemName: weatherModel.conditionName)
        }
    }
    func didFinishWithError(error: any Error) {
        print(error)
    }
}
//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        let location = locations[0]
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        weatherManager.fetchWeather(latitude: latitude, longitude: longitude)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Error: \(error)")
    }
}

