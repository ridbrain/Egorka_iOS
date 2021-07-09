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
    
    class func request(url: String, param: Parameters, method: HTTPMethod = .post, complition: @escaping (Data) -> Void) {
        AF.request(baseUrl + url, method: method, parameters: param, encoding: JSONEncoding.default).responseJSON { response in
            if let data = response.data {
                complition(data)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "errorNoNetwork"), object: nil)
            }
        }
    }

    class func getUUID(complition: @escaping (UserUUID) -> Void) {

        let url = "service/auth/user/"
        
        let parameters = ["Auth" : auth, "Method" : "UUIDCreate", "Body" : "", "Params" : ""] as Parameters

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
    
    class func getAddress(address: String, complition: @escaping ([Dictionary.Suggestion]) -> Void) {
        
        let url = "service/delivery/dictionary/"
        
        let body = ["Query" : address] as Parameters
        let params = ["Compress" : "GZip", "Language" : "RU"] as Parameters
        let parameters = ["Auth" : auth, "Method" : "Location", "Body" : body, "Params" : params] as Parameters

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
    
    class func calculateDelivery(locations: [Any], type: DeliveryType, complition: @escaping (Delivery) -> Void) {
        
        let url = "service/delivery/"
        
        let body = ["Type" : type.rawValue, "Locations" : locations] as Parameters
        let params = ["Compress" : "GZip", "Language" : "RU"] as Parameters
        let parameters = ["Auth" : auth, "Method" : "Calculate", "Body" : body, "Params" : params] as Parameters

        request(url: url, param: parameters) { data in

            do {
//                print(try JSONSerialization.jsonObject(with: data, options: .mutableLeaves))
                let answer = try JSONDecoder().decode(Delivery.self, from: data)
                if answer.Result?.TotalPrice?.Total != nil {
                    answer.Type = type
                    complition(answer)
                }
            } catch let error {
                print(error)
            }

        }

    }
    
    class func bookDelivery(id: String, complition: @escaping (Delivery) -> Void) {
        
        let url = "service/delivery/"
        
        let body = ["ID" : id] as Parameters
        let params = ["Compress" : "GZip", "Language" : "RU"] as Parameters
        let parameters = ["Auth" : auth, "Method" : "Book", "Body" : body, "Params" : params] as Parameters

        request(url: url, param: parameters) { data in

            do {
//                print(try JSONSerialization.jsonObject(with: data, options: .mutableLeaves))
                let answer = try JSONDecoder().decode(Delivery.self, from: data)
                if answer.Result?.TotalPrice?.Total != nil {
                    complition(answer)
                }
            } catch let error {
                print(error)
            }

        }

    }
    
    class func checkOrder(number: String, pin: String, complition: @escaping (Delivery) -> Void) {
        
        let url = "service/delivery/"
        
        let body = ["RecordNumber" : number, "RecordPIN" : pin] as Parameters
        let params = ["Compress" : "GZip", "Language" : "RU"] as Parameters
        let parameters = ["Auth" : auth, "Method" : "Check", "Body" : body, "Params" : params] as Parameters

        request(url: url, param: parameters) { data in

            do {
//                print(try JSONSerialization.jsonObject(with: data, options: .mutableLeaves))
                let answer = try JSONDecoder().decode(Delivery.self, from: data)
                if answer.Result?.Invoices?.count ?? 0 > 0 {
                    complition(answer)
                }
            } catch let error {
                print(error)
            }

        }

    }
    
    class func getPaymentID(id: String, pin: String, complition: @escaping (Payment) -> Void) {
        
        let url = "payment/tinkoff/redirect/?ID=\(id)-\(pin)"

        request(url: url, param: Parameters()) { data in

            do {
                print(try JSONSerialization.jsonObject(with: data, options: .mutableLeaves))
                let answer = try JSONDecoder().decode(Payment.self, from: data)
                if answer.PaymentId != nil {
                    complition(answer)
                }
            } catch let error {
                print(error)
            }

        }

    }
    
    class func getMarketPlaces(complition: @escaping ([Marketplaces.Point]) -> Void) {
        
        let url = "service/delivery/dictionary/"
        
        let params = ["Compress" : "GZip", "Language" : "RU"] as Parameters
        let parameters = ["Auth" : auth, "Method" : "Marketplace", "Body" : [], "Params" : params] as Parameters

        request(url: url, param: parameters) { data in

            do {
//                print(try JSONSerialization.jsonObject(with: data, options: .mutableLeaves))
                let answer = try JSONDecoder().decode(Marketplaces.self, from: data)
                if answer.Result?.Points?.count ?? 0 > 0 {
                    complition(answer.Result!.Points!)
                }
            } catch let error {
                print(error)
            }

        }
        
    }
    
    
}
