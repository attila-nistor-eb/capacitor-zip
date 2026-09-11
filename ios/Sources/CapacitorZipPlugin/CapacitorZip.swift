import Foundation
import ZIPFoundation

public class CapacitorZip: NSObject {

    /// Creates a file URL from either a filesystem path or a file:// URL.
    /// Capacitor file APIs commonly return file:// URLs, while ZIPFoundation
    /// and FileManager expect filesystem paths when checking for files.
    private func fileURL(from pathOrURL: String) -> URL {
        if let url = URL(string: pathOrURL), url.isFileURL {
            return url.standardizedFileURL
        }

        return URL(fileURLWithPath: pathOrURL).standardizedFileURL
    }

    /**
     * Creates a zip archive from a source file or directory
     * Note: Password protection is not supported on iOS with ZIPFoundation
     */
    public func zip(source: String, destination: String, password: String? = nil) throws {
        let sourceURL = fileURL(from: source)
        let destinationURL = fileURL(from: destination)

        // Check if source exists
        guard FileManager.default.fileExists(atPath: sourceURL.path) else {
            throw NSError(domain: "CapacitorZip", code: 1, userInfo: [NSLocalizedDescriptionKey: "Source path does not exist"])
        }

        // Warn if password is provided (not supported)
        if password != nil && !password!.isEmpty {
            print("Warning: Password protection is not supported on iOS")
        }

        // Create parent directory if it doesn't exist
        let parentDir = destinationURL.deletingLastPathComponent()
        if !FileManager.default.fileExists(atPath: parentDir.path) {
            try FileManager.default.createDirectory(at: parentDir, withIntermediateDirectories: true, attributes: nil)
        }

        // Remove existing destination file if it exists
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            try FileManager.default.removeItem(at: destinationURL)
        }

        // Zip the item (file or directory)
        try FileManager.default.zipItem(at: sourceURL, to: destinationURL)
    }

    /**
     * Extracts a zip archive to a destination directory
     * Note: Password protection is not supported on iOS with ZIPFoundation
     */
    public func unzip(source: String, destination: String, password: String? = nil) throws {
        let sourceURL = fileURL(from: source)
        let destinationURL = fileURL(from: destination)

        // Check if source exists
        guard FileManager.default.fileExists(atPath: sourceURL.path) else {
            throw NSError(domain: "CapacitorZip", code: 2, userInfo: [NSLocalizedDescriptionKey: "Source zip file does not exist"])
        }

        // Warn if password is provided (not supported)
        if password != nil && !password!.isEmpty {
            print("Warning: Password protection is not supported on iOS")
        }

        // Create destination directory if it doesn't exist
        if !FileManager.default.fileExists(atPath: destinationURL.path) {
            try FileManager.default.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
        }

        // Unzip the item
        try FileManager.default.unzipItem(at: sourceURL, to: destinationURL)
    }
}
