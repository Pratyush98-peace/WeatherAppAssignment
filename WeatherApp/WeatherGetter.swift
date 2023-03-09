//
//  FiAssignmentWeatherAppApp.swift
//  FiAssignmentWeatherApp
//
//  Created by Pratyush Jha on 08/03/23.
//

import Foundation

protocol WeatherGetterDelegate {
    func didGetWeather(weather: WeatherDetail)
    func didNotGetWeather()
}

class WeatherGetter {
    
    private let openWeatherMapAPIKey = "CcG4cAeMDmabt6HdAk2aISlupqyfvdgB"
    private var delegate: WeatherGetterDelegate
    
    init(delegate: WeatherGetterDelegate) {
        self.delegate = delegate
    }
    
    func getCurrentCity(latitude: Double, longitude: Double) {
        var url = "http://dataservice.accuweather.com/locations/v1/cities/geoposition/search"
        url = url + "?apikey=fXfnxixtabzeypoj42GispgxYbck2tV2&q=\(latitude),\(longitude)"
        print(url)
        let request = URLRequest(url: URL(string: url)!)
        let dataTask = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard let data = data,
                  let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
                  error == nil else {
               
                return
            }
            let cityName = jsonData["LocalizedName"] as? String
            guard let cityName = cityName else {
                return
                
            }
            self.getWeather(city: cityName)
        }
        dataTask.resume()
    }
    
    func getWeather(city: String) {
        let url = "http://dataservice.accuweather.com/locations/v1/cities/search?apikey=fXfnxixtabzeypoj42GispgxYbck2tV2&q=\(city)"
        guard let urlWrapped = URL(string: url) else {
            self.delegate.didNotGetWeather()
            return
        }
        let request = URLRequest(url: urlWrapped)
        let dataTask = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard let data = data,
                  let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]],
                  error == nil else {
                self.delegate.didNotGetWeather()
                return
            }
            let key = jsonData.first?["Key"]
            guard let key = key else {
                self.delegate.didNotGetWeather()
                return
            }
            self.getWeatherDataOfCity(key: key as! String, city: city)
        }
        dataTask.resume()
    }
    
    func getWeatherDataOfCity(key: String, city: String) {
        var url = "http://dataservice.accuweather.com/forecasts/v1/daily/1day/" + key
        url = url+"?apikey=fXfnxixtabzeypoj42GispgxYbck2tV2"
        let request = URLRequest(url: URL(string: url)!)
        let dataTask = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard let data = data,
                  let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
                  error == nil else {
                return
            }
            let weatherDetails = try? JSONDecoder().decode(Weather.self, from: jsonData)
            let minTemp = weatherDetails?.DailyForecasts[0].Temperature.Minimum.Value
            let maxTemp = weatherDetails?.DailyForecasts[0].Temperature.Maximum.Value
            let epoch = weatherDetails?.Headline.EffectiveEpochDate
            let weatherText = weatherDetails?.Headline.Text
            let weather = WeatherDetail(city: city, minTemp: minTemp ?? 0, maxTemp: maxTemp ?? 0, epochTime: epoch ?? 0, WeatherText: weatherText ?? "")
            self.delegate.didGetWeather(weather: weather)
        }
        dataTask.resume()
    }
}

public extension JSONDecoder {
    func decode<T>(_ type: T.Type, from jsonDictionary: [String: Any]) throws -> T where T: Decodable {
        let jsonData = try JSONSerialization.data(withJSONObject: jsonDictionary, options: [])
        return try decode(type, from: jsonData)
    }
    
    func decode<T>(_ type: T.Type, from jsonDictionaryArray: [[String: Any]]) throws -> T where T: Decodable {
        let jsonData = try JSONSerialization.data(withJSONObject: jsonDictionaryArray, options: [])
        return try decode(type, from: jsonData)
    }
}

