//
//  CurrentWeatherVC.swift
//  HW04
//
//  Created by Kevin Granados on 3/31/20.
//  Copyright © 2020 Kevin Granados. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class CurrentWeatherVC: UIViewController {
    
    @IBOutlet weak var TitleCity: UILabel!
    @IBOutlet weak var TempLabel: UILabel!
    @IBOutlet weak var TempMaxLabel: UILabel!
    @IBOutlet weak var TempMinLabel: UILabel!
    @IBOutlet weak var WeatherDescript: UILabel!
    @IBOutlet weak var WeatherHumidLabel: UILabel!
    @IBOutlet weak var WindSpeedLabel: UILabel!
    @IBOutlet weak var WindDegreeLabel: UILabel!
    @IBOutlet weak var CloudinessLabel: UILabel!
    @IBOutlet weak var CurrentWeatherIcon: UIImageView!
    

    var cityName:String?
    var countryName:String?
    var numDates = [String]()
    var currentCityWeatherObj:WeatherData?
    var cityForecastData = [String:[WeatherData]]()
    var forecastDataArray = [WeatherData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: (currentCityWeatherObj?.weather?.icon!)!)!
        CurrentWeatherIcon.af.setImage(withURL: url)
        TitleCity.text = "\(cityName!),\(countryName!)"
        TempLabel.text = "\((currentCityWeatherObj?.main?.temperature)!) F"
        TempMaxLabel.text = "\((currentCityWeatherObj?.main?.temperatureMax)!) F"
        TempMinLabel.text = "\((currentCityWeatherObj?.main?.temperatureMin)!) F"
        WeatherDescript.text = currentCityWeatherObj?.weather?.description
        WeatherHumidLabel.text = currentCityWeatherObj?.main?.humidity
        WindSpeedLabel.text = currentCityWeatherObj?.wind?.windSpeed
        WindDegreeLabel.text = currentCityWeatherObj?.wind?.windDegree
        CloudinessLabel.text = currentCityWeatherObj?.clouds?.cloudiness
        // Do any additional setup after loading the view.
    }
    
    func getData(city: String){
        numDates.removeAll()
        cityForecastData.removeAll()
        
        let cityname = city
        let params = [
            "q" : "\(cityname)",
            "appid" : "150a90f84dd3cd9719117246e7e1b8a2"
        ]
        
        AF.request("https://api.openweathermap.org/data/2.5/forecast?", method: .get, parameters: params).responseJSON{ (response) in
            if response.value != nil{
    
                let forecastData = JSON(response.value!)
                
                let listJSON = forecastData["list"].arrayValue

                for item in listJSON {
                    let info = WeatherData(json: item)
                    self.forecastDataArray.append(info)
                }
                for item in self.forecastDataArray {
                    let date = item.time?.split(separator: " ")
                    let insert =  self.cityForecastData[String(date![0])]
                    if insert != nil {
                        self.cityForecastData.append(element: item, toValueOfKey: String(date![0]))
                    }
                    else{
                        self.cityForecastData[String(date![0])] = [item]
                    }
                }
                self.numDates.append(contentsOf: self.cityForecastData.keys)
                self.numDates.sort()
            }
            else{
                print("Error")
            }
            self.performSegue(withIdentifier: "WeatherForecast", sender: self)
        }
        
    }
    
    @IBAction func ForecastSegue(_ sender: Any) {
        getData(city: cityName!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WeatherForecast" {
            let destination = segue.destination as! ForecastVC
            destination.cityNameTitle = TitleCity.text
            destination.cityName = cityName
            destination.numDates = numDates
            destination.cityForecastData = cityForecastData
        }
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
