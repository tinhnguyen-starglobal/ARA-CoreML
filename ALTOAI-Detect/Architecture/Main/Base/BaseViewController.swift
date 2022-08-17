//
//  BaseViewController.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 10/08/2022.
//

import UIKit
import Combine

public class BaseViewController: UIViewController {
    
    var cancellable = Set<AnyCancellable>()
    
    // MARK: - Methods
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Loading this view controller from a nib is unsupported")
    }
    
    deinit {
        debugPrint("\(type(of: self)) deinit⚡️")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        self.view.backgroundColor = .white
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }
}
