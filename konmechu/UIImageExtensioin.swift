

import UIKit

class UIImageExtension: UIImage {

}

extension UIImage {
    //Image resize Function
    func resize(targetSize: CGSize) -> UIImage? {
            let newRect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height).integral
            UIGraphicsBeginImageContextWithOptions(newRect.size, true, 0)
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            context.interpolationQuality = .high
            draw(in: newRect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        }
}

