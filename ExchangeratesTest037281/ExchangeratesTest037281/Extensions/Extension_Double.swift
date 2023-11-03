//
//  Extension_Double.swift
//  ExchangeratesTest037281
//
//  Created by Vladyslav Veretennikov on 03.11.2023.
//

import Foundation

extension Double {
    var roundedToTwoDecimalPlaces: Double {
        return (self * 100).rounded() / 100
    }
}
