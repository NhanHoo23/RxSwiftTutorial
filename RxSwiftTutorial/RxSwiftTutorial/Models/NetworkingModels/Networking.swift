//
//  Networking.swift
//  RxSwiftTutorial
//
//  Created by NhanHoo23 on 11/05/2023.
//

import MTSDK
import RxSwift
import RxCocoa

final class Networking {
    
    // MARK: - Endpoint
    enum EndPoint {
        static let baseURL: URL? = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/")
        
        case categories
        case drinks
        
        var url: URL? {
            switch self {
            case .categories:
                return EndPoint.baseURL?.appendingPathComponent("list.php")
                
            case .drinks:
                return EndPoint.baseURL?.appendingPathComponent("filter.php")
            }
        }
    }
    
    // MARK: - Singleton
    static let shared = Networking()
    
    private init() { }
    
    // MARK: - Properties
    
    // MARK: - Process methods
    static func jsonDecoder(contentIdentifier: String) -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.userInfo[.contentIdentifier] = contentIdentifier
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    // MARK: - Request
    func request<T: Codable>(url: URL?, query: [String: Any] = [:], contentIdentifier: String = "") -> Observable<T> {
        do {
            guard let URL = url,
                  var components = URLComponents(url: URL, resolvingAgainstBaseURL: true) else {
                throw NetworkingError.invalidURL(url?.absoluteString ?? "n/a")
            }
            
            components.queryItems = try query .compactMap {(key, value) in
                guard let v = value as? CustomStringConvertible else {
                    throw NetworkingError.invalidParameter(key, value)
                }
                return URLQueryItem(name: key, value: v.description)
            }
            
            guard let finalURL = components.url else {
                throw NetworkingError.invalidURL(url?.absoluteString ?? "n/a")
            }
            
            let request = URLRequest(url: finalURL)
            
            return URLSession.shared.rx.response(request: request)
                .map {(result: (response: HTTPURLResponse, data: Data)) -> T in
                    let decoder = JSONDecoder()
                    if contentIdentifier != "" {
                        let decoder = Networking.jsonDecoder(contentIdentifier: contentIdentifier)
                        let envelope = try decoder.decode(NetworkingResult<T>.self, from: result.data)
                        
                        return envelope.content
                    } else {
                        let decoder = JSONDecoder()
                        return try! decoder.decode(T.self, from: result.data)
                    }
                }
        } catch {
            print(error.localizedDescription)
            return Observable.empty()
        }
    }
    
    
    // MARK: - Business
    func getCategory(kind: String) -> Observable<[CocktailCategory]> {
        let query: [String: Any] = [kind: "list"]
        let url = EndPoint.categories.url
        
        let rq: Observable<CategoryResult<CocktailCategory>> = request(url: url, query: query)
        
        return rq
            .map { $0.drinks }
            .catchAndReturn([])
            .share(replay: 1, scope: .forever)
    }
    
    func getDrinks(kind: String, value: String) -> Observable<[Drink]> {
        let query: [String: Any] = [kind: value]
        let url = EndPoint.drinks.url
        
        let rq: Observable<[Drink]> = request(url: url, query: query, contentIdentifier: "drinks")
        
        return rq.catchAndReturn([])
    }
}
