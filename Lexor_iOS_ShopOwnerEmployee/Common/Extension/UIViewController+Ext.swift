//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import UIKit
import Photos
import PhotosUI

extension UIViewController {
    static var alertTintColor: UIColor?

    func showAlert(title: String? = "Alert", message: String? = nil, presentCompletionHandler: (() -> Void)? = nil, handler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) {_ in handler?()})
        if let alertTintColor = UIViewController.alertTintColor {
            alert.view.tintColor = alertTintColor
        }
        present(alert, animated: true, completion: presentCompletionHandler)
    }
    
    func showAlert(title: String?, message: String?, buttonTitles: [String]? = nil, presentCompletionHandler: (() -> Void)? = nil, completion: ((Int) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var allButtons = buttonTitles ?? [String]()
        if allButtons.count == 0 {
            allButtons.append("OK")
        }

        for index in 0..<allButtons.count {
            let buttonTitle = allButtons[index]
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: { (_) in
                completion?(index)
            })
            alertController.addAction(action)
        }
        present(alertController, animated: true, completion: presentCompletionHandler)
    }


    func showAlertNetworkError(presentCompletionHandler: (() -> Void)? = nil, handler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Error", message: "The internet connection seems offline.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) {_ in handler?()})
        if let alertTintColor = UIViewController.alertTintColor {
            alert.view.tintColor = alertTintColor
        }
        present(alert, animated: true, completion: presentCompletionHandler)
    }
    
    func requestPermissionAndPickPhotos(delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)) {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { (status) in
                handleWithStatusAcceess(status: status)
            }
        } else {
            PHPhotoLibrary.requestAuthorization { (status) in
                handleWithStatusAcceess(status: status)
            }
        }

        func handleWithStatusAcceess(status: PHAuthorizationStatus) {
            switch status {
            case .authorized:
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.showPickerPhoto(delegate: delegate)
                }
            case .denied, .restricted:
                let actionsheet = UIAlertController(title: "Nail360Pro",
                                                    message: "Allow apps to access your library and camera.",
                                                    preferredStyle: .actionSheet)

                actionsheet.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                    guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else { return }
                    DispatchQueue.main.async {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }))

                actionsheet.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

                DispatchQueue.main.async { [weak self] in
                    self?.present(actionsheet, animated: true, completion: nil)
                }
            case .limited:
                if #available(iOS 14, *) {
                    PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
                } else {
                    break
                }
            case .notDetermined:
                if #available(iOS 14, *) {
                    PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                        switch status {
                        case .authorized:
                            DispatchQueue.main.async { [weak self] in
                                guard let strongSelf = self else { return }
                                strongSelf.showPickerPhoto(delegate: delegate)
                            }
                        default: break
                        }
                    }
                } else {
                    PHPhotoLibrary.requestAuthorization { status in
                        switch status {
                        case .authorized:
                            DispatchQueue.main.async { [weak self] in
                                guard let strongSelf = self else { return }
                                strongSelf.showPickerPhoto(delegate: delegate)
                            }
                        default: break
                        }
                    }
                }
            @unknown default:
                break
            }
        }
    }
    
    func showPickerPhoto(delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)) {
        view.endEditing(true)
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = delegate
        imagePickerController.allowsEditing = false
        
        let alert = UIAlertController (title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) {[weak self] action in
            guard let strongSelf = self else { return }
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                strongSelf.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Camera is Not Available")
            }
        }
        
        let gallaryAction = UIAlertAction(title: "Photo Library", style: .default) {[weak self] action in
            guard let strongSelf = self else { return }
            imagePickerController.sourceType = .photoLibrary
            strongSelf.present(imagePickerController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    func showNormalError(_ error: Error, actionHandler: (() -> Void)? = nil, completionHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        switch error._code {
        case 401:
            let ok = UIAlertAction(title: "OK", style: .default, handler: { _ in
                AccountManager.shared.accessToken = nil
                AccountManager.shared.jwtToken = nil
                AppDelegate.shared.setRoot(type: .login)
            })
            alert.addAction(ok)
            present(alert, animated: true, completion: completionHandler)
        default:
            let ok = UIAlertAction(title: "OK", style: .default, handler: { _ in actionHandler?() })
            alert.addAction(ok)
            present(alert, animated: true, completion: completionHandler)
        }


    }
}
