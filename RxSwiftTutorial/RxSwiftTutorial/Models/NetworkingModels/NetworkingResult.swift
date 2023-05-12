//
//  NetworkingResult.swift
//  RxSwiftTutorial
//
//  Created by NhanHoo23 on 11/05/2023.
//

import MTSDK


extension CodingUserInfoKey {
    static let contentIdentifier = CodingUserInfoKey(rawValue: "contentIdentifier")!
    // nó sẽ dùng userInfo khi decode giúp decode chính xác hơn
}

// "key" : [
//    {
//      JSON cho item có kiểu là A
//    },
//    {
//      JSON cho item có kiểu là A
//    },
//    {
//      JSON cho item có kiểu là A
//    },
//]
// contentIdentifier là key còn Content là [A]

//Decodable: cho phép giải mã Json sang các đối tượng Swift thuộc Codable
struct NetworkingResult<Content: Decodable>: Decodable { //Content là kiểu dữ liệu muốn chuyển đổi về
    let content: Content
    
    private struct CodingKeys: CodingKey { //Sử dụng CodingKeys để định danh các trường dữ liệu
        var stringValue: String
        var intValue: Int? = nil
        
        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = 0
        }
        
        init?(intValue: Int) {
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        guard let ci = decoder.userInfo[CodingUserInfoKey.contentIdentifier],
              let contentIdentifier = ci as? String,
              let key = CodingKeys(stringValue: contentIdentifier) else {
            throw NetworkingError.invalidDecoderConfiguration
        }
        
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            content = try container.decode(Content.self, forKey: key)
            print(content)
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    
}
