import UIKit

class ImageService {
    
    static let shared = ImageService()
    
    private init() {}
    
    func loadImagesFromDocumentDirectory() -> [URL] {
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: documentURL, includingPropertiesForKeys: nil)
            return contents.filter { $0.pathExtension.lowercased() == "jpg" || $0.pathExtension.lowercased() == "jpeg" }
        } catch {
            print("Error loading images: \(error)")
            return []
        }
    }
    
    func deleteImage(at url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Error deleting image: \(error)")
        }
    }
}
