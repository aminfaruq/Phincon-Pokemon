//
//  LoadingView.swift
//  Phincon-Pokemon-App
//
//  Created by Amin faruq on 02/11/22.
//

import UIKit

class LoadingView: UIView {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgViewWidth: NSLayoutConstraint!
    var view: UIView!
    var backgroundView: UIView!
    
    // width / height
    @IBOutlet weak var imgViewHeightRatio: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupXib(with: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupXib()
    }
    
    private func setupXib(with frame: CGRect = .zero) {
        let view = setupViewFromXib(LoadingView.self)
        view.frame = frame
        addSubview(view)
        self.view = view
        
        addBackground()
    }
    
    private func addBackground() {
        let width = view.frame.width * imgViewWidth.multiplier
        let height = width / imgViewHeightRatio.multiplier
        
        let v = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        v.backgroundColor = .white
        v.center = view.center
        v.layer.cornerRadius = imgView.layer.cornerRadius
        view.insertSubview(v, belowSubview: imgView)
        
        backgroundView = v
    }
    
    func showResult(with result: PokemonCatchResult, completion: @escaping (Bool)->Void) {
        imgView.isHidden = true
        let x = backgroundView.bounds.midX
        let y = backgroundView.bounds.minY + 5
        let height = backgroundView.bounds.height / 2
        let width = height
        
        let v = UIImageView(frame: CGRect(x: 0, y: y, width: 0, height: 0))
        v.center.x = x
        v.image = .load(image: result.imageName)
        
        backgroundView.addSubview(v)
        
        let label = UILabel(frame: CGRect(x: 0, y: v.frame.minX, width: backgroundView.bounds.width, height: 20))
        label.textAlignment = .center
        label.center.x = backgroundView.bounds.midX
        label.text = result.message
        label.textColor = hexStringToUIColor(hex: "#5D9FFE")
        label.font = UIFont.systemFont(ofSize: 13)
        backgroundView.addSubview(label)
        
        UIView.animate(withDuration: 0.1, delay: .zero, options: .curveEaseInOut, animations: {
            v.frame = CGRect(x: 0, y: y, width: width, height: height)
            v.center.x = x
        }, completion: completion)
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UIViewController {
    
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.red.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

