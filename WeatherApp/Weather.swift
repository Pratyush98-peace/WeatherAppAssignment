//
//  FiAssignmentWeatherAppApp.swift
//  FiAssignmentWeatherApp
//
//  Created by Pratyush Jha on 08/03/23.
//

import Foundation

struct WeatherDetail {
    var city: String
    var minTemp: Double
    var maxTemp: Double
    var epochTime: Double
    var WeatherText: String
}

struct FetchCity: Codable {
    var LocalizedName: String
}

struct Weather: Codable {
    let Headline: headline
    let DailyForecasts: [dailyForecasts]
}

struct headline: Codable {
    let EffectiveEpochDate: Double
    let Text: String
}

struct dailyForecasts: Codable {
    let Temperature: TemperatureData
}

struct TemperatureData: Codable {
    let Minimum: TempDetails
    let Maximum: TempDetails
}

struct TempDetails: Codable {
    let Value: Double
    let Unit: String
}
  
