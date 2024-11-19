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

//MARK: --FIND SEARCH ENGINE REQUEST
func findSearchEngineRequests(logs: [String]) -> [String] {
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

//MARK: --COUNT ERRORS
func countErrors(logs: [String]) -> (clientErrors: Int, serverErrors: Int) {
    let clientErrorPattern = "\"[^\"]+\" \\d{3} [0-9]+"
    let serverErrorPattern = "\"[^\"]+\" (5\\d{2}) [0-9]+"
    let clientRegex = try! NSRegularExpression(pattern: clientErrorPattern)
    let serverRegex = try! NSRegularExpression(pattern: serverErrorPattern)
    
    var clientErrorCount = 0
    var serverErrorCount = 0
    
    for log in logs {
        let range = NSRange(log.startIndex..., in: log)
        
        // Verify client errors
        if let _ = clientRegex.firstMatch(in: log, options: [], range: range) {
            let statusCode = Int(log.split(separator: " ")[8]) ?? 0
            if statusCode >= 400 && statusCode <= 499 {
                clientErrorCount += 1
            }
        }
        
        // Verify server errors
        if let _ = serverRegex.firstMatch(in: log, options: [], range: range) {
            let statusCode = Int(log.split(separator: " ")[8]) ?? 0
            if statusCode >= 500 && statusCode <= 599 {
                serverErrorCount += 1
            }
        }
    }
    
    return (clientErrorCount, serverErrorCount)
}

//MARK: --COUNT REQUEST FROM IP
func countRequestsFromIP(logs: [String], ip: String) -> Int {
    return logs.filter { $0.hasPrefix(ip) }.count
}

//MARK: --COUNT REQUESTS BY BROWSER
func countRequestsByBrowser(logs: [String]) -> [String: Int] {
    var browserCount = [String: Int]()
    
    let userAgentPattern = "\"([^\"]+)\""
    let regex = try! NSRegularExpression(pattern: userAgentPattern)
    
    for log in logs {
        let range = NSRange(log.startIndex..., in: log)
        if let match = regex.firstMatch(in: log, options: [], range: range) {
            let userAgent = (log as NSString).substring(with: match.range(at: 1))
            let browser = userAgent.components(separatedBy: " ").first ?? "Unknown"
            browserCount[browser, default: 0] += 1
        }
    }
    
    return browserCount
}

//MARK: --COUNT SUCCESSFUL POST REQUESTS
func countSuccessfulPostRequests(logs: [String]) -> Int {
    return logs.filter { $0.contains("POST") && $0.contains("200") }.count
}

//MARK: --COUNT REQUEST LAST 24H
func countRequestsLast24Hours(logs: [String]) -> Int {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM dd yyyy, HH:mm:ss"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    let currentDate = Date()
    let calendar = Calendar.current
    var requestCount = 0
    
    for log in logs {
        // Extract date from log line
        guard let dateString = log.split(separator: "[", maxSplits: 1).last?.split(separator: "]").first else {
            continue
        }
        
        // Parse the date string
        if let requestDate = dateFormatter.date(from: String(dateString)) {
            let hoursDifference = calendar.dateComponents([.hour], from: requestDate, to: currentDate).hour ?? 0
            if hoursDifference >= 0 && hoursDifference <= 24 {
                requestCount += 1
            }
        }
    }
    
    return requestCount
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
        //Requset Seach Engine
        print("\nRequests from Google or Bing:")
        let searchEngineRequests = findSearchEngineRequests(logs: logs)
        if searchEngineRequests.isEmpty {
            print("No requests from Google or Bing.")
        } else {
            searchEngineRequests.forEach { print($0) }
            
        }
        
        //Count Errors
        let (clientErrors, serverErrors) = countErrors(logs: logs)
        print("\nClient errors: \(clientErrors), server errors: \(serverErrors)")
        
        //Count requset from IP
        print("\nNumber of requests from IP 192.168.1.1:")
        let ipRequests = countRequestsFromIP(logs: logs, ip: "192.168.1.1")
        print(ipRequests)
        
        
        //Count Request from Browser
        print("\nRequest report per browser:")
        let browserReport = countRequestsByBrowser(logs: logs)
        if browserReport.isEmpty {
            print("No browser requests found.")
        } else {
            browserReport.forEach { print("\($0): \($1)") }
        }
        
        //Count successful post request
        print("\nNumber of successful POST requests (200): ")
        let successfulPostRequests = countSuccessfulPostRequests(logs: logs)
        print(successfulPostRequests)
        
        //Count requests in the last 24 hours
        print("\nNumber of requests in the last 24 hours:")
        let recentRequests = countRequestsLast24Hours(logs: logs)
        print(recentRequests)
    }
}

let logFile = "access_lab4.log" // Replace with your actual log file path
generateReport(fileName: logFile)
