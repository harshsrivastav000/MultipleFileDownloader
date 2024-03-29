import Foundation

//
// MARK: - Download Service
//

/// Downloads song snippets, and stores in local file.
/// Allows cancel, pause, resume download.
class DownloadService {
  //
  // MARK: - Variables And Properties
  //
  var activeDownloads:[URL: Download] = [:]
  
  /// SearchViewController creates downloadsSession
  var downloadsSession: URLSession!
  
  //
  // MARK: - Internal Methods
  //
  func cancelDownload(_ track: Track) {
    guard let download = activeDownloads[track.previewURL] else {
      return
    }
    download.task?.cancel()
    activeDownloads[track.previewURL] = nil
  }
  
  func pauseDownload(_ track: Track) {
    //Fetch the download object and check weather the download is active
    guard let download = activeDownloads[track.previewURL],
      download.isDownloading else {
        return
    }
    
    //saving the pause data to resume afterwards
    download.task?.cancel(byProducingResumeData: { (data) in
      download.resumeData = data
    })
    
    download.isDownloading = false
  }
  
  func resumeDownload(_ track: Track) {
    
    guard let download = activeDownloads[track.previewURL] else {
        return
    }
    
    //If cannont resume then restart download form begining
    if let resumeData = download.resumeData {
      download.task = downloadsSession.downloadTask(withResumeData: resumeData)
    } else {
      download.task = downloadsSession.downloadTask(with: download.track.previewURL)
    }
    
    download.task?.resume()
    download.isDownloading = true
  }
  
  func startDownload(_ track: Track) {
    let download = Download(track: track)
    download.task = downloadsSession.downloadTask(with: track.previewURL)
    download.task?.resume()
    download.isDownloading = true
    activeDownloads[download.track.previewURL] = download
  }
}
