//
//  DetailViewController.swift
//  BottleRocket
//
//  Created by Kapil Rathan on 3/10/22.
//

import UIKit
import MapKit

final class DetailViewController: BaseViewController {
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private let restaurantView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(red: 52.0/255, green: 179.0/255, blue: 121.0/255, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    private let addressLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 42.0/255, green: 42.0/255, blue: 42.0/255, alpha: 1.0)
        label.font = UIFont(name: "Avenir Next Demi Regular", size: 12.0)
        label.numberOfLines = 0
        return label
    }()
    
    private let phoneLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 42.0/255, green: 42.0/255, blue: 42.0/255, alpha: 1.0)
        label.font = UIFont(name: "Avenir Next Demi Regular", size: 12.0)
        return label
    }()
    
    private let twitterLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 42.0/255, green: 42.0/255, blue: 42.0/255, alpha: 1.0)
        label.font = UIFont(name: "Avenir Next Demi Regular", size: 12.0)
        return label
    }()
    
    private let restaurant: Restaurant
    
    init(content: Restaurant) {
        self.restaurant = content
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupNavBar()
        setupMapView()
        setupLabels()
        setupAdress()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Lunch Tyme"
        self.view.backgroundColor = .white
        self.mapView.delegate = self
        self.mapView.backgroundColor = .yellow
        self.titleLabel.text = self.restaurant.name
        self.categoryLabel.text = self.restaurant.category
        self.addressLabel.text = self.getAddress()
        self.phoneLabel.text = self.restaurant.contact?.formattedPhone
        self.twitterLabel.text = self.getTwitter()
        setupMapAnnotation()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupNavBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "map"))
        
        let app = UITabBarAppearance()
        app.configureWithOpaqueBackground()
        app.backgroundColor = UIColor(red: 42/255, green: 42.0/255, blue: 42.0/255, alpha: 1.0)
        self.tabBarController?.tabBar.standardAppearance = app
        self.tabBarController?.tabBar.scrollEdgeAppearance = app
    }
    
    private func setupMapView() {
        
        self.view.addSubview(self.mapView)
        self.view.addSubview(self.restaurantView)
        
        let availableHeight = self.view.frame.height / 3
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalToConstant: availableHeight)
        ])

        NSLayoutConstraint.activate([
            restaurantView.topAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: 0),
            restaurantView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            restaurantView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            restaurantView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
    
    private func setupLabels() {
        self.restaurantView.addSubview(self.categoryLabel)
        let bottom = NSLayoutConstraint(item: self.categoryLabel, attribute: .bottom, relatedBy: .equal, toItem: self.restaurantView, attribute: .bottom, multiplier: 1, constant: -15)
        let left = NSLayoutConstraint(item: self.categoryLabel, attribute: .left, relatedBy: .equal, toItem: self.restaurantView, attribute: .left, multiplier: 1, constant: 12)
        NSLayoutConstraint.activate([bottom, left])
        
        self.restaurantView.addSubview(self.titleLabel)
        let bottom2 = NSLayoutConstraint(item: self.titleLabel, attribute: .bottom, relatedBy: .equal, toItem: self.self.categoryLabel, attribute: .top, multiplier: 1, constant: 6)
        let left2 = NSLayoutConstraint(item: self.titleLabel, attribute: .left, relatedBy: .equal, toItem: self.restaurantView, attribute: .left, multiplier: 1, constant: 12)
        NSLayoutConstraint.activate([bottom2, left2])
    }
    
    private func setupAdress() {
        self.view.addSubview(addressLabel)
        NSLayoutConstraint.activate([
            addressLabel.topAnchor.constraint(equalTo: self.restaurantView.bottomAnchor, constant: 16),
            addressLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            addressLabel.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -12),
            addressLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        self.view.addSubview(phoneLabel)
        NSLayoutConstraint.activate([
            phoneLabel.topAnchor.constraint(equalTo: self.addressLabel.bottomAnchor, constant: 26),
            phoneLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            phoneLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        self.view.addSubview(twitterLabel)
        NSLayoutConstraint.activate([
            twitterLabel.topAnchor.constraint(equalTo: self.phoneLabel.bottomAnchor, constant: 26),
            twitterLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            twitterLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupMapAnnotation() {
        self.mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: "Annotation")
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: self.restaurant.location?.lat ?? 0, longitude: self.restaurant.location?.lng ?? 0)
        
        self.mapView.removeAnnotations(mapView.annotations)
        
        if CLLocationCoordinate2DIsValid(location) {
            let radiusDelta = (1.0 / 69.0) * 3
            self.mapView.setRegion(MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: radiusDelta, longitudeDelta: radiusDelta)), animated: false)
        }
        
        let annotation = MKPointAnnotation()

        annotation.coordinate = location
        
        self.mapView.addAnnotation(annotation)
        let mkView = MKAnnotationView()
        mkView.annotation = annotation
        mkView.isEnabled = true
        
    }
    
    private func getAddress() -> String {
        let address = self.restaurant.location?.address ?? ""
        let city = self.restaurant.location?.city ?? ""
        let state = self.restaurant.location?.state ?? ""
        let code = self.restaurant.location?.postalCode ?? ""
        return address + " " + city + ", " + state + " " + code
    }
    
    private func getTwitter() -> String {
        guard let twitter = self.restaurant.contact?.twitter, twitter.isEmpty == false else {
            return ""
        }
        return "@" + twitter
    }
}

extension DetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else {
            let pinIdent = "Annotation"
            var pinView: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdent) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                pinView = dequeuedView
            } else {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdent)
            }
            return pinView
        }
    }
}



