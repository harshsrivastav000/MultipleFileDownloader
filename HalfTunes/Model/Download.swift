import Foundation
import UIKit

class Download {
  var isDownloading:Bool = false
  var progress:Float = 0
  var resumeData: Data?
  var task: URLSessionDownloadTask?
  var track: Track
  
  init(track: Track) {
    self.track = track
  }
}
