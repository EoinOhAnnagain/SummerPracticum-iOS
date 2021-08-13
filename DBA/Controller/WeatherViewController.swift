//
//  WeatherViewController.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 30/06/2021.
//

import UIKit


class WeatherViewController: UIViewController {
    
    
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherIconLoader: UIActivityIndicatorView!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var localLoader: UIActivityIndicatorView!
    
    @IBOutlet weak var windTitle: UILabel!
    @IBOutlet weak var windArrow: UIImageView!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var windLoader: UIActivityIndicatorView!
    
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
    
    @IBOutlet weak var visibilityTitle: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var pressureTitle: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var percipitationTitle: UILabel!
    @IBOutlet weak var percipitationLabel: UILabel!
    @IBOutlet weak var miscLoader: UIActivityIndicatorView!
    
    @IBOutlet weak var sunriseIcon: UIImageView!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetIcon: UIImageView!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var sunLoader: UIActivityIndicatorView!
    
    @IBOutlet var views: [UIView]!
    
    
    
    
    

    var weather: WeatherModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        roundCorners(views)
        
        // Do any additional setup after loading the view.
        
        // Arrow direction to update (360)
        
        if weather != nil {
            weatherIcon.image = UIImage(systemName: weather!.conditionName)
            locationLabel.text = weather!.cityName
            dateLabel.text = currentDate()
            timeLabel.text = currentTime()
            descriptionLabel.text = weather!.description.capitalized
            
            tempTitle.text = "Temperature\n\(weather!.stringTemperature)ºC"
            realFeelLabel.text = "\(weather!.stringFeelsLike)ºC"
            minLabel.text = "\(weather!.stringMin)ºC"
            maxLabel.text = "\(weather!.stringMax)ºC"
            humidityLabel.text = "\(weather!.humidity)%"
            
            visibilityLabel.text = "\(weather!.visibility) m"
            pressureLabel.text = "\(weather!.pressure) hPa"
            
            speedLabel.text = "\(weather!.stringWindSpeed) kph"
            windArrow.transform = CGAffineTransform(rotationAngle: CGFloat((weather!.windDeg))*(.pi/180))
            directionLabel.text = weather!.degreeName
            
            sunriseLabel.text = "\(weather!.sunriseTime)"
            sunsetLabel.text = "\(weather!.sunsetTime)"
            
            makeVisable()
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
    
    
    
    func makeVisable() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.5...1.5) ) {
            self.weatherIconLoader.stopAnimating()
            UIView.animate(withDuration: 1.5) {
                self.weatherIcon.alpha = 1
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 1...2.5) ) {
            self.localLoader.stopAnimating()
            UIView.animate(withDuration: 1.5) {
                self.locationLabel.alpha = 1
                self.dateLabel.alpha = 1
                self.timeLabel.alpha = 1
                self.descriptionLabel.alpha = 1
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 1...2.5) ) {
            self.windLoader.stopAnimating()
            UIView.animate(withDuration: 1.5) {
                self.windTitle.alpha = 1
                self.windArrow.alpha = 1
                self.speedLabel.alpha = 1
                self.directionLabel.alpha = 1
            }
        }

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

        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 1...2.5) ) {
            self.miscLoader.stopAnimating()
            UIView.animate(withDuration: 1.5) {
                self.visibilityTitle.alpha = 1
                self.visibilityLabel.alpha = 1
                self.pressureTitle.alpha = 1
                self.pressureLabel.alpha = 1
                self.humidityTitle.alpha = 1
                self.humidityLabel.alpha = 1
                //self.percipitationTitle.alpha = 1
                //self.percipitationLabel.alpha = 1
            }
        }

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
