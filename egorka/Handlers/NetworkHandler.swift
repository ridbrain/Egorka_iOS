//
//  NetworkHandler.swift
//  egorka
//
//  Created by Виталий Яковлев on 11.12.2020.
//

import Foundation
import Alamofire

class Network {
    
    static let baseUrl = "https://ws.egorka.dev/service/"
    static let code = "code"
    static let success = 1
    
    static let auth = [
        "Type" : "Application",
        "System" : "Corp",
        "Key" : "AAAAAAAA-BBBB-CCCC-DDDD-EEEEEEEEEEEE"
        ] as Parameters
    
    class func getAddress(url: String = "delivery/dictionary/", address: String, complition: @escaping ([Address]) -> Void ) {
        
        let body = [
            "Query" : address
            ] as Parameters
        
        let params = [
            "Compress" : "GZip",
            "Language" : "RU"
            ] as Parameters
        
        let parameters = [
            "Auth" : auth,
            "Method" : "Location",
            "Body" : body,
            "Params" : params
            ] as Parameters
        
        AF.request(baseUrl + url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            guard let data = response.data else { return }
            do {
                let answer = try JSONDecoder().decode(Dictionary.self, from: data)
                if answer.Result?.Suggestions?.count ?? 0 > 0 {
                    complition(answer.Result!.Suggestions!)
                }
            } catch let error {
                print(error)
            }
        }
        
    }
    
    class func calculate(url: String = "delivery/", codeFrom: String, codeTo: String, complition: @escaping ([Address]) -> Void ) {
        
        let from = [
            "Code" : codeFrom,
            ]
        
        let to = [
            "Code" : codeTo,
            ]
        
        let locations = [ ["Point" : from], ["Point" : to] ]
        
        let body = [
            "Type" : "Walk",
            "Locations" : locations
            ] as Parameters
        
        let params = [
            "Compress" : "GZip",
            "Language" : "RU"
            ] as Parameters
        
        let parameters = [
            "Auth" : auth,
            "Method" : "Calculate",
            "Body" : body,
            "Params" : params
            ] as Parameters
        
        AF.request(baseUrl + url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            guard let data = response.data else { return }
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                print(jsonResult)
//                let answer = try JSONDecoder().decode(Dictionary.self, from: data)
//                if answer.Result?.Suggestions?.count ?? 0 > 0 {
//                    complition(answer.Result!.Suggestions!)
//                }
            } catch let error {
                print(error)
            }
        }
        
    }
    
}
