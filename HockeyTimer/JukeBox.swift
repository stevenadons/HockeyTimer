//
//  JukeBox.swift
//  AntiTheftMode
//
//  Created by Steven Adons on 9/06/17.
//  Copyright © 2017 StevenAdons. All rights reserved.
//
//  Load sounds into memory
//  JukeBox.instance.prepareSound("boop") // default extension is .wav
//  JukeBox.instance.prepareSound("ding.mp3") // so other extensions you must name explicitly
//
//
//  Since the sound is already loaded into memory, this will play immediately
//  JukeBox.instance.playSound("boop")
//
//  Cleanup is really simple!
//  JukeBox.instance.removeSound("boop")
//  JukeBox.instance.removeSound("ding.mp3")


import Foundation
import AVFoundation


class JukeBox {
    
    class Sound {
        
        var name: String
        var player: AVAudioPlayer
        var count: Int = 1
        init(name: String, player: AVAudioPlayer) {
            self.name = name
            self.player = player
        }
    }
    
    
    // MARK: - Properties
    
    private static let _instance = JukeBox()
    static var instance: JukeBox {
        return _instance
    }
    
    var mute: Bool = false
    var shouldFadeOut: Bool = false

    private var sounds = [String: Sound]()
    private let kDefaultExtension = "wav"

    
    
    
    // MARK: - Public methods
    
    func prepareSound(_ fileName: String) {
        
        let fixedSoundFileName = self.fixedSoundFileName(fileName)
        if let sound = soundForKey(key: fixedSoundFileName) {
            sound.count += 1
        }
        let onlyName = fixedSoundFileName.components(separatedBy: ".")[0]
        let fileExtension = fixedSoundFileName.components(separatedBy: ".")[1]
        guard let url = Bundle.main.url(forResource: onlyName, withExtension: fileExtension) else {
            print("url not found")
            return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)))
            try AVAudioSession.sharedInstance().setActive(true)
            let player = try AVAudioPlayer(contentsOf: url)
            let sound = Sound(name: onlyName, player: player)
            sounds[onlyName] = sound
            player.prepareToPlay()
        } catch {
            print("error fetching sound")
        }
    }
    
    
    func prepareSounds(_ fileNames: [String]) {
        
        for fileName in fileNames {
            prepareSound(fileName)
        }
    }
    
    
    func playSound(_ fileName: String, volume: Float = 1.0, repeats: Int = 0) {
        
        let fixedSoundFileName = self.fixedSoundFileName(fileName)
        let onlyName = fixedSoundFileName.components(separatedBy: ".")[0]
        if let sound = soundForKey(key: onlyName) {
            if !mute {
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)))
                    try AVAudioSession.sharedInstance().setActive(true)
                    let normalizedLevel = min(max(volume, 0), 1) // range between 0 and 1
                    sound.player.volume = normalizedLevel
                    sound.player.numberOfLoops = repeats
                    sound.player.play()
                } catch {
                    print("error playing sound")
                }
            }
        }
    }

    
    func isPlaying(_ fileName: String) -> Bool {
        
        let fixedSoundFileName = self.fixedSoundFileName(fileName)
        let onlyName = fixedSoundFileName.components(separatedBy: ".")[0]
        if let sound = soundForKey(key: onlyName) {
            return sound.player.isPlaying
        }
        return false
    }
    
    
    func isPlayingSomething() -> Bool {
        
        if sounds.count > 0 {
            for sound in sounds.values {
                if sound.player.isPlaying {
                    return true
                }
            }
        }
        return false
    }
    
    
    func setVolume(_ fileName: String, to level: Float) {
        
        let fixedSoundFileName = self.fixedSoundFileName(fileName)
        let onlyName = fixedSoundFileName.components(separatedBy: ".")[0]
        if let sound = soundForKey(key: onlyName) {
            let normalizedLevel = min(max(level, 0), 1) // range between 0 and 1
            sound.player.volume = normalizedLevel
        }
    }
    
    
    func volumeFadeIn(_ fileName: String, fadeDuration: Double) {
        
        let fixedSoundFileName = self.fixedSoundFileName(fileName)
        let onlyName = fixedSoundFileName.components(separatedBy: ".")[0]
        if let sound = soundForKey(key: onlyName) {
            sound.player.setVolume(1.0, fadeDuration: fadeDuration)
        }
    }
    
    func volumeFadeOut(_ fileName: String, fadeDuration: Double) {
        
        let fixedSoundFileName = self.fixedSoundFileName(fileName)
        let onlyName = fixedSoundFileName.components(separatedBy: ".")[0]
        if let sound = soundForKey(key: onlyName) {
            sound.player.setVolume(0.0, fadeDuration: fadeDuration)
        }
    }
    
    
    func volumeFadeOut(_ fileName: String, after: Double, fadeDuration: Double) {
        
        shouldFadeOut = true
        let fixedSoundFileName = self.fixedSoundFileName(fileName)
        let onlyName = fixedSoundFileName.components(separatedBy: ".")[0]
        if let sound = soundForKey(key: onlyName) {
            let milliSecs = Int(after * 1000)
            let deadline = DispatchTime.now() + DispatchTimeInterval.milliseconds(milliSecs)
            DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
                if self.shouldFadeOut {
                    sound.player.setVolume(0.0, fadeDuration: fadeDuration)
                }
                self.shouldFadeOut = false
            })
        }
    }
    
    
    func volumeStopFadeOut() {
        
        shouldFadeOut = false
    }
    
    
    func stopPlaying(_ fileName: String) {
        
        let fixedSoundFileName = self.fixedSoundFileName(fileName)
        let onlyName = fixedSoundFileName.components(separatedBy: ".")[0]
        if let sound = soundForKey(key: onlyName) {
            if sound.player.isPlaying {
                sound.player.stop() // timer will not be set to 0
                sound.player.currentTime = 0
                sound.player.prepareToPlay()
            }
        }
    }
    
    
    func stopPlayingAll() {
        
        if sounds.count > 0 {
            for sound in sounds.values {
                sound.player.stop() // timer will not be set to 0
                sound.player.currentTime = 0
                sound.player.prepareToPlay()
            }
        }
    }
    
    
    func removeSound(_ fileName: String) {
        
        let fixedSoundFileName = self.fixedSoundFileName(fileName)
        let onlyName = fixedSoundFileName.components(separatedBy: ".")[0]
        sounds.removeValue(forKey: onlyName)
    }
        
       
    
    
    // MARK: - Private
    
    func soundForKey(key: String) -> Sound? {
        
        return sounds[key]
    }
    
    
    private func fixedSoundFileName(_ fileName: String) -> String {
        
        var fixedSoundFileName = fileName.trimmingCharacters(in: .whitespacesAndNewlines)
        let soundFileComponents = fixedSoundFileName.components(separatedBy: ".")
        if soundFileComponents.count == 1 {
            fixedSoundFileName = "\(soundFileComponents[0]).\(kDefaultExtension)"
        }
        return fixedSoundFileName
    }
    
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
