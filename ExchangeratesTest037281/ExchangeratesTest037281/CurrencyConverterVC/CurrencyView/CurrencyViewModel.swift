//
//  CurrencyViewModel.swift
//  ExchangeratesTest037281
//
//  Created by Vladyslav Veretennikov on 03.11.2023.
//

import Foundation

class CurrencyViewModel {

    var availableCurrencies: [String] = [] {
        didSet {
            self.didUpdateCurrencies?(availableCurrencies)
        }
    }
    
    var selectedCurrencyRate: Double? {
        didSet {
            self.didUpdateRate?(selectedCurrencyRate)
        }
    }
    
    var didUpdateCurrencies: (([String]) -> Void)?
    var didUpdateRate: ((Double?) -> Void)?

    private var exchangeRates: [String: Double] = [:]

    init() {}

    func getCurrencyCodes(baseCurrency: [String]) {
        availableCurrencies = baseCurrency
    }

    func rate(for currency: String) -> Double? {
        return exchangeRates[currency]
    }
    
    func selectCurrency(_ currency: String) {
        self.selectedCurrencyRate = rate(for: currency)
    }
}
