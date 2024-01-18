//
//  FetchCountriesData.swift
//  MedicareApp
//
//  Created by Arrax on 16/01/24.
//

import Foundation

class countryDataFetch : ObservableObject{
    
    func getCountries(completion : @escaping([String]) -> Void){
        guard let url = URL(string: "https://api.first.org/data/v1/countries") else{ return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error{
                print("Error loading Data \(error.localizedDescription)")
            }
            
            print(data ?? "")
            
            guard let jsonData = data else { return }
            
            let decoder = JSONDecoder()
            
            do {
                let decodedData = try decoder.decode(Countries.self, from: jsonData)
                var countryArray : [String] = []
                for (_, countryInfo) in decodedData.data{
                    countryArray.append(countryInfo.country)
                }
                completion(countryArray)
            }
            catch let decodingData{
                print("Error in decoding the file \(decodingData)")
            }
            
        }
        dataTask.resume()
    }
    
    func getCurrentCountry(completion : @escaping(currentCountry) -> Void){
        guard let url = URL(string: "https://ip-api.com/json") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error{
                print("Error loading Data \(error.localizedDescription)")
            }
            
            print(data ?? "")
            
            guard let jsonData = data else { return }
            
            let decoder = JSONDecoder()
            
            do {
                let decodedData = try decoder.decode(currentCountry.self, from: jsonData)
                print("current Country \(String(describing: decodedData.country))")
                completion(decodedData)
            }
            catch let decodingData{
                print("Error in decoding the file \(decodingData)")
            }
            
        }
        dataTask.resume()
        
    }
}
