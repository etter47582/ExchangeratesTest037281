//
//  CurrencyConverterViewModel.swift
//  ExchangeratesTest037281
//
//  Created by Vladyslav Veretennikov on 03.11.2023.
//

import Foundation

class CurrencyConverterViewModel {

    var availableCurrencies: [String] = [] {
        didSet {
            self.didUpdateCurrencies?(availableCurrencies)
        }
    }
    
    var from: String = ""
    var to: String = ""
    var amount = 1
    
    
    var didUpdateCurrencies: (([String]) -> Void)?
    var didReceiveError: ((Error) -> Void)?
    var didGetResultConversion: ((Double) -> Void)?
    
    private var exchangeRates: [String: Double] = [:]
    private let apiManager: CurrencyAPIManager

    init(apiManager: CurrencyAPIManager = CurrencyAPIManager()) {
        self.apiManager = apiManager
    }

    func fetchExchangeRates() {
        apiManager.fetchExchangeRates() { [weak self] result in
            switch result {
            case .success(let exchangeRates):
                self?.exchangeRates = exchangeRates.rates
                self?.availableCurrencies = Array(exchangeRates.rates.keys)
                if let availableCurrenciesFirst = self?.availableCurrencies.first {
                    self?.from = availableCurrenciesFirst
                    self?.to = availableCurrenciesFirst
                }
            case .failure(let error):
                self?.didReceiveError?(error.localizedDescription as! Error)
            }
        }
    }

    func convertCalculated() {
        guard let rateTo = exchangeRates[from], let rateFrom = exchangeRates[to] else { return }
        let currentCurrencyRate = calculateCrossRate(rateToCurrencyA: rateTo, rateFromCurrencyB: rateFrom)
        let resultConversion = Double(amount) / currentCurrencyRate
        didGetResultConversion?(resultConversion.roundedToTwoDecimalPlaces)
    }

    func calculateCrossRate(rateToCurrencyA: Double, rateFromCurrencyB: Double) -> Double {
        let rateFromEURToCurrencyB = 1.0 / rateFromCurrencyB
        let crossRate = rateToCurrencyA * rateFromEURToCurrencyB
        return crossRate
    }
    
}
