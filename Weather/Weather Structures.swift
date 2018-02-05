//
//  Weather Structures.swift
//  Weather
//
//  Created by Sayed Abdo on 2/5/18.
//  Copyright © 2018 sayedAbdo. All rights reserved.
//

import Foundation


struct WeatherData : Codable {
    let list : [WeatherDataPoint]
    let city : City
}

struct City : Codable {
    let name : String
    let country : String
}

struct WeatherDataPoint : Codable {
    let main : Temperatures
    let dt_txt : String
    let weather : [WeatherIconData]
}

struct Temperatures : Codable {
    let temp : Double
    let temp_min : Double
    let temp_max : Double
}

struct WeatherIconData : Codable {
    let icon : String
}

struct WeatherByDay {
    let date: String
    let averageTemp: Double
    let averageMinTemp: Double
    let averageMaxTemp: Double
    let iconString: String
}

enum Day {
    case today
    case tomorrow
}
