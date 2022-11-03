//
//  UIImage+Helpers.swift
//  Phincon-Pokemon-App
//
//  Created by Amin faruq on 02/11/22.
//

import UIKit

extension UIImage {
    static func gif(with name: String, to pointSize: CGSize) -> [UIImage]? {
        guard let path = Bundle.main.path(forResource: name, ofType: "gif") else {
            print("Error: Gif with name \(name) not found.")
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard let gifData = try? Data(contentsOf: url),
              let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for i in 0 ..< imageCount {
            if let image = downsample(with: source, i, to: pointSize) {
                images.append(UIImage(cgImage: image))
            }
        }
        return images
    }
    private static func downsample(with imageSource: CGImageSource,_ index: Int, to pointSize: CGSize) -> CGImage? {
        let scale = UIScreen.main.scale
        let maxDimentionInPixels = max(pointSize.width, pointSize.height) * scale
        
        let downsampledOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
                                          kCGImageSourceShouldCacheImmediately: true,
                                    kCGImageSourceCreateThumbnailWithTransform: true,
                                           kCGImageSourceThumbnailMaxPixelSize: maxDimentionInPixels] as CFDictionary
        return CGImageSourceCreateThumbnailAtIndex(imageSource, index, downsampledOptions)
    }
}
