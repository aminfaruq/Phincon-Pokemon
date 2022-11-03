//
//  UIView+Extensions.swift
//  Phincon-Pokemon-App
//
//  Created by Amin faruq on 02/11/22.
//

import UIKit

extension UIView {
    func setupViewFromXib<T: UIView>(_:T.Type) -> UIView {
        let nibName = String(describing: T.self)
        let nib = UINib(nibName: nibName, bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
}

extension UIViewController {
    func showAlert(msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
