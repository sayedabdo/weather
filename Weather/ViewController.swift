//
//  ViewController.swift
//  Weather
//
//  Created by Sayed Abdo on 2/5/18.
//  Copyright © 2018 sayedAbdo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityInfoLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var minMaxTemperatureLabel: UILabel!
    @IBOutlet weak var cityNameTextField: UITextField!
    
    var weatherDataHandler : WeatherDataHandler!
    var currentDay : Day = .today
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dateLabel.text = DateHandler.todaysDate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func endEditingTextField(_ sender: UITextField) {
        print("\nsdfsdrgerge\n")
        let baseURLString = "http://api.openweathermap.org/data/2.5/forecast?q="
        let APIKeyString = "&appid=97326567e425146674d28a4530b670e2"
        guard let cityString = sender.text else { return }
        if let finalURL = URL(string: baseURLString + cityString + APIKeyString) {
            requestWeatherData(url: finalURL)
        } else {
            print("Malformed URL")
        }
    }
    
    func requestWeatherData(url : URL) {
        let task = URLSession.shared.dataTask(with: url) {
            (data,response,error) in
            if let urlResponse = response {
                print(urlResponse)
            }
            if let errorResponse = error {
                print(errorResponse)
            } else if let dataResponse = data {
                self.weatherDataHandler = WeatherDataHandler(_data: dataResponse)
                self.weatherDataHandler.decodeData()
                
                let delay = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                    self.displayWeatherData()
                })
            }
        }
        task.resume()
        
    }
    
    func displayWeatherData() {
        guard let weatherDataHandle = weatherDataHandler else { return }
        if let city = weatherDataHandle.cityString {
            self.cityInfoLabel.text = city
        }
        
        var day: WeatherByDay?
        switch self.currentDay {
        case .today:
            day = weatherDataHandle.todaysData
            dateLabel.text = DateHandler.todaysDate
        case .tomorrow:
            day = weatherDataHandle.tomorrowsData
            dateLabel.text = DateHandler.tomorrowsDate
        }
        if let currentDay = day {
            temperatureLabel.text = "\(currentDay.averageTemp)℃"
            minMaxTemperatureLabel.text = "Min: \(currentDay.averageMinTemp)℃, Max: \(currentDay.averageMaxTemp)℃"
            getWeatherIcon(iconString: currentDay.iconString)
        } else {
            temperatureLabel.text = "No data to display"
            minMaxTemperatureLabel.text = "No data to display"
        }
    }
    
    @IBAction func Search(_ sender: Any) {
        print("\nsdfsdrgerge\n")
        let baseURLString = "http://api.openweathermap.org/data/2.5/forecast?q="
        let APIKeyString = "&appid=97326567e425146674d28a4530b670e2"
        guard let cityString = cityNameTextField.text else { return }
        if let finalURL = URL(string: baseURLString + cityString + APIKeyString) {
            requestWeatherData(url: finalURL)
        } else {
            print("Malformed URL")
        }
    }
    func getWeatherIcon(iconString: String) {
        let baseURLString = "http://openweathermap.org/img/w/"
        let endURLString = ".png"
        guard let iconURL = URL(string: baseURLString + iconString + endURLString) else { return }
        let task = URLSession.shared.dataTask(with: iconURL) {
            (data,response,error) in
            if let urlResponse = response {
                print(urlResponse)
            }
            if let errorResponse = error {
                print(errorResponse)
            } else if let dataResponse = data {
                let delay = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                    self.displayIconImage(data: dataResponse)
                })
            }
        }
        task.resume()
    }
    
    func displayIconImage(data: Data) {
        if let image = UIImage(data: data) {
            self.imageView.image = image
        } else {
            print("Could not convert image")
        }
    }
    
    @IBAction func pressTodayButton(_ sender: UIBarButtonItem) {
        currentDay = .today
        displayWeatherData()
    }
    
    @IBAction func pressTomorrowButton(_ sender: UIBarButtonItem) {
        currentDay = .tomorrow
        displayWeatherData()
    }

}

