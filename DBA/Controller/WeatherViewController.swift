//
//  WeatherViewController.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 30/06/2021.
//

import UIKit


class WeatherViewController: UIViewController {
    
    
    // IBOutlets for top right, icon, module
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherIconLoader: UIActivityIndicatorView!
    
    // IBOutlets for top left, local, module
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var localLoader: UIActivityIndicatorView!
    
    // IBOutlets for middle left, wind, module
    @IBOutlet weak var windTitle: UILabel!
    @IBOutlet weak var windArrow: UIImageView!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var windLoader: UIActivityIndicatorView!
    
    // IBOutlets for middle right, temperature, module
    @IBOutlet weak var tempTitle: UILabel!
    @IBOutlet weak var realFeelTitle: UILabel!
    @IBOutlet weak var realFeelLabel: UILabel!
    @IBOutlet weak var minTitle: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxTitle: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var humidityTitle: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var tempLoader: UIActivityIndicatorView!
    
    // IBOutlets for upper bottom, misc, module
    @IBOutlet weak var visibilityTitle: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var pressureTitle: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var miscLoader: UIActivityIndicatorView!
    
    // IBOutlets for lower bottom, sun, module
    @IBOutlet weak var sunriseIcon: UIImageView!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetIcon: UIImageView!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var sunLoader: UIActivityIndicatorView!
    
    // IBOutlet collection for rounding views
    @IBOutlet var views: [UIView]!

    // Weather object variable
    var weather: WeatherModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Round view corners
        roundCorners(views)
        
        // If there is weather user model to set the string and images
        if weather != nil {
            
            // Icon and local modules
            weatherIcon.image = UIImage(systemName: weather!.conditionName)
            locationLabel.text = weather!.cityName
            dateLabel.text = currentDate()
            timeLabel.text = currentTime()
            descriptionLabel.text = weather!.description.capitalized
            
            // Temperature module
            tempTitle.text = "Temperature\n\(weather!.stringTemperature)ºC"
            realFeelLabel.text = "\(weather!.stringFeelsLike)ºC"
            minLabel.text = "\(weather!.stringMin)ºC"
            maxLabel.text = "\(weather!.stringMax)ºC"
            
            // Wind module
            speedLabel.text = "\(weather!.stringWindSpeed) kph\n\(weather!.degreeName)"
            windArrow.transform = CGAffineTransform(rotationAngle: CGFloat((weather!.windDeg))*(.pi/180))
            
            // Misc module
            visibilityLabel.text = "\(weather!.visibility) m"
            pressureLabel.text = "\(weather!.pressure) hPa"
            humidityLabel.text = "\(weather!.humidity)%"
            
            // Sun module
            sunriseLabel.text = "\(weather!.sunriseTime)"
            sunsetLabel.text = "\(weather!.sunsetTime)"
            
            // Call method to make the modules visable
            makeVisable()
        }
    }
    
    
    func makeVisable() {
        // Method to make remove the loaders and make modules visable
        
        // Icon module
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.5...1.5) ) {
            self.weatherIconLoader.stopAnimating()
            UIView.animate(withDuration: 1.5) {
                self.weatherIcon.alpha = 1
            }
        }
        
        // Local module
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 1...2.5) ) {
            self.localLoader.stopAnimating()
            UIView.animate(withDuration: 1.5) {
                self.locationLabel.alpha = 1
                self.dateLabel.alpha = 1
                self.timeLabel.alpha = 1
                self.descriptionLabel.alpha = 1
            }
        }

        // Wind module
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 1...2.5) ) {
            self.windLoader.stopAnimating()
            UIView.animate(withDuration: 1.5) {
                self.windTitle.alpha = 1
                self.windArrow.alpha = 1
                self.speedLabel.alpha = 1
            }
        }

        // Temperature module
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 1...2.5) ) {
            self.tempLoader.stopAnimating()
            UIView.animate(withDuration: 1.5) {
                self.tempTitle.alpha = 1
                self.realFeelTitle.alpha = 1
                self.realFeelLabel.alpha = 1
                self.minTitle.alpha = 1
                self.minLabel.alpha = 1
                self.maxTitle.alpha = 1
                self.maxLabel.alpha = 1
            }
        }

        // Misc module
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 1...2.5) ) {
            self.miscLoader.stopAnimating()
            UIView.animate(withDuration: 1.5) {
                self.visibilityTitle.alpha = 1
                self.visibilityLabel.alpha = 1
                self.pressureTitle.alpha = 1
                self.pressureLabel.alpha = 1
                self.humidityTitle.alpha = 1
                self.humidityLabel.alpha = 1
            }
        }

        // Sun module
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 1...2.5) ) {
            self.sunLoader.stopAnimating()
            UIView.animate(withDuration: 1.5) {
                self.sunriseIcon.alpha = 1
                self.sunriseLabel.alpha = 1
                self.sunsetIcon.alpha = 1
                self.sunsetLabel.alpha = 1
            }
        }
    }
}
