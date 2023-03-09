//
//  FiAssignmentWeatherAppApp.swift
//  FiAssignmentWeatherApp
//
//  Created by Pratyush Jha on 08/03/23.
//

import UIKit
import MapKit

class WeatherMainViewController: UIViewController, WeatherGetterDelegate {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var epochLabel: UILabel!
    @IBOutlet weak var weatherText: UILabel!
    @IBOutlet weak var getCityWeatherButton: UIButton!
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var city: String?
    var weather: WeatherGetter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weather = WeatherGetter(delegate: self)
        getLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func getWeatherForCityButtonTapped(_ sender: Any) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(withIdentifier: "SearchCityIdentifier") as! SearchCityController
        self.present(controller,animated: true, completion: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    func getLayout() {
        cityLabel.text = "simple weather"
        weatherLabel.text = ""
        maxTemp.text = ""
        minTemp.text = ""
        epochLabel.text = ""
        weatherText.text = ""
        getCityWeatherButton.isEnabled = true
        if let city = city {
            weather.getWeather(city: city)
        } else {
            getCurrentLocationData()
        }
    }
    
    func didGetWeather(weather: WeatherDetail) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.city
            self.maxTemp.text = String(weather.maxTemp)
            self.minTemp.text = String(weather.minTemp)
            self.epochLabel.text = String(weather.epochTime)
            self.weatherText.text = weather.WeatherText
        }
    }
    
    func didGetCity(city: String?) {
        guard let text = city, !text.isEmpty else {
            return
            
        }
        weather.getWeather(city: text)
    }
    
    func didNotGetWeather() {
        weather.getWeather(city: "Nagpur")
    }
    
    func getCurrentLocationData() {
        locManager.requestWhenInUseAuthorization()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locManager.location else {
                weather.getWeather(city: "Nagpur")
                return
            }
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
            weather.getCurrentCity(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        } else {
            weather.getWeather(city: "Nagpur")
        }
    }
}


