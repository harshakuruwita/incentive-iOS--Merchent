//
//  RestClient.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 8/26/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RestClient: NSObject {
    
    class func makeGetRequst(url:String, access_token:String,  delegate:AnyObject, requestFinished:Selector, requestFailed:Selector, tag:Int){
        
                let Auth_header: HTTPHeaders = [
                    "Authorization": access_token,
                    "Content-Type": "application/x-www-form-urlencoded"
                ]
                
                
                Alamofire.request(url, method: .get ,encoding: JSONEncoding.default, headers: Auth_header)
                    .responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            print("Validation Successful")
                            
                            let json = JSON(value)
                            let responseHandler = ResponseSwift()
                            responseHandler.tag = tag
                            responseHandler.responseObject = json
                            _ = delegate.perform(requestFinished, with: responseHandler)
                        case .failure(let error):
                            
                            let responseHandler = ResponseSwift()
                            responseHandler.tag = tag
                            _ =  delegate.perform(requestFailed, with: responseHandler)
                            print(error)
                        }
                }
            
        }
        
        
    class func makeGetRequstWithToken(url:String,   delegate:AnyObject, requestFinished:Selector, requestFailed:Selector, tag:Int){
          
                  let access_token = UserDefaults.standard.string(forKey: "token")
                        
                         print("09=access_token: \(access_token)")
                         
                         let Auth_header: HTTPHeaders = [
                             "Content-Type": "application/json",
                             "Authorization":  "Bearer" + " " + access_token!
                             
                             ]
                  
                  
                  Alamofire.request(url, method: .get ,encoding: JSONEncoding.default, headers: Auth_header)
                      .responseJSON { response in
                          switch response.result {
                          case .success(let value):
                              print("Validation Successful")
                              
                              let json = JSON(value)
                              let responseHandler = ResponseSwift()
                              responseHandler.tag = tag
                              responseHandler.responseObject = json
                              _ = delegate.perform(requestFinished, with: responseHandler)
                          case .failure(let error):
                              
                              let responseHandler = ResponseSwift()
                              responseHandler.tag = tag
                              _ =  delegate.perform(requestFailed, with: responseHandler)
                              print(error)
                          }
                  }
              
          }
    
    class func makePutRequst(url:String, filterDictionary:Parameters,  delegate:AnyObject, requestFinished:Selector, requestFailed:Selector, tag:Int){
        
       
                let Auth_header: HTTPHeaders = [
                   
                    "Content-Type": "application/x-www-form-urlencoded"
                    
                ]
                
                
                Alamofire.request(url, method: .put , parameters: filterDictionary, encoding: JSONEncoding.default, headers: Auth_header)
                    .responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            print("Validation Successful")
                            
                            let json = JSON(value)
                            let responseHandler = ResponseSwift()
                            responseHandler.tag = tag
                            responseHandler.responseObject = json
                            _ = delegate.perform(requestFinished, with: responseHandler)
                        case .failure(let error):
                            
                            let responseHandler = ResponseSwift()
                            responseHandler.tag = tag
                            _ =  delegate.perform(requestFailed, with: responseHandler)
                            print(error)
                        }
                }
            
        }
        
        

    
    class func makePostRequst(url:String, filterDictionary:Parameters,  delegate:AnyObject, requestFinished:Selector, requestFailed:Selector, tag:Int){
        
       
      
        
                
                let Auth_header: HTTPHeaders = [
                    
                    "Content-Type": "application/json"
                    
                ]
                
                
                Alamofire.request(url, method: .post , parameters: filterDictionary, encoding: JSONEncoding.default, headers: Auth_header)
                    .responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            print("Validation Successful")
                            
                            let json = JSON(value)
                            let responseHandler = ResponseSwift()
                            responseHandler.tag = tag
                            responseHandler.responseObject = json
                            _ = delegate.perform(requestFinished, with: responseHandler)
                        case .failure(let error):
                            
                            let responseHandler = ResponseSwift()
                            responseHandler.tag = tag
                            _ =  delegate.perform(requestFailed, with: responseHandler)
                            print(error)
                        }
                }
            
        }
        
        
    
    
    
    
    class func makeArryPostRequestUrl(url:String, arryParam:JSON, delegate:AnyObject, requestFinished:Selector, requestFailed:Selector, tag:Int){
        

     
         let requstUri = NSURL(string: url)
                
        
                var request = URLRequest(url: requstUri! as URL)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                
                request.httpBody = try! JSONSerialization.data(withJSONObject:arryParam.rawValue)
            
                Alamofire.request(request)
                    .responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            
                            
                            let json = JSON(value)
                            let responseHandler = ResponseSwift()
                            responseHandler.tag = tag
                            responseHandler.responseObject = json
                            _ = delegate.perform(requestFinished, with: responseHandler)
                        case .failure(let error):
                            
                            let responseHandler = ResponseSwift()
                            responseHandler.tag = tag
                            _ =  delegate.perform(requestFailed, with: responseHandler)
                            print(error)
                        }
                }
                
                
            
        }
    
    
    class func makeArryPostRequestWithToken(url:String, arryParam:JSON, delegate:AnyObject, requestFinished:Selector, requestFailed:Selector, tag:Int){
        

     
         let requstUri = NSURL(string: url)
         let access_token = UserDefaults.standard.string(forKey: "token")
        
                var request = URLRequest(url: requstUri! as URL)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer" + " " + access_token!, forHTTPHeaderField: "Authorization")
        print("access_token! is is---\(access_token!)")
                request.httpBody = try! JSONSerialization.data(withJSONObject:arryParam.rawValue)
                
                Alamofire.request(request)
                    .responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            
                            
                            let json = JSON(value)
                            let responseHandler = ResponseSwift()
                            responseHandler.tag = tag
                            responseHandler.responseObject = json
                            _ = delegate.perform(requestFinished, with: responseHandler)
                        case .failure(let error):
                            
                            let responseHandler = ResponseSwift()
                            responseHandler.tag = tag
                            _ =  delegate.perform(requestFailed, with: responseHandler)
                            print(error)
                        }
                }
                
                
            
        }
    
    
    
    class func makeArryPatchRequestWithToken(url:String, arryParam:JSON, delegate:AnyObject, requestFinished:Selector, requestFailed:Selector, tag:Int){
        

     
         let requstUri = NSURL(string: url)
         let access_token = UserDefaults.standard.string(forKey: "token")
        
                var request = URLRequest(url: requstUri! as URL)
                request.httpMethod = "PATCH"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer" + " " + access_token!, forHTTPHeaderField: "Authorization")
        print("access_token! is is---\(access_token!)")
                request.httpBody = try! JSONSerialization.data(withJSONObject:arryParam.rawValue)
                
                Alamofire.request(request)
                    .responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            
                            
                            let json = JSON(value)
                            let responseHandler = ResponseSwift()
                            responseHandler.tag = tag
                            responseHandler.responseObject = json
                            _ = delegate.perform(requestFinished, with: responseHandler)
                        case .failure(let error):
                            
                            let responseHandler = ResponseSwift()
                            responseHandler.tag = tag
                            _ =  delegate.perform(requestFailed, with: responseHandler)
                            print(error)
                        }
                }
                
                
            
        }
    
    class func makeDeleteRequst(url:String,  delegate:AnyObject, requestFinished:Selector, requestFailed:Selector, tag:Int){
        
        var awsToken = ""
   
                
        
                
                let Auth_header: HTTPHeaders = [
                    "Authorization": awsToken,
                    "Content-Type": "application/x-www-form-urlencoded"
                ]
                
                
                Alamofire.request(url, method: .delete ,encoding: JSONEncoding.default, headers: Auth_header)
                    .responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            print("Validation Successful")
                            
                            let json = JSON(value)
                            let responseHandler = ResponseSwift()
                            responseHandler.tag = tag
                            responseHandler.responseObject = json
                            _ = delegate.perform(requestFinished, with: responseHandler)
                        case .failure(let error):
                            
                            let responseHandler = ResponseSwift()
                            responseHandler.tag = tag
                            _ =  delegate.perform(requestFailed, with: responseHandler)
                            print(error)
                        }
                }
            
        }
        
        
    
    
    
    
    class func makeGetRequstDomainApi(url:String,domainToken:String,  delegate:AnyObject, requestFinished:Selector, requestFailed:Selector, tag:Int){
        
        
        let Auth_header: HTTPHeaders = [
            "Authorization": domainToken,
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        
        Alamofire.request(url, method: .get ,encoding: JSONEncoding.default, headers: Auth_header)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("Validation Successful")
                    
                    let json = JSON(value)
                    let responseHandler = ResponseSwift()
                    responseHandler.tag = tag
                    responseHandler.responseObject = json
                    _ = delegate.perform(requestFinished, with: responseHandler)
                case .failure(let error):
                    
                    let responseHandler = ResponseSwift()
                    responseHandler.tag = tag
                    _ =  delegate.perform(requestFailed, with: responseHandler)
                    print(error)
                }
        }
        
    }
    
    
    
    
    class func makeArryPutRequestUrl(url:String, arryParam:JSON, delegate:AnyObject, requestFinished:Selector, requestFailed:Selector, tag:Int){
        
        var awsToken = ""
     
                
        
                let requstUri = NSURL(string: url)
                
                
                var request = URLRequest(url: requstUri! as URL)
                request.httpMethod = "put"
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue(awsToken, forHTTPHeaderField: "Authorization")
                
                request.httpBody = try! JSONSerialization.data(withJSONObject:arryParam.rawValue)
                
                Alamofire.request(request)
                    .responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            
                            
                            let json = JSON(value)
                            let responseHandler = ResponseSwift()
                            responseHandler.tag = tag
                            responseHandler.responseObject = json
                            _ = delegate.perform(requestFinished, with: responseHandler)
                        case .failure(let error):
                            
                            let responseHandler = ResponseSwift()
                            responseHandler.tag = tag
                            _ =  delegate.perform(requestFailed, with: responseHandler)
                            print(error)
                        }
                }
                
                
        
        }
    
    
}



