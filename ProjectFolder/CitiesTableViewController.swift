//
//  CitiesTableViewController.swift
//  HW04
//
//  Created by Kevin Granados on 3/31/20.
//  Copyright © 2020 Kevin Granados. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class CitiesTableViewController: UITableViewController {
    
    @IBOutlet var citiesTable: UITableView!
    var currentWeatherObj:WeatherData?
    var citydata = AppData.init()
    var countryList = [String]()
    var dataList = [String:[String]]()
    var currentinfo = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = citydata.cities
        for countryname in dataList {
            countryList.append(countryname.key)
        }
        countryList.sort(by: >)
        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func getCurrentWeather(city: String){
        let cityname = city
        
        let params = [
            "q" : "\(cityname)",
            "appid" : "150a90f84dd3cd9719117246e7e1b8a2"
        ]
        
        AF.request("https://api.openweathermap.org/data/2.5/weather?", method: .get, parameters: params).responseJSON{ (response) in
            
            if response.value != nil{
                let forecastData = JSON(response.value!)
                self.currentWeatherObj = WeatherData(json: forecastData)
                self.performSegue(withIdentifier: "DetailsPage", sender: self)
            }
            else{
                print("Error")
            }
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return countryList.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let dataList = citydata.cities
        let data = countryList[section]
        return (dataList[data]!.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        let key = countryList[indexPath.section]
        let data = dataList[key]
        let city = data![indexPath.row]
        cell.textLabel?.text = city
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let country = countryList[section]
        return country
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = countryList[indexPath.section]
        let data = dataList[key]
        let city = data![indexPath.row]
        getCurrentWeather(city: city)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailsPage" {
            
            let indexPath = citiesTable.indexPathForSelectedRow!
            let country = countryList[indexPath.section]
            let data = dataList[country]
            let city = data![indexPath.row]
            let destination = segue.destination as! CurrentWeatherVC
            destination.cityName = city
            destination.countryName = country
            destination.currentCityWeatherObj = currentWeatherObj
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
