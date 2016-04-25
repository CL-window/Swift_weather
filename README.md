swift 获取天气预报
解析json
if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)
as? NSDictionary {
             print(json)
})
