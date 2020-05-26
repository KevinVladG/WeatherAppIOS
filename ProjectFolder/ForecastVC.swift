//
//  ViewController.swift
//  HW04
//
//  Created by Kevin Granados on 3/31/20.
//  Copyright © 2020 Kevin Granados. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON



class ForecastVC: UIViewController {

    @IBOutlet weak var nameofCity: UILabel!
    @IBOutlet weak var WeatherForecastTable: UITableView!
    var cityName:String?
    var cityNameTitle:String?
    var numDates = [String]()
    var cityForecastData = [String:[WeatherData]]()
    var forecastDataArray = [WeatherData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        nameofCity.text = cityNameTitle
        let cellNib = UINib(nibName: "TableViewCell", bundle: nil)
        WeatherForecastTable.register(cellNib, forCellReuseIdentifier: "MyCell")
        self.WeatherForecastTable.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.WeatherForecastTable.reloadData()
    }
    
}

extension ForecastVC:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return numDates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = numDates[section]
        return (cityForecastData[date]!.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = WeatherForecastTable.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! TableViewCell
        let date = numDates[indexPath.section]
        let cityWF = cityForecastData[date]
        let city = cityWF![indexPath.row]
        
        cell.timeLabel.text = city.time
        cell.maxLabel.text = "Max: \(String(describing: city.main!.temperatureMax!))F"
        cell.minLabel.text = "Min: \(String(describing: city.main!.temperatureMin!))F"
        cell.humidityLabel.text = "Humidity: \(String(describing: city.main!.humidity!))%"
        cell.weatherLabel.text = city.weather!.description
        cell.TempLabel.text = city.main!.temperature!
        cell.ForecastWeatherIcon.af.setImage(withURL: URL(string: (city.weather?.icon)!)!)
        
        return cell
    }
}
extension ForecastVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let ele = numDates[section]
        return ele
    }
}
extension Dictionary where Value: RangeReplaceableCollection {
    public mutating func append(element: Value.Iterator.Element, toValueOfKey key: Key) {
        var value: Value = self[key] ?? Value()
        value.append(element)
        self[key] = value
    }
}

