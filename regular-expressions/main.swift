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

//MARK: --FIND LOGIN REQUEST
func findLoginRequests(logs: [String]) -> [String] {
    let pattern = "(https://www\\.google\\.com|https://www\\.bing\\.com)"
    let regex = try! NSRegularExpression(pattern: pattern)
    var results = [String]()
    
    for log in logs {
        let range = NSRange(log.startIndex..., in: log)
        if regex.firstMatch(in: log, options: [], range: range) != nil {
            results.append(log)
        }
    }
    return results
}



// MARK: --TEST FUNCTIONS

func generateReport(fileName: String) {
    print("Logs taken from file: \(fileName)")
    
    if let logs = readLogFile(fileName: fileName) {
        
        //Logs
        print("Logs successfully read. Total logs: \(logs.count)")
        
        //Request Login Page
        print("\nRequests to the login page:")
                let loginRequests = findLoginRequests(logs: logs)
                if loginRequests.isEmpty {
                    print("No login requests found.")
                } else {
                    loginRequests.forEach { print($0) }
                }
    }
}
let logFile = "/Users/aydgnme/Courses/PrT/labs/lab4/access_lab4.log" // Replace with your actual log file path
generateReport(fileName: logFile)
