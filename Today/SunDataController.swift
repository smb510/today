//
//  SunDataController.swift
//  Today
//
//  Created by Scottie Biddle on 10/17/17.
//  Copyright © 2017 Scottie Biddle. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class SunDataController : NSObject, URLSessionDelegate {
  
  let BASE_URL = "https://api.sunrise-sunset.org/json?lat=%f&lng=%f&formatted=0&date=%@"
  var persistentContainer: NSPersistentContainer
  init(completionClosure: @escaping () -> ()) {
    persistentContainer = NSPersistentContainer(name: "Today")
    persistentContainer.loadPersistentStores() { (description, error) in
      if let error = error {
        fatalError("Failed to load the core data stack. sorry! \(error)")
      }
      completionClosure()
    }
  }
  
  func downloadData(completionHandler: @escaping (SunData?) -> ()) {
    let moc = persistentContainer.viewContext
    let session = URLSession.shared
    let url = URL(string: String.localizedStringWithFormat(BASE_URL, 37.785834, -122.406417, getTodayAsString()))
    let dataTask = session.dataTask(with: url!) { (data, response, error) in
      
      let decoder = JSONDecoder()
      let responseObject = try? decoder.decode(ResponseData.self, from: data!)
      let results = responseObject!.results
      let sunData = NSEntityDescription.insertNewObject(forEntityName: "SunData", into: moc)
        as! SunData
      sunData.date = self.getTodayAtMidnight()
      sunData.lat = 37.785834
      sunData.lng = -122.406417
      sunData.dayLength = results.day_length
      let formatter = ISO8601DateFormatter()
      sunData.astroTwilightBegin = formatter.date(from: results.astronomical_twilight_begin)
      sunData.astroTwilightEnd = formatter.date(from: results.astronomical_twilight_end)
      sunData.nauticalTwilightBegin = formatter.date(from: results.nautical_twilight_begin)
      sunData.nauticalTwilightEnd = formatter.date(from: results.nautical_twilight_end)
      sunData.civilTwilightBegin = formatter.date(from: results.civil_twilight_begin)
      sunData.civilTwilightEnd = formatter.date(from: results.civil_twilight_end)
      sunData.sunrise = formatter.date(from: results.sunrise)
      sunData.sunset = formatter.date(from: results.sunset)
      sunData.solarNoon = formatter.date(from: results.solar_noon)
      
      //        try moc.save()
      completionHandler(sunData)
      
    }
    dataTask.resume()
  }
  
  func getTodayAsString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .none
    dateFormatter.dateFormat = "YYYY-MM-dd"
    return dateFormatter.string(from: Date())
  }
  
  func getTodayAtMidnight() -> Date {
    let cal = Calendar.autoupdatingCurrent
    return cal.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
  }
  
  func fetchToday(completionHandler: @escaping (SunData?) -> ()) {
    let moc = persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SunData")
    do {
      let fetchedData = try moc.fetch(fetchRequest) as! [SunData]
      if (fetchedData.count > 0) {
        completionHandler(fetchedData[0])
      } else {
        downloadData(completionHandler: completionHandler)
      }
    } catch {
      fatalError("whoops didn't work \(error)")
    }
  }
  
  struct ResponseData: Codable {
    let status: String
    let results: SunDataJson
  }
  
  struct SunDataJson: Codable {
    let day_length: Int64
    let astronomical_twilight_begin: String
    let astronomical_twilight_end: String
    let nautical_twilight_begin: String
    let nautical_twilight_end: String
    let civil_twilight_begin: String
    let civil_twilight_end: String
    let sunrise: String
    let sunset: String
    let solar_noon: String
  }
}
