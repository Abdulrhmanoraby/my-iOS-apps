//
//  WeatherData.swift
//  wthr
//
//  Created by abdulrhman urabi on 24/04/2025.
//

struct WeatherData: Codable {
    var weather: [Weather]
    var main: Main
    var coord: Coord
    var name: String
}
struct Weather: Codable{
    var id: Int
}
struct Main: Codable{
    var temp: Double
}
struct Coord: Codable{
    var lon: Double
    var lat: Double
}
