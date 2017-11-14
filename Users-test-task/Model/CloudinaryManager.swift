//
//  CloudinaryManager.swift
//  Users-test-task
//
//  Created by Евгений Дац on 14.11.2017.
//  Copyright © 2017 Evgeny Dats. All rights reserved.
//

import Foundation
import Cloudinary

protocol CloudnaryManagerDelegate: class {
    func didUpdateProgress(progress: Progress)
    func didUploadImage(url: String)
}

class CloudnaryManager {
    
    var cloudinary: CLDCloudinary?
    var params: CLDUploadRequestParams?
    weak var delegate: CloudnaryManagerDelegate?
    
    init() {
        let config = CLDConfiguration(cloudinaryUrl: Config.cloudinary.base)
        cloudinary = CLDCloudinary(configuration: config!)
    }
    
    func uploadImage(image: UIImage) {
        let data = UIImagePNGRepresentation(image) as Data?
        cloudinary?.createUploader().signedUpload(data: data!, params: params, progress: { [weak self] (progress)  in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.didUpdateProgress(progress: progress)
        }, completionHandler: { [weak self] (response, error) in
            guard let strongSelf = self else { return }
            if error != nil {
                print("upload failed")
            } else {
                strongSelf.delegate?.didUploadImage(url: (response?.url!)!)
            }
        })
    }
}
