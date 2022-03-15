//
//  RestaurantCollectionViewCell.swift
//  BottleRocket
//
//  Created by Kapil Rathan on 3/9/22.
//

import UIKit
import Combine

final class RestaurantCollectionViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "Avenir Next Demi Bold", size: 16.0)
        return label
    }()
    
    private let categoryLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "Avenir Next Demi Regular", size: 12.0)
        return label
    }()
    
    private var subscriptions = Set<AnyCancellable>()
    private let imageViewModel = ImageDownloaderViewModel()
    
    var imageUrl: String? {
        didSet {
            imageViewModel.download(urlString: imageUrl ?? "")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupBindings()
        self.setupImageView()
        self.setupLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView() {
        contentView.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    private func setupLabels() {
        contentView.addSubview(categoryLabel)
        let bottom = NSLayoutConstraint(item: self.categoryLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -6)
        let left = NSLayoutConstraint(item: self.categoryLabel, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 12)
        NSLayoutConstraint.activate([bottom, left])
        
        contentView.addSubview(titleLabel)
        let bottom2 = NSLayoutConstraint(item: self.titleLabel, attribute: .bottom, relatedBy: .equal, toItem: categoryLabel, attribute: .top, multiplier: 1, constant: 6)
        let left2 = NSLayoutConstraint(item: self.titleLabel, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 12)
        NSLayoutConstraint.activate([bottom2, left2])
        
    }
    
    
    private func setupBindings() {
        imageViewModel
            .image
            .sink { [weak self] image in
                guard let image = image else { return }
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
            .store(in: &subscriptions)
    }
    
    func addContent(content: Restaurant?) {
        guard let content = content else {
            return
        }

        self.imageUrl = content.backgroundImageURL
        self.titleLabel.text = content.name
        self.categoryLabel.text = content.category
    }
}
