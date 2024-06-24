//
//  ProductManager.swift
//  UrbanStore
//
//  Created by hwanghye on 6/24/24.
//

import UIKit
import Alamofire

class ProductManager {
    
    private init() { }
    
    static func callRequest(encodedQuery: String, itemsPerPage: Int, start: Int, completionHandler: @escaping (Result<NaverAPIResponse, Error>) -> Void) {
        
        let url = "\(APIURL.shopItemURL)\(encodedQuery)&display=\(itemsPerPage)&start=\(start)"
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.id,
            "X-Naver-Client-Secret": APIKey.Secret
        ]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: NaverAPIResponse.self) { response in
            switch response.result {
            case .success(let result):
                completionHandler(.success(result))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
