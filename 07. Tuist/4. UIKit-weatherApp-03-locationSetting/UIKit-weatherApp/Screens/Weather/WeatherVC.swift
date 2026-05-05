//
//  ViewController.swift
//  UIKit-weatherApp
//
//  Created by Jeff Jeong on 4/23/24.
//

import UIKit





// 테이블뷰
// 데이터 즉 콜렉션 배열
// 데이터소스
//

class WeatherVC: UIViewController {

    typealias Item = HourlyWeather.Item
    
//    - [ ]  해당 위치의 날씨 조회 - api
//    - [ ]  지역 설정 - lat, lng
//    - [ ]  UI 작업
    
    @IBOutlet weak var hourlyItemTableView: UITableView!
    
    var previousLocationInfo : LocationInfo? = nil
    
    @IBOutlet weak var selectedLocationInfoLabel: UILabel!
    
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    // https://api.open-meteo.com/v1/forecast?latitude=33.352346&longitude=126.420494&current=temperature_2m,wind_speed_10m
    @IBOutlet weak var locationSelectionPickerView: UIPickerView!
    
    let locations : [LocationInfo] = LocationInfo.getKoreanLocationInfoList()
    
    var hourlyWeatherInfoItemList : [Item] = [] {
        didSet {
            DispatchQueue.main.async {
                self.hourlyItemTableView.reloadSections(IndexSet(integer: 0), with: .fade)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#fileID, #function, #line, "- ")
        let lat : Double = UserDefaults.standard.double(forKey: "lat")
        let lng : Double = UserDefaults.standard.double(forKey: "lng")
        
        guard lat > 0.0, lng > 0.0 else { return }
        
        self.fetchWeatherInfo(lat: lat, lng: lng)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationSelectionPickerView.reloadAllComponents()
        hourlyItemTableView.dataSource = self
        
        HourlyWeatherInfoCell.register(hourlyItemTableView)
        
//        hourlyItemTableView.register(HourlyWeatherInfoCell.cellNib, forCellReuseIdentifier: HourlyWeatherInfoCell.reuserIdentifier)
    }
    
    func fetchWeatherInfo(lat: Double, lng: Double) {
        
        Task{
            let latString = "\(lat)"
            let lngString = "\(lng)"
            
            if let info : WeatherInfo = await fetchCurrentWeatherFromAPI(lat: latString, lng: lngString) {
                
                windSpeedLabel.text = info.currentWeather.windSpeed
                temperatureLabel.text = info.currentWeather.temperature
                
                let items : [Item] = info.hourlyWeather.getItems()
                print(#fileID, #function, #line, "- items: \(items.count)")
                
                hourlyWeatherInfoItemList = items
                selectedLocationInfoLabel.text = "경도: \(lat), 위도: \(lng)"
            }
        }
    }
    
    func fetchWeatherInfo(locationInfo: LocationInfo) {
        
        guard locationInfo != previousLocationInfo else {
            return
        }
        
        previousLocationInfo = locationInfo
        
        Task{
            let latString = "\(locationInfo.latitude)"
            let lngString = "\(locationInfo.longitude)"
            
            if let info : WeatherInfo = await fetchCurrentWeatherFromAPI(lat: latString, lng: lngString) {
                
                windSpeedLabel.text = info.currentWeather.windSpeed
                temperatureLabel.text = info.currentWeather.temperature
                
                let items : [Item] = info.hourlyWeather.getItems()
                print(#fileID, #function, #line, "- items: \(items.count)")
                
                hourlyWeatherInfoItemList = items
                
            }
        }
    }
    
    @IBAction func confirmLocationSet(_ sender: Any) {
        print(#fileID, #function, #line, "- ")
        let selectedIndex = locationSelectionPickerView.selectedRow(inComponent: 0)
        
        let selectedLocationInfo : LocationInfo = locations[selectedIndex]
        
        
        
        selectedLocationInfoLabel.text = selectedLocationInfo.infoLabelString
        
        fetchWeatherInfo(locationInfo: selectedLocationInfo)
    }
    
    // "current": {
//        "time": "2024-04-23T01:45",
//        "interval": 900,
//        "temperature_2m": 15.1,
//        "wind_speed_10m": 10.9
//    }
    func fetchCurrentWeatherFromAPI(lat: String,
                                    lng: String) async -> WeatherInfo? {
        print(#fileID, #function, #line, "- ⭐️")
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lng)&current=temperature_2m,wind_speed_10m&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m") else {
            return nil
        }
        

        let apiResponse = try? await URLSession.shared.data(from: url)
        
        guard let apiResponse = apiResponse else {
            return nil
        }
        
        // data -> dictionary
        let result : [String: Any] = convertToDictionary(data: apiResponse.0)
        return WeatherInfo(dictionary: result)
    }
    
    func convertToDictionary(data: Data) -> [String: Any] {
        let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        return result ?? [:]
    }

}

// 갯수
extension WeatherVC : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locations.count
    }
}

extension WeatherVC : UIPickerViewDelegate {
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locations[row].name
    }
}

extension WeatherVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hourlyWeatherInfoItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell : HourlyWeatherInfoCell = tableView.dequeueReusableCell(withIdentifier: HourlyWeatherInfoCell.reuserIdentifier, for: indexPath) as? HourlyWeatherInfoCell else {
           return UITableViewCell()
        }
        
        let cellData : Item = hourlyWeatherInfoItemList[indexPath.row]
        
        cell.configureUI(cellData)
        
        return cell
    }
}
