//
//  VideoView.swift
//  VideoFinder
//
//  Created by Stephanie Diep on 2022-01-18.
//

import SwiftUI
import AVKit

struct VideoView: View {
    var video: Video
    @State var player = AVPlayer()

    var body: some View {
        VideoPlayer(player: player)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                // Unwrapping optional
                if let link = video.videoFiles.first?.link {
                    // Setting the URL of the video file
                    player = AVPlayer(url: URL(string: link)!)
                    
                    // Play the video
                    player.play()
                }
            }
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(video: previewVideo)
    }
}
