//
//  ImageChacheManager.swift
//  kidsbook
//
//  Created by paytalab on 8/10/24.
//

import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()
    private init() {}

    private let cache = NSCache<NSString, UIImage>()

    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        
        if let fileURL = fileURL(for: key), let data = image.pngData() {
            do {
                try data.write(to: fileURL)
            } catch {
                print("Failed to save data: \(error)")
            }
        }

    }
    
    func image(forKey key: String) -> UIImage? {
        if let image = cache.object(forKey: key as NSString) {
            return image
        }
        
        if let fileURL = fileURL(for: key),
           let imageData = try? Data(contentsOf: fileURL),
           let image = UIImage(data: imageData) {
            cache.setObject(image, forKey: key as NSString)
            return image
        }
        return nil
        
    }
    
    private func fileURL(for key: String) -> URL? {
        let fileManager = FileManager.default
        guard let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        return cacheDirectory.appendingPathComponent(key.replacingOccurrences(of: "/", with: "-"))
    }
}
