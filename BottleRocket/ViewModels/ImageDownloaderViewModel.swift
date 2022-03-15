//
//  ImageDownloaderViewModel.swift
//  BottleRocket
//
//  Created by Kapil Rathan on 3/10/22.
//

import Foundation
import Combine
import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

final class ImageDownloaderViewModel {
    
    let image = PassthroughSubject<UIImage?, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    func download(urlString: String) {
        
        if let image = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image.send(image)
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession
            .shared
            .dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .sink { result in
                print(result)
            } receiveValue: { [weak self] result in
                if let image = UIImage(data: result.data) {
                    self?.image.send(image)
                    self?.image.send(completion: .finished)
                    imageCache.setObject(image, forKey: url as AnyObject)
                    print("Image Received")
                }
            }
            .store(in: &subscriptions)

    }
}
