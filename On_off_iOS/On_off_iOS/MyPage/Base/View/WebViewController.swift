//
//  WebViewController.swift
//  On_off_iOS
//
//  Created by 정호진 on 2/16/24.
//

import Foundation
import SnapKit
import UIKit
import WebKit

final class WebViewController: UIViewController {
    
    /// 웹뷰
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        
        return view
    }()
    
    var url: String?
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
    }
    
    /// Add SubViews
    private func addSubViews() {
        view.addSubview(webView)
        
        constraints()
        loadURL()
    }
    
    /// Constraints
    private func constraints() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    /// Load URL Link
    private func loadURL() {
        guard let url = URL(string: url ?? "") else { return }
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
}
