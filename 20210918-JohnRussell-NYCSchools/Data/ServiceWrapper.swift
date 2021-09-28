//
//  ServiceWrapper.swift
//  Created by john Russell on 4/22/21.
//

import Foundation

class ServiceWrapper: NSObject {
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    func fetchDataWithDataTask(with urlRequest: URLRequest, success: @escaping (Data?) -> Void, failure: @escaping (Error?) -> Void)
    {
        
        dataTask?.cancel()
          // 4
          dataTask =
            defaultSession.dataTask(with: urlRequest)
            { [weak self] data, response, error in
            defer
            {
              self?.dataTask = nil
            }
                
            if let error = error
            {
                failure(error)
            }
            else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200
            {
                success(data)
            }
          }
                

        dataTask?.resume()
    }
}



