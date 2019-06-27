//
//  PdfViewerViewController.swift
//  E Balloon
//
//  Created by VAP on 22/08/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit

class PdfViewerViewController: UIViewController,UIWebViewDelegate {
    var strPdflink:String?
    @IBOutlet weak var webPdfViewer: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webPdfViewer.delegate = self
        let url: URL! = URL(string: strPdflink!)
        webPdfViewer.loadRequest(URLRequest(url: url))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = "Pdf View"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        ActivityIndicator().hideActivityIndicatory(uiView: self.view)
    }

}
