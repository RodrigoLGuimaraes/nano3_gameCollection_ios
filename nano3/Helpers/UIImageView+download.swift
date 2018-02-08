//
//  UIImageView+download.swift
//  appSuggest
//
//  Created by Rodrigo Guimaraes on 2017-10-27.
//  Copyright © 2017 RodrigoLG. All rights reserved.
//

import UIKit
import ObjectiveC

//FONTE: https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift

//private var chaveDeAssociacaoLinhaAtual : UInt8 = 0
private var chaveDeAssociacaoDataTask : UInt8 = 1

extension UIImageView {
    
//    var linhaAtual : Int {
//        get{
//            return objc_getAssociatedObject(self, &chaveDeAssociacaoLinhaAtual) as! Int
//        }
//        set(newValue){
//            objc_setAssociatedObject(self, &chaveDeAssociacaoLinhaAtual, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
//        }
//    }
    
    var tarefaDeDownload : URLSessionDataTask?{
        get{
            return objc_getAssociatedObject(self, &chaveDeAssociacaoDataTask) as? URLSessionDataTask
        }
        set(newValue){
            objc_setAssociatedObject(self, &chaveDeAssociacaoDataTask, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        
        if let tarefaAntigaDeDownload = self.tarefaDeDownload{
            tarefaAntigaDeDownload.cancel()
        }
        
        self.tarefaDeDownload = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            
            DispatchQueue.main.async() {
                self.image = image
            }
            
            }
        
        self.tarefaDeDownload?.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        var adjustedLink = link
        if !link.starts(with: "http") {
            adjustedLink = "https:" + link
        }
        guard let url = URL(string: adjustedLink) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
