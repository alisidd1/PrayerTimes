//
//  NetworkManager.swift
//  PrayerTimes
//
//  Created by Ali Siddiqui on 1/17/24.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    let baseURL = "https://api.aladhan.com/v1/calendar/"
    // https://api.aladhan.com/v1/calendar/2017/4?latitude=51.508515&longitude=-0.1254872&method=2
        
    func getAthanTime(month: String, latValue: String, longValue: String, completion: @escaping (Result<PrayerTimesModel, CustomError>) -> Void ) {

        let endPoint = baseURL + "2017/4?" + "latitude=\(latValue)&" + "longitude=\(longValue)&method=2"
 //       let endPoint = baseURL + month + latValue + longValue
        guard let url = URL(string: endPoint) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                completion(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let prayerTimesModel = try decoder.decode(PrayerTimesModel.self, from: data)
                print(prayerTimesModel as Any)
                completion(.success(prayerTimesModel))
            } catch DecodingError.dataCorrupted(let context) {
                print(context)
            } catch DecodingError.keyNotFound(let key, let context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch DecodingError.valueNotFound(let value, let context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch DecodingError.typeMismatch(let type, let context) {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        }
        task.resume()
    }
    
    
}
