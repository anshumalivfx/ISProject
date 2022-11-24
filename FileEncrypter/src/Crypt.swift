//
//  Crypt.swift
//  FileEncrypter
//
//  Created by Anshumali Karna on 25/11/22.
//

import Foundation
import CryptoKit
@objc public class Crypt : NSObject {
@objc public static func encryptFile(atPath path: String, withKey key: String) -> String? {
        let fileURL = URL(fileURLWithPath: path)
        let fileData = try! Data(contentsOf: fileURL)
        let keyData = key.data(using: .utf8)!
        let symmetricKey = SymmetricKey(data: keyData)
        let sealedBox = try! ChaChaPoly.seal(fileData, using: symmetricKey)
        let encryptedData = sealedBox.combined
        let encryptedFileURL = fileURL.deletingPathExtension().appendingPathExtension("encrypted")
        try! encryptedData.write(to: encryptedFileURL)
        return encryptedFileURL.path
    }
    @objc public static func decryptFile(atPath path: String, withKey key: String) -> String? {
        let fileURL = URL(fileURLWithPath: path)
        let fileData = try! Data(contentsOf: fileURL)
        let keyData = key.data(using: .utf8)!
        let symmetricKey = SymmetricKey(data: keyData)
        let sealedBox = try! ChaChaPoly.SealedBox(combined: fileData)
        let decryptedData = try! ChaChaPoly.open(sealedBox, using: symmetricKey)
        let decryptedFileURL = fileURL.deletingPathExtension().appendingPathExtension("decrypted")
        try! decryptedData.write(to: decryptedFileURL)
        return decryptedFileURL.path
    }
}

