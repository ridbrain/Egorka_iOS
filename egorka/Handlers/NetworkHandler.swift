//
//  NetworkHandler.swift
//  egorka
//
//  Created by Виталий Яковлев on 11.12.2020.
//

import Foundation
import Alamofire

class Network {
    
    static let baseUrl = "https://app.egorka.dev/"
    static let auth = ["Type" : "Apple", "UserUUID" : UserData.getUserUUID() ?? ""] as Parameters
    
    class func request(url: String, param: Parameters, complition: @escaping (Data) -> Void) {
        AF.request(baseUrl + url, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { response in
            if let data = response.data {
                complition(data)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "errorNoNetwork"), object: nil)
            }
        }
    }

    class func getUUID(url: String = "service/auth/user/", complition: @escaping (UserUUID) -> Void) {

        let parameters = [
            "Auth" : auth,
            "Method" : "UUIDCreate",
            "Body" : "",
            "Params" : ""
            ] as Parameters

        request(url: url, param: parameters) { data in

            do {
                let answer = try JSONDecoder().decode(AnswerUser.self, from: data)
                if answer.Result?.Status == "Active" {
                    complition(answer.Result!)
                }
            } catch let error {
                print(error)
            }

        }
        
    }
    
    class func getAddress(url: String = "service/delivery/dictionary/", address: String, complition: @escaping ([Suggestion]) -> Void) {
        
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

        request(url: url, param: parameters) { data in

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
    
//    class func calculate(url: String = "delivery/", codeFrom: String, codeTo: String, complition: @escaping ([Address]) -> Void) {
//
//        let from = [
//            "Code" : codeFrom,
//            ]
//
//        let to = [
//            "Code" : codeTo,
//            ]
//
//        let locations = [
//            ["Point" : from],
//            ["Point" : to]
//            ]
//
//        let body = [
//            "Type" : "Walk",
//            "Locations" : locations
//            ] as Parameters
//
//        let params = [
//            "Compress" : "GZip",
//            "Language" : "RU"
//            ] as Parameters
//
//        let parameters = [
//            "Auth" : auth,
//            "Method" : "Calculate",
//            "Body" : body,
//            "Params" : params
//            ] as Parameters
//
//        request(url: url, param: parameters) { data in
//
//            do {
//                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
//                print(jsonResult)
//                let answer = try JSONDecoder().decode(Dictionary.self, from: data)
//                if answer.Result?.Suggestions?.count ?? 0 > 0 {
//                    complition(answer.Result!.Suggestions!)
//                }
//            } catch let error {
//                print(error)
//            }
//
//        }
//
//    }
    
}
