//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import UIKit

extension UIView {

    class AppGradient: CAGradientLayer {}
    func insertGradient(colors: [UIColor]) {
        removeGradient()
        let gradient = AppGradient()
        gradient.colors = colors.map({ $0.cgColor })
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
    }

    func applyGradient(colors: [UIColor],
                       startPoint: CGPoint,
                       endPoint: CGPoint) {
        removeGradient()
        let gradient = AppGradient()
        gradient.colors = colors.map({ $0.cgColor })
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
    }

    func removeGradient() {
        if let gradient = layer.sublayers?.first(where: { $0.isKind(of: AppGradient.self )}) {
            gradient.removeFromSuperlayer()
        }
    }
}

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        xOrigin: CGFloat = 0,
        yOrigin: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: xOrigin, height: yOrigin)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dxOrigin = -spread
            let rect = bounds.insetBy(dx: dxOrigin, dy: dxOrigin)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    func applySketchShadow(shadow: ShadowStyle) {
        shadowColor = shadow.color.cgColor
        shadowOpacity = shadow.alpha
        shadowOffset = CGSize(width: shadow.xOrigin, height: shadow.yOrigin)
        shadowRadius = shadow.blur / 2.0
        if shadow.spread == 0 {
            shadowPath = nil
        } else {
            let dxOrigin = -shadow.spread
            let rect = bounds.insetBy(dx: dxOrigin, dy: dxOrigin)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

struct ShadowStyle {
    var color: UIColor = .clear
    var alpha: CFloat = 0
    var xOrigin: CGFloat = 0
    var yOrigin: CGFloat = 0
    var blur: CGFloat = 0
    var spread: CGFloat = 0

    public init(color: UIColor, alpha: CFloat, xOrigin: CGFloat, yOrigin: CGFloat, blur: CGFloat, spread: CGFloat) {
        self.color = color
        self.alpha = alpha
        self.xOrigin = xOrigin
        self.yOrigin = yOrigin
        self.blur = blur
        self.spread = spread
    }
}

extension UIView {

    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowOpacity = 0.4
            layer.shadowRadius = newValue
        }
    }

    func addTapGesture(tapNumber: Int = 1, target: Any, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }

    func addNotificationObserver(name: Notification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }

    struct AnchorOptions: OptionSet {

        let rawValue: Int

        init(rawValue: Int) {
            self.rawValue = rawValue
        }

        static let top = UIView.AnchorOptions(rawValue: 1 << 0)

        static let leading = UIView.AnchorOptions(rawValue: 1 << 1)

        static let trailing = UIView.AnchorOptions(rawValue: 1 << 2)

        static let bottom = UIView.AnchorOptions(rawValue: 1 << 3)

        static let all: UIView.AnchorOptions = [.top, .leading, .trailing, .bottom]
    }

    func anchor(toView view: UIView?, insets: UIEdgeInsets = .zero, anchorOptions options: AnchorOptions = .all) {
        guard let view = view else { return }
        translatesAutoresizingMaskIntoConstraints = false

        if options.contains(.top) {
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).isActive = true
        }
        if options.contains(.leading) {
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left).isActive = true
        }
        if options.contains(.trailing) {
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: insets.right).isActive = true
        }
        if options.contains(.bottom) {
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom).isActive = true
        }
    }

    func anchorToSuperView(with insets: UIEdgeInsets = .zero) {
        guard let superview = superview else { return }
        anchor(toView: superview, insets: insets)
    }

    func heightAnchor(_ constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: constant).isActive = true
    }

    func widthAnchor(_ constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: constant).isActive = true
    }

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius,
                                                    height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIView {

    enum BorderPostition {
        case top
        case left
        case bottom
        case right
    }

    func border(_ pos: BorderPostition, color: UIColor = UIColor.black, width: CGFloat = 0.5, insets: UIEdgeInsets = UIEdgeInsets.zero) {
        let oldView = subviews.first { $0.tag == 99 }
        oldView?.removeFromSuperview()
        let rect: CGRect = {
            switch pos {
            case .top: return CGRect(x: 0, y: 0, width: frame.width, height: width)
            case .left: return CGRect(x: 0, y: 0, width: width, height: frame.height)
            case .bottom:
                let origin = CGPoint(x: insets.left, y: frame.height - width)
                let size = CGSize(width: frame.width - (insets.left + insets.right), height: width)
                return CGRect(origin: origin, size: size)
            case .right: return CGRect(x: frame.width - width, y: 0, width: width, height: frame.height)
            }
        }()
        let border = UIView(frame: rect)
        border.tag = 99 // Mask for remove
        border.backgroundColor = color
        border.autoresizingMask = {
            switch pos {
            case .top: return [.flexibleWidth, .flexibleBottomMargin]
            case .left: return [.flexibleHeight, .flexibleRightMargin]
            case .bottom: return [.flexibleWidth, .flexibleTopMargin]
            case .right: return [.flexibleHeight, .flexibleLeftMargin]
            }
        }()
        addSubview(border)
    }

    func centerVerticallyToSuperView(_ constant: CGFloat = 0) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: constant).isActive = true
    }

    func centerHorrizontallyToSuperView(_ constant: CGFloat = 0) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: constant).isActive = true
    }

    func removeMultiTouch() {
        subviews.forEach {
            $0.isExclusiveTouch = true
            $0.removeMultiTouch()
        }
    }

    class func loadNib<T: UIView>() -> T {
        let name = String(describing: self)
        let bundle = Bundle(for: T.self)
        guard let xib = bundle.loadNibNamed(name, owner: nil, options: nil)?.first as? T else {
            fatalError("Cannot load nib named `\(name)`")
        }
        return xib
    }
}


extension UIView {

    func addShadow(ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0), radius: CGFloat = 1, offset: CGSize = .zero, opacity: Float = 0.5) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }

    func addBorder(edges: [UIRectEdge], borderColor: UIColor?, borderWidth: CGFloat) {
        layer.sublayers?.removeAll(where: { $0.name == "BorderEdge" })
        for edge in edges {
            let border = CALayer()
            border.name = "BorderEdge"
            if edge == .all {
                layer.borderWidth = borderWidth
                layer.borderColor = borderColor?.cgColor
                break
            }
            switch edge {
            case .top:
                border.frame = CGRect(x: 0, y: 0, width: frame.width, height: borderWidth)
            case .bottom:
                border.frame = CGRect(x: 0, y: frame.height - borderWidth, width: frame.width, height: borderWidth)
            case .left:
                border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: frame.height)
            case .right:
                border.frame = CGRect(x: frame.width - borderWidth, y: 0, width: borderWidth, height: frame.height)
            default:
                break
            }
            border.backgroundColor = borderColor?.cgColor
            layer.addSublayer(border)
        }
        layer.masksToBounds = true
    }
}

final class BorderView: UIView {

    var addBorderClosure: (()-> Void)?

    override var bounds: CGRect {
        didSet {
            addBorderClosure?()
        }
    }
}

