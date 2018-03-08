//
//  editViewController.swift
//  3DTouch
//
//  Created by mac on 2017/8/18.
//  Copyright © 2017年 SnowCheng. All rights reserved.
//

import UIKit

class editViewController: ViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var contentField: UITextView!
    
    @IBAction func sendURL(_ sender: UIButton) {
        let title = titleField.text
        let content = contentField.text
        let params: [String: String] = ["title": title!,
                                        "content": content!]
        
        var hostString = "http://127.0.0.1:8888/"
        let escapeQueryString = query(params)   //对参数进行URL编码
        
        let url: URL = URL(string: hostString)!
        let request: NSMutableURLRequest = NSMutableURLRequest.init(url: url)
        request.httpMethod = "POST" //指定请求方式
        
        let session: URLSession = URLSession.shared
        let sessionTask: URLSessionDataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            if error != nil {
                return
            }
            if data != nil {    //对Data进行Json解析
                guard let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) else {
                    return
                }
                
                guard let jsonDic = json as? [String: Any] else {
                    return
                }
                
                let result = jsonDic["status"] as! Int
                if result == 200{
                    print("success")
                }else{
                    
                }
            }
        });
        sessionTask.resume()
        
    }
    
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        } else if let value = value as? NSNumber {
            components.append((escape(key), escape("\(value)")))
        } else if let bool = value as? Bool {
            components.append((escape(key), escape((bool ? "1" : "0"))))
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }
    
    /**
     
     - parameter string: 要转义的字符串
     
     - returns: 转义后的字符串
     */
    public func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        var escaped = ""
        
        if #available(iOS 8.3, *) {
            escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        } else {
            let batchSize = 50
            var index = string.startIndex
            
            while index != string.endIndex {
                let startIndex = index
                let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
                let range = startIndex..<endIndex
                
                let substring = string.substring(with: range)
                
                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? substring
                
                index = endIndex
            }
        }
        
        return escaped
    }
    
    
    
}
