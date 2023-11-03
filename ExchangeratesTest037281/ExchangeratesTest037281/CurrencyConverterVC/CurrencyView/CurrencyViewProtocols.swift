//
//  CurrencyViewProtocols.swift
//  ExchangeratesTest037281
//
//  Created by Vladyslav Veretennikov on 02.11.2023.
//

import Foundation

protocol CurrencyParameterChangeable: AnyObject {
    func currencyCountDidChange(value: Int, sender: CurrencyView)
    func currencyNameDidChange(value: String, sender: CurrencyView)
}
