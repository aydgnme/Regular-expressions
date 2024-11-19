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



// MARK: --TEST FUNCTIONS

func generateReport(fileName: String) {
    print("Logs taken from file: \(fileName)")
    
    if let logs = readLogFile(fileName: fileName) {
        print("Logs successfully read. Total logs: \(logs.count)")
    }
}
let logFile = "/Users/aydgnme/Courses/PrT/labs/lab4/access_lab4.log" // Replace with your actual log file path
generateReport(fileName: logFile)
