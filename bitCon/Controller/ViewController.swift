//
//  ViewController.swift
//  bitCon
//
//  Created by Terry Kuo on 2021/5/22.
//


import UIKit

class ViewController: UIViewController {
    
    var coinManager = CoinManager()
    
    @IBOutlet weak var bitCoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencypicker: UIPickerView!
    @IBOutlet weak var unitLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        currencypicker.dataSource = self //set the ViewController.swift as the datasource for the picker.
        currencypicker.delegate = self
        currencyLabel.text = "Pick a country"
        
    }
    
    func showLoadingView2() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //When the PickerView is loading up, it will ask its delegate for a row title and call the above method once for every row.
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print(coinManager.currencyArray[row])
        showLoadingView2()
        coinManager.getCoinPrice(for: coinManager.currencyArray[row]) {
            dismiss(animated: false, completion: nil)
        }
    }
}

//MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    //UIPickerViewDataSource: ViewController class is capable of providing data to any UIPickerViews
}

//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel) {
        DispatchQueue.main.async {
            self.unitLabel.text = coin.selectedCurrncy
            self.currencyLabel.text = String(format: "%.3f", coin.currentrate)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


