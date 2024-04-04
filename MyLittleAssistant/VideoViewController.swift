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

        reproducirVideo(videoURL: "https://www.twitch.tv/les_simpso")
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            webView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            webView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8), // Ancho al 80% de la vista
            webView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5) // 
        ])
    }

    func reproducirVideo(videoURL: String) {
        guard let url = URL(string: videoURL) else {
            print("URL del video no válida")
            return
        }

        let request = URLRequest(url: url)
        webView.load(request)
    }

}
