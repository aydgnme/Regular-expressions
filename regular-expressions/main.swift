//
//  main.swift
//  regular-expressions
//
//  Created by Mert Aydoğan on 19.11.2024.
//

import Foundation

//MARK: --READ LOG FILE
func readLogFile(fileName: String) -> [String]? {
    let fileManager = FileManager.default
    // Get the file URL from the current directory
    let fileURL = URL(fileURLWithPath: fileName)
    
    // Try to read the contents of the file
    do {
        let fileContent = try String(contentsOf: fileURL, encoding: .utf8)
        return fileContent.components(separatedBy: "\n")
    } catch {
        print("Failed to read file at \(fileName): \(error)")
        return nil
    }
}

