//
//  APIManager.swift
//  ExchangeratesTest037281
//
//  Created by Vladyslav Veretennikov on 03.11.2023.
//

import Foundation

class CurrencyAPIManager {
    
    private let session: URLSession
    
    private let baseStringUrl = "http://api.exchangeratesapi.io/v1/" //https not supported my free plan
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchExchangeRates(completion: @escaping (Result<ExchangeRates, Error>) -> Void) {
        
        guard let url = URL(string: "\(baseStringUrl)latest?access_key=\(ConfigApp.exchangeratesAPIKey)") else {
            completion(.failure(NSError(domain: "", code: 404, userInfo: nil)))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let exchangeRates = try decoder.decode(ExchangeRates.self, from: data)
                    completion(.success(exchangeRates))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
}
