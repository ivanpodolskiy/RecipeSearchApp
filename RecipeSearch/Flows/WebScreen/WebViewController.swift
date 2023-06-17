//
//  WebViewController.swift
//  RecipeSearch
//
//  Created by user on 29.05.2023.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    init?(name: String, url: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = name
        if !self.loadUrl(link: url){ return nil }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        webView.navigationDelegate = self
        self.progressView.alpha = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        view.addSubview(progressView)
        self.tabBarController?.tabBar.isHidden = true
        
        webView.frame = view.bounds
        progressView.frame = CGRect(x: 10, y: 93, width: view.frame.size.width - 20, height: 50)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    //MARK: - Outlets
    private let webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackTintColor = .white
        progressView.progressTintColor = .basic
        return progressView
    }()
    
    //MARK: - Functions
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            DispatchQueue.main.async {
                self.progressView.progress = Float(self.webView.estimatedProgress)
            }
        }
    }
    
    private func loadUrl(link: String) -> Bool{
        guard let url = URL(string: link) else { return false }
        DispatchQueue.main.async {
            self.webView.load(URLRequest(url: url))
            self.webView.allowsBackForwardNavigationGestures = true
        }
        return true
    }
    
    private func showProgressView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) { self.progressView.alpha = 1 }
        }
    }
    
    private func hideProgressView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) { self.progressView.alpha = 0 }
        }
    }
}
//MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showProgressView()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideProgressView()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideProgressView()
    }
}
