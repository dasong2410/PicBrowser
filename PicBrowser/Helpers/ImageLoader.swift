//
//  ImageLoader.swift
//  PicBrowser
//
//  Created by Marcus Mao on 3/31/22.
//

import Foundation
import UIKit

class ImageLoader: ObservableObject {
    @Published var url: String?
    @Published var image: UIImage? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    init(url: String?) {
        self.url = url
        
        fetch()
    }
    
    func fetch() {
        guard image == nil && !isLoading else {
            return
        }
        
        guard let url = url, let fetchURL = URL(string: url) else {
            errorMessage = "bad url"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let request = URLRequest(url: fetchURL, cachePolicy: .returnCacheDataElseLoad)
//        let request = URLRequest(url: fetchURL, cachePolicy: .reloadRevalidatingCacheData)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "error 1"
                } else if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    self?.errorMessage = "error 2"
                } else if let data = data, let image = UIImage(data: data) {
//                    print(data)
                    self?.image = image
                } else {
                    self?.errorMessage = "error 3"
                }
            }
           
        }
        
        task.resume()
    }
}
