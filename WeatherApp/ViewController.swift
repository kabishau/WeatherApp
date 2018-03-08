import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var appearentTemperatureLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let icon = WeatherIconManager.Rain.image
        let currentWeather = CurrentWeather(temperature: 10, appearentTemperature: 5, humidity: 30, pressure: 750, icon: icon)
        
        updateUIWith(currentWeather: currentWeather)
    }
    
    func updateUIWith(currentWeather: CurrentWeather) {
        self.imageView.image = currentWeather.icon
        self.pressureLabel.text = "\(Int(currentWeather.pressure)) mm"
        self.humidityLabel.text = "\(Int(currentWeather.humidity)) %"
        self.temperatureLabel.text = "\(Int(currentWeather.temperature))˚C"
        self.appearentTemperatureLabel.text = "Feels like: \(Int(currentWeather.temperature))˚C"
    }
    
}



