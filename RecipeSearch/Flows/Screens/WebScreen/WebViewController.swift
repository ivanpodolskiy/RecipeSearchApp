//
//  WebViewController.swift
//  RecipeSearch
//
//  Created by user on 29.05.2023.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    init?(title: String, url: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        if !self.loadUrl(link: url){ return nil }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        addSubviewsAndSetupLayout()
    }
    
    private func addSubviewsAndSetupLayout() {
        view.addSubview(webView)
        view.addSubview(progressView)
        setupLayout()
    }
    
    private func setupLayout() {
        webView.frame = view.bounds
        progressView.frame = CGRect(x: 10, y: 93, width: view.frame.size.width - 20, height: 50)
    }

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        return webView
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.alpha = 0
        progressView.trackTintColor = .white
        progressView.progressTintColor = .basic
        return progressView
    }()
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
           let estimatedProgress = Float(self.webView.estimatedProgress)
            updateProgress(estimatedProgress)
        }
    }
    
    private func updateProgress(_ progress: Float) {
        DispatchQueue.main.async {
            self.progressView.progress = progress
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
}
//MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showProgressView()
    }
    
    private func showProgressView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) { self.progressView.alpha = 1 }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideProgressView()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideProgressView()
    }
    
    private func hideProgressView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) { self.progressView.alpha = 0 }
        }
    }
}
