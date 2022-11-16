//
//  BundleExtensions.swift
//  Project2
//
//  Created by Heston Suorsa on 11/15/22.
//

import Foundation

extension Bundle {
    func decodeJSON<T: Decodable>(_ resource: String) -> T? {
        // 1. get the path to the json file with the app bundle
        let pathString = Bundle.main.path(forResource: resource, ofType: "json")
        
        if let path = pathString {
            // 2. create a URL Object
            let url = URL(fileURLWithPath: path)
            
            do {
                // 3. create a Data object with the URL file
                let data = try Data(contentsOf: url)
                // 4. create a JSON decoder
                let json_decoder = JSONDecoder()
                // 5. extract the models from the json file
                return try json_decoder.decode(T.self, from: data)
                
            } catch {
                print(error)
            }
        }
        return nil
    }
    
    func fetchData<T: Decodable>(url: String, model: T.Type, completion:@escaping(T) -> (), failure:@escaping(Error) -> ()) {
                guard let url = URL(string: url) else { return }
                
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    guard let data = data else {
                        // If there is an error, return the error.
                        if let error = error { failure(error) }
                        return }
                    
                    do {
                        let serverData = try JSONDecoder().decode(T.self, from: data)
                        // Return the data successfully from the server
                        completion((serverData))
                    } catch {
                        // If there is an error, return the error.
                        failure(error)
                    }
                }.resume()
        }
}
