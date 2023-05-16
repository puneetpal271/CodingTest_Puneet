//
//  WeatherManager.swift
//  WeatherDemoTask
//
//  Created by Puneetpal Singh on 5/16/23.
//

import Foundation
enum UnitTemperatureType: String {
    case withDegree // ex. 4°
    case nonDegree // ex. 4
}

class WeatherManager {
    
    static func convertUnixTime(time: Int64?, timeZone: Int64) -> String {
        var convertedDate = ""

        if let unixTime = time {
            let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
            let dateFormatter = DateFormatter()
            let timezone = TimeZone(secondsFromGMT: Int(timeZone))
            dateFormatter.timeZone = timezone
            dateFormatter.locale = NSLocale.current
            dateFormatter.timeStyle = .short // ex. 07.43 AM
            convertedDate = dateFormatter.string(from: date)
        }

        return convertedDate
    }


    static func convertTemp(temp: Double, from inputTempType: UnitTemperature, to outputTempType: UnitTemperature, tempStringUnit: UnitTemperatureType) -> String {
        let mf = MeasurementFormatter()
        mf.numberFormatter.maximumFractionDigits = 0
        mf.unitOptions = .providedUnit
        let input = Measurement(value: temp, unit: inputTempType)
        let output = input.converted(to: outputTempType)

        if outputTempType == UnitTemperature.celsius {
            if tempStringUnit == .withDegree {
                return mf.string(from: output).replacingOccurrences(of: "C", with: "")
            } else if tempStringUnit == .nonDegree {
                return mf.string(from: output).replacingOccurrences(of: "°C", with: "")
            }
        }
        return mf.string(from: output)
    }
}
