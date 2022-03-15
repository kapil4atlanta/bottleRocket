//
//  ViewController.swift
//  BottleRocket
//
//  Created by Kapil Rathan on 3/9/22.
//

import UIKit
import Combine

final class ViewController: BaseViewController {

    private let viewModel = ViewModel()
    private var data: DataModel?
    private var publishers = Set<AnyCancellable>()
    private var currentOrientation: UIDeviceOrientation = .portrait
    private let cellSpacing: CGFloat = 16.0
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RestaurantCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()
    
    override func loadView() {
        super.loadView()
        setupNavBar()
        setupCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        setCollectionViewDelegates()
        setupData()
        self.viewModel.getRestaurantData()
    }
    
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "map"))
    }
    
    private func setCollectionViewDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupData() {
        self.currentOrientation = UIDevice.current.orientation
        self.viewModel.dataSource.sink { [weak self] result in
            self?.data = result
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }.store(in: &self.publishers)
    }
    
    private func isIpad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if currentOrientation != UIDevice.current.orientation {
            currentOrientation = UIDevice.current.orientation
            self.collectionView.reloadData()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.data?.restaurants?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? RestaurantCollectionViewCell,
              indexPath.row < self.data?.restaurants?.count ?? 0 else {
            return UICollectionViewCell()
        }
        cell.addContent(content: self.data?.restaurants?[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedItem = self.data?.restaurants?[indexPath.row] {
            let vc = DetailViewController(content: selectedItem)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.viewModel.getCellSize(isPad: self.isIpad(), orietation: self.currentOrientation, cellSpacing: cellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
    }

}
