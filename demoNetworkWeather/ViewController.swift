//
//  ViewController.swift
//  demoNetworkWeather
//
//  Created by chenling on 16-4-25.
//  Copyright (c) 2016年 slack. All rights reserved.
//

import UIKit

// weather struct

struct Weather {
    var city: String?
    var weather: String?
    var temp: String?
}

class ViewController: UIViewController {
    // init view
    @IBOutlet weak var labelCity : UILabel!
    @IBOutlet weak var labelWeather : UILabel!
    @IBOutlet weak var labelTemp : UILabel!
    
    var weatherData: Weather? {
        // 一旦改变，就更新 swift专有
        didSet {
            configView()
        }
    }
    
    func configView() {
        labelCity.text = self.weatherData?.city
        labelWeather.text = self.weatherData?.weather
        labelTemp.text = self.weatherData?.temp
    }
    // network k780
    func getWeatherData(){
        // url
        let url = NSURL(string: "http://api.k780.com:88/?app=weather.today&weaid=402&&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json")
        // config 会话配置
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.timeoutIntervalForRequest = 10 //10s time out 超时
        //  session create 建立会话
        let session = NSURLSession(configuration: config)
        // task 会话任务  url 可选值，取真实值
        let task = session.dataTaskWithURL(url, completionHandler:
            { (data, _, error) -> Void in
                // 连接没有错误，处理数据
                if error == nil {
                    // json  强转字典
                    if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)
                        as? NSDictionary {
//                            print(json)
//                            {
//                                result =     {
//                                    cityid = 101190501;
//                                    citynm = "\U5357\U901a";
//                                    cityno = nantong;
//                                    days = "2016-04-25";
//                                    "humi_high" = 0;
//                                    "humi_low" = 0;
//                                    humidity = "83%";
//                                    "temp_curr" = 13;
//                                    "temp_high" = 21;
//                                    "temp_low" = 13;
//                                    temperature = "21\U2103/13\U2103";
//                                    "temperature_curr" = "13\U2103";
//                                    weaid = 402;
//                                    weather = "\U9634";
//                                    "weather_icon" = "http://api.k780.com:88/upload/weather/d/2.gif";
//                                    "weather_icon1" = "";
//                                    weatid = 3;
//                                    weatid1 = "";
//                                    week = "\U661f\U671f\U4e00";
//                                    wind = "\U4e1c\U5357\U98ce";
//                                    windid = 12;
//                                    winp = "1\U7ea7";
//                                    winpid = 201;
//                                };
//                                success = 1;
//                            }
                            //json对象直接实例化为自定义对象
                            let weather: Weather = (json.valueForKey("result") as?
                                NSDictionary).map {
                                    // 强转 string
                                    Weather(city: $0["citynm"] as? String,
                                        weather: $0["weather"] as? String,
                                        temp:$0["temperature_curr"] as? String)
                                }!
                            // 视图数据
//                            self.weatherData = weather
//                           更新界面放到主线程里
                            dispatch_async(dispatch_get_main_queue(),
                                { () -> Void in
                                self.weatherData = weather
                            })
                    }
                    
                }
        })
        //执行
        task.resume()
        
    }
    
    // appliction load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getWeatherData()
        configView()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

