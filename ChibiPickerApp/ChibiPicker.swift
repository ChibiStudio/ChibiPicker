//
//  ChibiPicker.swift
//  ChibiPickerApp
//
//  Created by Guilherme Rambo on 03/06/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import UIKit
import MobileCoreServices

/// Helps with the presentation and handling of the chibi picker from ChibiStudio.
final class ChibiPicker {

    static let shared = ChibiPicker()

    /// This is the URL ChibiStudio will open in your app after the user has picked a chibi,
    /// make sure it is properly configured in your app's Info.plist and that you have added
    /// a call to `handleOpenURL` in your AppDelegate or SceneDelegate. Refer to the
    /// documentation for more information.
    var returnURL = URL(string: "chibipickerapp://receive-chibi")!

    func handleOpenURL(_ url: URL) -> Bool {
        guard url.scheme == returnURL.scheme && url.host == returnURL.host else { return false }

        guard let imageData = UIPasteboard.general.data(forPasteboardType: kUTTypePNG as String) else {
            pendingCompletionHandler?(nil)
            pendingCompletionHandler = nil
            return true
        }

        guard let image = UIImage(data: imageData) else {
            pendingCompletionHandler?(nil)
            pendingCompletionHandler = nil
            return true
        }

        pendingCompletionHandler?(image)
        pendingCompletionHandler = nil

        return true
    }

    typealias CompletionHandler = (UIImage?) -> Void

    private var pendingCompletionHandler: CompletionHandler?

    /// Launches the chibi picker in ChibiStudio (if available)
    /// - Parameter completion: Called when the process is completed, if the value is `nil`,
    /// it means the user hasn't picked a chibi, or that the app is not installed.
    /// Keep in mind the completion handler may not be called if the user manually exits
    /// the process after being sent to ChibiStudio, so don't block your UI waiting for the completion.
    func pickChibi(with completion: @escaping CompletionHandler) {
        guard var components = URLComponents(string: "chibistudio://chibipicker") else {
            completion(nil)
            return
        }

        components.queryItems = [
            URLQueryItem(name: "return", value: returnURL.absoluteString)
        ]

        guard let url = components.url else {
            completion(nil)
            return
        }

        guard UIApplication.shared.canOpenURL(url) else {
            // ChibiStudio not installed
            completion(nil)
            return
        }

        pendingCompletionHandler = completion

        UIApplication.shared.open(url, options: [:]) { [weak self] success in
            if !success {
                completion(nil)
                self?.pendingCompletionHandler = nil
            }
        }
    }

}
