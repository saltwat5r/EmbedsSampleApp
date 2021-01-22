//
//  NewsViewController.swift
//  EmbedsSampleApp
//
//

import UIKit
import WebKit

class NewsViewController: UIViewController {

    let scrollView: UIScrollView = ViewsFactory.makeScrollView()
    let contentView = UIView()
    var webView: WKWebView?
    private var webViewContentSizeContext = 0
    private var webViewHeightConstraint: NSLayoutConstraint?
    var thumbnailHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }

    func configureViews() {
        self.view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])

        contentView.backgroundColor = .yellow
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])

        let lbl1 = ViewsFactory.makeTextLabel()
        lbl1.backgroundColor = .red
        contentView.addSubview(lbl1)
        NSLayoutConstraint.activate([
            lbl1.topAnchor.constraint(equalTo: contentView.topAnchor),
            lbl1.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            lbl1.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8)
        ])

        let webView = makeWebView()
        contentView.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: lbl1.bottomAnchor),
            webView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            webView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        webViewHeightConstraint = webView.heightAnchor.constraint(equalToConstant: 10)
        webViewHeightConstraint?.isActive = true
        self.webView = webView

        let lbl2 = ViewsFactory.makeTextLabel()
        lbl2.backgroundColor = .blue
        contentView.addSubview(lbl2)
        NSLayoutConstraint.activate([
            lbl2.topAnchor.constraint(equalTo: webView.bottomAnchor),
            lbl2.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            lbl2.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            lbl2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        getInstagramData()
    }

    private func makeWebView() -> WKWebView {
        let config = WKWebViewConfiguration()
        let initScale = 0.8
        let javascriptCSS = "var meta = document.createElement('meta'); meta.name = 'viewport'; meta.content = 'width=device-width, height=device-height, initial-scale=\(initScale), maximum-scale=1.0, user-scalable=no'; document.head.appendChild(meta)"
        let script = WKUserScript(source: javascriptCSS, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        config.userContentController.addUserScript(script)

        let endscript = "window.webkit.messageHandlers.onEndLoading.postMessage(document.URL)"
        let onEndScript = WKUserScript(source: endscript, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        config.userContentController.addUserScript(onEndScript)

        let webView = WKWebView(frame: CGRect.zero, configuration: config)
        webView.scrollView.isScrollEnabled = false
        webView.navigationDelegate = self

        webView.scrollView.addObserver(self, forKeyPath: "contentSize", options: [.old, .new], context: &webViewContentSizeContext)

        return webView
    }

    private func getInstagramData() {
        if let url = URL(string: getFacebookApiUrl(endpoint: "instagram_oembed", url: getIdFromUrl("https://www.instagram.com/p/CId62SVsIkq"))) {
            URLSession.shared.dataTask(with: url, completionHandler: {
                [weak self] (data, response, error) in
                if nil != data {
                    do {
                        let instagram = try JSONDecoder().decode(Instagram.self, from: data!)
                        DispatchQueue.main.async {
                            self?.thumbnailHeight = instagram.thumbnailHeight
                            self?.webViewHeightConstraint?.constant = instagram.thumbnailHeight
                            self?.webView?.layoutIfNeeded()
                            if let webView = self?.webView {
                                self?.loadHTMLContent(instagram.html, into: webView)
                            }
                        }
                    } catch {
                        print("Exception while parsing instagram data: \(error)")
                    }
                }
            }).resume()
        }
    }

    func getIdFromUrl(_ url: String) -> String {
        let urlParts = url.components(separatedBy: "/")
        if urlParts.count >= 5 {
            return "https://www.instagram.com/p/" + urlParts[4]
        }
        return ""
    }

    private func getFacebookApiUrl(endpoint: String, url: String) -> String {
        return "https://graph.facebook.com/v9.0/\(endpoint)?url=\(url)/&access_token=\(getFacebookAccesToken())&maxwidth=\(getDeviceWidth())"
    }

    func loadHTMLContent(_ htmlContent: String, into webView: WKWebView) {
         webView.loadHTMLString("<HTML><div align=\"center\">" + htmlContent + "</div></HTML>", baseURL: URL(string: "https://instagram.com")!)
    }

    func socialComponentDidUpdateHeight() {
        contentView.layoutIfNeeded()
    }

    private func getFacebookAccesToken() -> String {
        var facebookAppID = ""
        var facebookClientToken = ""
        if let infoDict = Bundle.main.infoDictionary {
            facebookAppID = infoDict["FacebookAppID"] as! String
            facebookClientToken = infoDict["FacebookClientToken"] as! String
        }

        return "\(facebookAppID)%7C\(facebookClientToken)"
    }

    private func getDeviceWidth() -> CGFloat {
        let bounds = UIScreen.main.bounds
        if bounds.size.height > bounds.size.width {
            return bounds.size.width
        }
        return bounds.size.height
    }

    private func log(_ str: String) {
        print("⚠️ " + str)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if context == &webViewContentSizeContext {
            if keyPath == "contentSize" {
                if let oldContentSize = change?[.oldKey] as? CGSize, let contentSize = change?[.newKey] as? CGSize {
                    if oldContentSize.height != contentSize.height && nil != webView && !webView!.isLoading {
                        DispatchQueue.main.async {
                            self.log("HEIGHT - observed content size: \(contentSize.height)")
                            let height = contentSize.height
                            self.webViewHeightConstraint?.constant = height
                            self.webView?.layoutIfNeeded()
                            self.socialComponentDidUpdateHeight()
                        }
                    }
                }
            }
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
    }
}

extension NewsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            if let url = navigationAction.request.url {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }
}

