//
//  ModelFirebaseStorage.swift
//  BigMama
//
//  Created by Chen Eini on 22/01/2020.
//  Copyright © 2020 BigMama. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FirebaseStorage {
    lazy var storageRef = Storage.storage().reference(forURL:"gs://bigmama-21a82.appspot.com")
    
    func saveImage(image:UIImage, callback:@escaping (String)->Void){
        let data = image.jpegData(compressionQuality: 0.5)
        let imageRef = storageRef.child(UUID().uuidString)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(data!, metadata: nil) { (metadata, error) in
            if (error != nil) {
                print("Image not stored: ", error!.localizedDescription)
                return
            }
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    return
                }
                print("url: \(downloadURL)")
                callback(downloadURL.absoluteString)
            }
        }
    }
}
