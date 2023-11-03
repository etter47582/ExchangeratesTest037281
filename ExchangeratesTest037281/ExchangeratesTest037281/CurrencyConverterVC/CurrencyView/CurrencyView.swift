//
//  CurrencyView.swift
//  ExchangeratesTest037281
//
//  Created by Vladyslav Veretennikov on 02.11.2023.
//

import UIKit

class CurrencyView: UIView {
    
    var viewModel: CurrencyViewModel? {
        didSet {
            bindToViewModel()
        }
    }
    
    weak var delegate: CurrencyParameterChangeable?
    
    @IBOutlet var mainCurrencyView: UIView!
    
    @IBOutlet weak var countCurrencyTextField: UITextField!
    
    @IBOutlet weak var currencyPickerView: UIPickerView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        mainCurrencyViewNibSetup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainCurrencyViewNibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        mainCurrencyViewNibSetup()
    }
    
    private func mainCurrencyViewNibSetup() {
        mainCurrencyView = loadMainCurrencyViewFromNib()
        mainCurrencyView.frame = bounds
        mainCurrencyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mainCurrencyView.translatesAutoresizingMaskIntoConstraints = true
        
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 8
        
        countCurrencyTextField.delegate = self
        currencyPickerView.delegate = self
        
        
        addSubview(mainCurrencyView)
    }
    
    private func loadMainCurrencyViewFromNib() -> UIView {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    private func bindToViewModel() {
        viewModel?.didUpdateCurrencies = { [weak self] currencies in
            DispatchQueue.main.async {
                self?.currencyPickerView.reloadAllComponents()
            }
        }
        
        viewModel?.didUpdateRate = { [weak self] rate in
            // Update UI or perform other tasks when the exchange rate changes.
        }
    }
    
    func changeAmount(value: Double) {
        countCurrencyTextField.text = String(value)
    }
    
    func offTextField() {
        countCurrencyTextField.isUserInteractionEnabled = false
    }
    
    
    
    
}

extension CurrencyView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let textFieldText = textField.text {
            if let counValue = Int(textFieldText + string) {
                delegate?.currencyCountDidChange(value: counValue, sender: self)
            }
        }
        return true
    }
}

extension CurrencyView: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel?.availableCurrencies.count ?? 0
    }
}

extension CurrencyView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        viewModel?.availableCurrencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let selectedCurrency = viewModel?.availableCurrencies[row] {
            delegate?.currencyNameDidChange(value: selectedCurrency, sender: self)
            viewModel?.selectCurrency(selectedCurrency)
        }
    }
}
