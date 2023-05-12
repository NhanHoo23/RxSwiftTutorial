//
//  NetworkingError.swift
//  RxSwiftTutorial
//
//  Created by NhanHoo23 on 11/05/2023.
//

import MTSDK

enum NetworkingError: Error {
    case invalidURL(String)
    case invalidParameter(String, Any)
    case invalidJSON(String)
    case invalidDecoderConfiguration
}
