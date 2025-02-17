//
//  NukeProxy.swift
//  NukeProxy
//
//  Created by Jean-Marie Alfonsi on 06/03/2020.
//  Copyright © 2020 Jean-Marie Alfonsi. All rights reserved.
//

import Foundation
import UIKit
import Nuke

@objc(ImagePipeline)
public class ImagePipeline : NSObject {
    
    @objc
    public static let shared = ImagePipeline()
    
    @objc
    public func loadImage(url: URL, onCompleted: @escaping (UIImage?, String) -> Void) {
        _ = Nuke.ImagePipeline.shared.loadImage(
            with: url,
            progress: nil,
            completion: { result in
                switch result {
                case let .success(response):
                    onCompleted(response.image, "success")
                case let .failure(error):
                    onCompleted(nil, error.localizedDescription)
                }
            }
        )
    }
    
    @objc
    public func loadImage(url: URL, placeholder: UIImage?, errorImage: UIImage?, into: UIImageView) {
        let options = ImageLoadingOptions(placeholder:placeholder, failureImage: errorImage)
        Nuke.loadImage(with: url, options: options, into: into)
    }
    
    @objc
    public func loadImage(url: URL, key: String, placeholder: UIImage?, errorImage: UIImage?, into: UIImageView) {
        let request = ImageRequest(
            url: url,
            options: ImageRequestOptions(cacheKey: key)
        )
        
        let options = ImageLoadingOptions(placeholder: placeholder, failureImage: errorImage)
        
        Nuke.loadImage(with: request, options: options, into: into)
    }
    
    @objc
    public func loadData(url: URL, onCompleted: @escaping (Data?, URLResponse?) -> Void) {
        _ = Nuke.ImagePipeline.shared.loadData(
            with: url,
            completion: { result in
                switch result {
                case let .success(response):
                    onCompleted(response.data, response.response)
                case .failure(_):
                    onCompleted(nil, nil)
                }
            }
        )
    }
}

@objc(ImageCache)
public final class ImageCache: NSObject {
    
    @objc
    public static let shared = ImageCache()
    
    @objc
    public func removeAll() {
        Nuke.ImageCache.shared.removeAll()
    }
}

@objc(DataLoader)
public final class DataLoader: NSObject {
    
    @objc
    public static let shared = DataLoader()
    
    @objc
    public func removeAllCachedResponses() {
        Nuke.DataLoader.sharedUrlCache.removeAllCachedResponses()
    }
}

@objc(Prefetcher)
public final class Prefetcher: NSObject {
 
    let prefetcher = ImagePrefetcher()
    
    @objc
    public func startPrefetching(with: [URL]) {
        prefetcher.startPrefetching(with: with)
    }
    
    @objc
    public func stopPrefetching(with: [URL]) {
        prefetcher.stopPrefetching(with: with)
    }
    
    @objc
    public func stopPrefetching() {
        prefetcher.stopPrefetching()
    }
    
    @objc
    public func pause() {
        prefetcher.isPaused = true
    }
    
    @objc
    public func unPause() {
        prefetcher.isPaused = false
    }
}
