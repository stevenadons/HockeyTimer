//
//  DataService.swift
//  OneGalleryToAll
//
//  Created by Steven Adons on 29/12/16.
//  Copyright © 2016 Steven Adons. All rights reserved.
//

import Foundation


enum LoadingError: Error {
    
    case invalidURL
    case responseError
    case JSONSerializiationError
    case statusCodeNot200
}


class DataService {
    
    
    // MARK: - Properties
    
    private static let _instance = DataService()
    static var instance: DataService {
        return _instance
    }
    
    typealias Handler = (Result<[String: AnyObject], LoadingError>) -> Void
    
    
    // MARK: - Public Methods
    
    func getJSON(urlComponentsScheme: String, urlComponentsHost: String, urlComponentsPath: String, queryItems: [URLQueryItem]? = nil, then handler: Handler?) {
        
        guard let url = createURL(urlComponentsScheme: urlComponentsScheme, urlComponentsHost: urlComponentsHost, urlComponentsPath: urlComponentsPath, queryItems: queryItems) else {
            print("Could not find URL from components")
            handler?(.failure(LoadingError.invalidURL))
            return
        }
        print("getting JSON for url: \(url)")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        performDataTaskWith(session: URLSession.shared, request: request, handler: handler)
    }
    
    
    // MARK: - Private methods
    
    private func createURL(urlComponentsScheme: String, urlComponentsHost: String, urlComponentsPath: String, queryItems: [URLQueryItem]? = nil) -> URL? {
        
        var urlComponents = URLComponents()
        
        urlComponents.scheme = urlComponentsScheme
        urlComponents.host = urlComponentsHost
        urlComponents.path = urlComponentsPath
        if queryItems != nil {
            urlComponents.queryItems = queryItems
        }
        guard let url = urlComponents.url else {
            print("Could not find URL from components")
            return nil
        }
        
        return url
    }
    
    private func performDataTaskWith(session: URLSession, request: URLRequest, handler: Handler?) {
        
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            DispatchQueue.global().async {
                guard responseError == nil else {
                    print("*** Error in response jsonData: \(String(describing: responseError))")
                    handler?(.failure(LoadingError.responseError))
                    return
                }
                
                if let data = responseData {
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                        handler?(.failure(LoadingError.statusCodeNot200))
                    }
                    do {
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                            handler?(.success(jsonObject))
                        }
                    } catch {
                        handler?(.failure(LoadingError.JSONSerializiationError))
                        print("*** Error serializing result from \(String(describing: responseData))")
                    }
                }
            }
        }
        task.resume()
    }
}








