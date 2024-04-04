//
//  VideoViewController.swift
//  MyLittleAssistant
//
//  Created by david gomez herrera on 04/04/24.
//

import UIKit
import WebKit

class VideoViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        reproducirVideo(videoURL: "https://cdn.pixabay.com/video/2020/08/27/48420-453832153_large.mp4")
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            webView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            webView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2.0/3.0),
            webView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1.0/3.0)
        ])
    }

    func reproducirVideo(videoURL: String) {
        guard let url = URL(string: videoURL + "?autoplay=0") else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }


}
