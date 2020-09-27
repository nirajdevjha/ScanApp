//
//  UIView+Extension.swift
//  ScanApp
//
//  Created by Niraj Kumar Jha on 27/09/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import UIKit

public protocol NibLoadView: class { }

public extension NibLoadView {
    static var nibName: String {
        return String(describing: self)
    }
}

extension UIView: NibLoadView {}

protocol ReuseView: class { }

extension ReuseView where Self: UIView {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReuseView { }

extension UITableView {
    
    func register<T: UITableViewCell>(_: T.Type, bundle: Bundle? = nil) {
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forCellReuseIdentifier: T.identifier)
    }
    
    func dequeueReuseCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("failed to dequeue cell with identifier: \(T.identifier)")
        }
        return cell
    }
}

extension UIView {
    func addDashedLine(strokeColor: UIColor, lineWidth: CGFloat, lineDashPattern: [NSNumber]) {
        removeLayer("DashedLine")
        backgroundColor = .clear
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        shapeLayer.name = "DashedLine"
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: frame.width / 2, y: frame.height * 1.2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = lineDashPattern
        let path = CGMutablePath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: frame.width, y: 0))
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    func removeLayer(_ name: String) {
        let allLayers = layer.sublayers ?? []
        for layer in allLayers {
            if layer.name == name {
                layer.removeFromSuperlayer()
            }
        }
    }
}

