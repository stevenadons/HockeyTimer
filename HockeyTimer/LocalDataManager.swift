//
//  LocalDataManager.swift
//  DrawNames
//
//  Created by Steven Adons on 16/12/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//

//  This LocalDataManager is based upon Brian Advent's tutorial https://www.youtube.com/watch?v=5ZUVCyOvZto

import Foundation

public class LocalDataManager {
    
    // Gets the Document Directory
    static fileprivate func getDocumentDirectory() -> URL {
        if let directoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return directoryUrl
        } else {
            fatalError("Unable to access local document directory")
        }
    }
    
    // Saves an (Encodable) object
    // Implement in an object method f.i. MyObject.saveItem()
    // LocalDataManager.save(self, withFileName: someUUID.uuidString)
    // Example: LocalDataManager.save(self, withFileName: itemIdentifier.uuidString) with itemIdentifier = UUID()
    static func save<T: Encodable>(_ object: T, withFileName fileName: String) {
        let dataUrl = getDocumentDirectory().appendingPathComponent(fileName)
        do {
            let data = try JSONEncoder().encode(object)
            if FileManager.default.fileExists(atPath: dataUrl.path) {
                try FileManager.default.removeItem(at: dataUrl)
            }
            FileManager.default.createFile(atPath: dataUrl.path, contents: data, attributes: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // Loads a locally stored (Encodable) object
    // Implement in an object method f.i. MyObject.loadItem()
    // LocalDataManager.load(someUUID.uuidString, ofType: ModelClass.self)
    static func load<T: Decodable>(_ fileName: String, ofType type: T.Type) -> T {
        let dataUrl = getDocumentDirectory().appendingPathComponent(fileName)
        if !FileManager.default.fileExists(atPath: dataUrl.path) {
            fatalError("File not found at path \(dataUrl.path)")
        }
        if let data = FileManager.default.contents(atPath: dataUrl.path) {
            do {
                let object = try JSONDecoder().decode(type, from: data)
                return object
            } catch {
                fatalError(error.localizedDescription)
            }
        } else {
            fatalError("Data unavailable at path \(dataUrl.path)")
        }
    }
    
    // Loads data from a locally stored (Encodable) object
    // Implement in an object method f.i. MyObject.loadData()
    // LocalDataManager.load(someUUID.uuidString)
    static func loadData(_ fileName: String) -> Data? {
        let dataUrl = getDocumentDirectory().appendingPathComponent(fileName)
        if !FileManager.default.fileExists(atPath: dataUrl.path) {
            fatalError("File not found at path \(dataUrl.path)")
        }
        if let data = FileManager.default.contents(atPath: dataUrl.path) {
            return data
        } else {
            fatalError("Data unavailable at path \(dataUrl.path)")
        }
    }
    
    // Loads all locally stored (Encodable) objects
    // Implement in a CLASS/STATIC object method f.i. MyObject.loadAll()
    // LocalDataManager.loadAll(ModelClass.self)
    static func loadAll<T: Decodable>(_ type: T.Type) -> [T] {
        do {
            let fileNames = try FileManager.default.contentsOfDirectory(atPath: getDocumentDirectory().path)
            var objects = [T]()
            fileNames.forEach {
                objects.append(load($0, ofType: type))
            }
            return objects
        } catch {
            fatalError("Could not load any files")
        }
    }
    
    // Checks if (Encodable) objects are stored
    // Implement in a CLASS/STATIC object method f.i. MyObject.areStored()
    // LocalDataManager.areStored(ModelClass.self)
    static func areStored<T: Decodable>(_ type: T.Type) -> Bool {
        do {
            let fileNames = try FileManager.default.contentsOfDirectory(atPath: getDocumentDirectory().path)
            if fileNames.count > 0 {
                return true
            }
        } catch {
            fatalError("Could not load any files")
        }
        return false
    }
    
    // Deletes an (Encodable) object
    // Implement in an object method f.i. MyObject.deleteItem()
    // LocalDataManager.delete(someUUID.uuidString)
    static func delete(_ fileName: String) {
        let dataUrl = getDocumentDirectory().appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: dataUrl.path) {
            do {
                try FileManager.default.removeItem(at: dataUrl)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}
