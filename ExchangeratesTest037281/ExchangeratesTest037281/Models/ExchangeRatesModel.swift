//
//  ExchangeRatesModel.swift
//  ExchangeratesTest037281
//
//  Created by Vladyslav Veretennikov on 03.11.2023.
//

import Foundation

struct ExchangeRates: Decodable {
    let base: String
    let date: String
    let rates: [String: Double]
}

struct ConversionResult: Decodable {
    let success: Bool
    let result: Double?
}
