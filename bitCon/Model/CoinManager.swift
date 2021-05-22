
import UIKit

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel)
    func didFailWithError(error: Error)
}

class CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String, completion: () -> Void) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(APIKeys.coinAPI)"
        //print("my URL String is:\(urlString)")
        performRequest(with: urlString)
        completion()
    }
    
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    let coin = self.parseJSON(safeData)
                    self.delegate?.didUpdateCoin(self, coin: coin!)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> CoinModel? {
        let decode = JSONDecoder()
        do {
            let decodedData = try decode.decode(CoinData.self, from: coinData)
            let coinRate = decodedData.rate
            let selected = decodedData.asset_id_quote
            let coin = CoinModel(currentrate: coinRate, selectedCurrncy: selected)
            return coin
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}


