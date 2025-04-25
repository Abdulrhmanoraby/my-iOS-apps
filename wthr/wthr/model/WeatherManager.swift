//
//  WeatherManager.swift
//  wthr
//
//  Created by abdulrhman urabi on 23/04/2025.
//

import Foundation
import CoreLocation
protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weatherModel: WeatherModel)
    func didFinishWithError(error: Error)
}
struct WeatherManager{
    var delegate : WeatherManagerDelegate?
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=c6464bd19799ac953d5f121214f1a3f3&units=metric"
    
    func fetchWeather(city: String){
        let url = "\(weatherURL)&q=\(city)"
        self.performRequest(urlString: url)
    }
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let url = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        self.performRequest(urlString: url)
    }
    
    func performRequest(urlString: String){
        if let url = URL(string: urlString){
            let task = URLSession(configuration: .default)
            task.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    delegate?.didFinishWithError(error: error!)
                }
                if let safeData = data{
                    if let weather = self.parseJSON(data: safeData){
                        delegate?.didUpdateWeather(self, weatherModel: weather)
                    }
                }
            }.resume()
        }
    }
    
    func parseJSON(data: Data) -> WeatherModel?{
        do{
            let decodedData = try JSONDecoder().decode(WeatherData.self, from: data)
            let conditionId = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            let weatherModel = WeatherModel(cityName: name, temperature: temp, id: conditionId)
            return weatherModel
            
            
        }catch{
            delegate?.didFinishWithError(error: error)
            return nil
        }
    
    }
}
