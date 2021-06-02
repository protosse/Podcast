//
//  UIView+Positioning.swift
//  Podcast
//
//  Created by liuliu on 2021/6/1.
//

import UIKit

public extension UIView {
    /// View's Origin point.
    @objc
    var origin: CGPoint {
        set { self.frame = CGRect(x: _pixelIntegral(newValue.x),
            y: _pixelIntegral(newValue.y),
            width: self.width,
            height: self.height)
        }
        get { return self.frame.origin }
    }

    // MARK: - Extra Properties

    /// View's right side (x + width).
    @objc
    var right: CGFloat {
        set { self.x = newValue - self.width }
        get { return self.x + self.width }
    }

    /// View's bottom (y + height).
    @objc
    var bottom: CGFloat {
        set { self.y = newValue - self.height }
        get { return self.y + self.height }
    }

    /// View's top (y).
    @objc
    var top: CGFloat {
        set { self.y = newValue }
        get { return self.y }
    }

    /// View's left side (x).
    @objc
    var left: CGFloat {
        set { self.x = newValue }
        get { return self.x }
    }

    /// View's center X value (center.x).
    @objc
    var centerX: CGFloat {
        set { self.center = CGPoint(x: newValue, y: self.centerY) }
        get { return self.center.x }
    }

    /// View's center Y value (center.y).
    @objc
    var centerY: CGFloat {
        set { self.center = CGPoint(x: self.centerX, y: newValue) }
        get { return self.center.y }
    }

    /// Last subview on X Axis.
    @objc
    var lastSubviewOnX: UIView? {
        return self.subviews.reduce(UIView(frame: .zero)) {
            return $1.x > $0.x ? $1 : $0
        }
    }

    /// Last subview on Y Axis.
    @objc
    var lastSubviewOnY: UIView? {
        return self.subviews.reduce(UIView(frame: .zero)) {
            return $1.y > $0.y ? $1 : $0
        }
    }

    // MARK: - Bounds Methods

    /// X value of bounds (bounds.origin.x).
    @objc
    var boundsX: CGFloat {
        set { self.bounds = CGRect(x: _pixelIntegral(newValue),
            y: self.boundsY,
            width: self.boundsWidth,
            height: self.boundsHeight)
        }
        get { return self.bounds.origin.x }
    }

    /// Y value of bounds (bounds.origin.y).
    @objc
    var boundsY: CGFloat {
        set { self.frame = CGRect(x: self.boundsX,
            y: _pixelIntegral(newValue),
            width: self.boundsWidth,
            height: self.boundsHeight)
        }
        get { return self.bounds.origin.y }
    }

    /// Width of bounds (bounds.size.width).
    @objc
    var boundsWidth: CGFloat {
        set { self.frame = CGRect(x: self.boundsX,
            y: self.boundsY,
            width: _pixelIntegral(newValue),
            height: self.boundsHeight)
        }
        get { return self.bounds.size.width }
    }

    /// Height of bounds (bounds.size.height).
    @objc
    var boundsHeight: CGFloat {
        set { self.frame = CGRect(x: self.boundsX,
            y: self.boundsY,
            width: self.boundsWidth,
            height: _pixelIntegral(newValue))
        }
        get { return self.bounds.size.height }
    }

    // MARK: - Private Methods
    fileprivate func _pixelIntegral(_ pointValue: CGFloat) -> CGFloat {
        let scale = UIScreen.main.scale
        return (round(pointValue * scale) / scale)
    }
}
