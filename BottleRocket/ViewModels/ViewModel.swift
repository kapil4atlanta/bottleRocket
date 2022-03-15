//
//  ViewModel.swift
//  BottleRocket
//
//  Created by Kapil Rathan on 3/9/22.
//

import Foundation
import Combine
import UIKit

final class ViewModel {

    let dataSource = CurrentValueSubject<DataModel?, Never>(nil)
    
    func getCellSize(isPad: Bool, orietation: UIDeviceOrientation, cellSpacing: CGFloat) -> CGSize {
        let itemsPerRow = isPad ? 2.0 : 1.0
        
        let totalSpaces = itemsPerRow + 1 // Spaces between cells and on the sides
        let totalSpace = cellSpacing * CGFloat(totalSpaces)
        let remainingWidth = UIScreen.main.bounds.width - totalSpace
        let cellWidth = floor(remainingWidth / CGFloat(itemsPerRow))
        var cellHeight = cellWidth * 0.75
        
        if isPad {
            switch orietation {
            case .landscapeLeft, .landscapeRight:
                cellHeight = cellWidth * 0.75
            case .faceDown, .faceUp:
                cellHeight = cellWidth * 1.25
            default:
                cellHeight = cellWidth * 1.25
            }
        }
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func getRestaurantData() {
        guard let url = URL(string: "https://s3.amazonaws.com/br-codingexams/restaurants.json") else { return }
        let congig = URLSessionConfiguration.default
        let request = URLRequest(url: url)
        let session = URLSession(configuration: congig)
        
        session.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data,
                    error == nil,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                      self?.dataSource.send(nil)
                      return
                  }
            do {
                let modelData = try JSONDecoder().decode(DataModel.self, from: data)
                self?.dataSource.send(modelData)
            }
            catch let(error) {
                print(error)
            }
            
        }.resume()
    }
}
