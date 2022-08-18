//
//  DynamicTableView.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 18/08/2022.
//

import UIKit

class DynamicTableView: UITableView {
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }

    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }

    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}
