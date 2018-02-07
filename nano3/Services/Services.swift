//
//  Services.swift
//  nano3
//
//  Created by Rodrigo Guimaraes on 2018-02-06.
//  Copyright © 2018 RodrigoLG. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireObjectMapper

enum StatusCode : Int{
    case NoResponse
    case Unauthorized
    case Success
    case Failure
}

class Services{
    
    static var shared = Services()
    
    fileprivate init() {}

    func getAllGamesFromAYear(delegateTarget : ServiceDelegate) {
        
        let headers : HTTPHeaders = [
            "user-key" : IGDB_key,
        ]
        
        let parameters : Parameters = [
            "fields" : "*"
        ]
        
        Alamofire.request(IGDB_url + urlGames, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: validSequence)
            .validate(contentType: ["application/json"])
            .responseArray { (response : DataResponse<[Game]>) in
                
                switch response.result{
                case .success:
                    //RETURN SUCCESS
                    let gameArray = response.result.value!
                    delegateTarget.didReceiveResponse(status: StatusCode.Success, responseJSON: gameArray.toJSONString()!)
                case .failure(let error):
                    if let receivedResponse = response.response{
                        if(receivedResponse.statusCode == 401){
                            delegateTarget.didReceiveResponse(status: StatusCode.Unauthorized, responseJSON: nil)
                        }else{
                            delegateTarget.didReceiveResponse(status: StatusCode.Failure, responseJSON: nil)
                        }
                    } else {
                        delegateTarget.didReceiveResponse(status: StatusCode.NoResponse, responseJSON: nil)
                    }
                    
                }
        }
    }
    
}

protocol ServiceDelegate{
    func didReceiveResponse(status : StatusCode, responseJSON : String?)
}
