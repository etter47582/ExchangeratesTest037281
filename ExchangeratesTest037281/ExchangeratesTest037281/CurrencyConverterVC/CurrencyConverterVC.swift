//
//  CurrencyConverterVC.swift
//  ExchangeratesTest037281
//
//  Created by Vladyslav Veretennikov on 02.11.2023.
//

import UIKit

class CurrencyConverterVC: UIViewController, CurrencyParameterChangeable {
    
    let apiManager = CurrencyAPIManager()
    
    var viewModel: CurrencyConverterViewModel? {
        didSet {
            bindToViewModel()
        }
    }
    
    @IBOutlet weak var currencyView1: CurrencyView!
    @IBOutlet weak var currencyView2: CurrencyView!
    
    @IBOutlet weak var convertButton: UIButton!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyView2.offTextField()
        convertButton.layer.cornerRadius = 8
        
        viewModel = CurrencyConverterViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel?.fetchExchangeRates()
    }
    
    private func bindToViewModel() {
        viewModel?.didUpdateCurrencies = { [weak self] currencies in
            DispatchQueue.main.async {
                self?.currencyView1.viewModel = CurrencyViewModel()
                self?.currencyView2.viewModel = CurrencyViewModel()
                
                self?.currencyView1.delegate = self
                self?.currencyView2.delegate = self
                
                self?.currencyView1.viewModel?.getCurrencyCodes(baseCurrency: currencies)
                self?.currencyView2.viewModel?.getCurrencyCodes(baseCurrency: currencies)
            }
        }
        
        viewModel?.didGetResultConversion = { [weak self] result in
            DispatchQueue.main.async {
                self?.currencyView2.changeAmount(value: result)
            }
        }

        viewModel?.didReceiveError = { [weak self] error in
            self?.showErrorAlert(and: error.localizedDescription)
        }
    }
    
    func currencyCountDidChange(value: Int, sender: CurrencyView) {
        if sender == currencyView1 {
            viewModel?.amount = value
        }
    }
    
    func currencyNameDidChange(value: String, sender: CurrencyView) {
        if sender == currencyView1 {
            viewModel?.from = value
        } else if sender == currencyView2 {
            viewModel?.to = value
        }
    }
    
    // MARK: Actions
    @IBAction func convertAction(_ sender: UIButton) {
        if currencyView1.countCurrencyTextField.text == "" {
            showErrorAlert(with: "Error", and: "Enter quantity to convert")
        } else {
            viewModel?.convertCalculated()
        }
    }
}
