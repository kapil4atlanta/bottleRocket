//
//  InternetViewController.swift
//  BottleRocket
//
//  Created by Kapil Rathan on 3/10/22.
//

import UIKit
import WebKit

final class InternetViewController: BaseViewController {
    private let urlString = "https://www.bottlerocketstudios.com"
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let activityView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func loadView() {
        super.loadView()
        setupWKWebView()
        setupActivity()
        setupNavBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: urlString) {
            self.activityView.startAnimating()
            let request = URLRequest(url: url)
            self.webView.navigationDelegate = self
            self.loadToWebView(request: request)
        }

    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupNavBar() {
        
        let leftButton = UIBarButtonItem(image: UIImage(named: "previous"), style: .plain, target: self, action: #selector(backTapped))
        let refreshButton = UIBarButtonItem(image: UIImage(named: "refresh"),
            style: .plain, target: self, action: #selector(refreshTapped))
        let forwardButton = UIBarButtonItem(image: UIImage(named: "forward"),
            style: .plain, target: self, action: #selector(forwardTapped))
        self.navigationItem.leftBarButtonItems = [leftButton, refreshButton, forwardButton]
    }
    
    private func setupWKWebView() {
        self.view.addSubview(webView)
        webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    private func setupActivity() {
        self.view.addSubview(activityView)
        activityView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    private func loadToWebView(request: URLRequest) {
        DispatchQueue.main.async {
            _ = self.webView.load(request)
        }
    }
    
    @objc
    private func backTapped() {
        self.webView.goBack()
    }
    
    @objc
    private func refreshTapped() {
        self.webView.reload()
    }
    
    @objc
    private func forwardTapped() {
        self.webView.goForward()
    }
}

extension InternetViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityView.stopAnimating()
    }
}
