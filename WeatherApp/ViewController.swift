import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var apparentTemperatureLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        toggleActivityIndicator(on: true)
        fetchCurrentWeatherData()
    }
    
    func toggleActivityIndicator(on: Bool) {
        refreshButton.isHidden = on
        
        if on {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    lazy var weatherManager = APIWeatherManager(apiKey: "2c745dcd4c911f5d486945ea8f00899f")
    
    // coordinates of Miami
    let coordinates = Coordinates(latitude: 25.800938, longitude: -80.286453)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCurrentWeatherData()
    }
    
    func fetchCurrentWeatherData(){
        
        // this function is working in background so to update UI we need to move some parts of code into the main thread
        weatherManager.fetchCurrentWeatherWith(coordinates: coordinates) { (result) in
            
            // to hide activity indicator after getting data
            self.toggleActivityIndicator(on: false)
            
            switch result {
                
            case .Success(let currentWeather):
                self.updateUIWith(currentWeather: currentWeather)
            case .Failure(let error as NSError):
                
                // can be mooved to function (takes 3 parameters) outside of this scope
                // also AlertManager can be created, so this function can be reusable for all AlertControllers
                let alertController = UIAlertController(title: "Unable to get data ", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
                print(error)
            //default: break
            }
        }
    }
    
    func updateUIWith(currentWeather: CurrentWeather) {
        self.imageView.image = currentWeather.icon
        self.pressureLabel.text = currentWeather.pressureString
        self.humidityLabel.text = currentWeather.humidityString
        self.temperatureLabel.text = currentWeather.temperatureString
        self.apparentTemperatureLabel.text = currentWeather.apparentTemperatureString
    }
    
}


