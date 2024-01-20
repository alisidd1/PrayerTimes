//
//  Utilities.swift
//  PrayerTimes
//
//  Created by Ali Siddiqui on 1/18/24.
//

import UIKit

enum CustomError: String, Error {
    case invalidUrl =  "Invalid URL to get prayer timing info"
    case unableToComplete =  "Unable to complete the request. Please check your network connection"
    case invalidResponse = "Invalid response from the server. Please try again later."
    case invalidData = "The data received from the server was invalid. Please try again later"
}
