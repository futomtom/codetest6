
import UIKit
import MediaPlayer
import BrightcovePlayerSDK

@objc protocol ControlsViewControllerFullScreenDelegate:class {
optional func handleEnterFullScreenButtonPressed()
optional func handleExitFullScreenButtonPressed()
}

class ControlsViewController: UIViewController, BCOVPlaybackSessionConsumer,UIGestureRecognizerDelegate {
	 weak var delegate: ControlsViewControllerFullScreenDelegate?
    private var token: dispatch_once_t = 0
   @IBOutlet weak var currentPlayer:AVPlayer!
   @IBOutlet weak var controlsContainer:  UIView!
   @IBOutlet weak var playPauseButton:  UIButton!
   @IBOutlet weak var playheadLabel:  UILabel!
   @IBOutlet weak var playheadSlider:  UISlider!
   @IBOutlet weak var durationLabel:  UILabel!
   @IBOutlet weak var fullscreenButton:  UIView!
   @IBOutlet weak  var externalScreenButton:  MPVolumeView!
    var  controlTimer = NSTimer()
    var playingOnSeek:Bool=false

// ** Customize these values **
	let kViewControllerControlsVisibleDuration: NSTimeInterval = 5.0
	let kViewControllerFadeControlsInAnimationDuration: NSTimeInterval = 0.1
	let kViewControllerFadeControlsOutAnimationDuration: NSTimeInterval = 0.2

	override func viewDidLoad() {
		super.viewDidLoad()
		// Used for hiding and showing the controls.
		let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ControlsViewController.tapDetected(_:)))
		tapRecognizer.numberOfTapsRequired = 1
		tapRecognizer.numberOfTouchesRequired = 1
		tapRecognizer.delegate = self
		self.view!.addGestureRecognizer(tapRecognizer)
		self.externalScreenButton.showsRouteButton = true
        
        playingOnSeek = false
        playheadLabel.text = formatTime(0)
        playheadSlider.value = 0.0
        invalidateTimerAndShowControls()
    }

    
  
    
    
    func playbackSession(session:  BCOVPlaybackSession, didChangeDuration duration: NSTimeInterval) {
        self.durationLabel.text = formatTime(duration)
    }
    
    func playbackSession(session:  BCOVPlaybackSession, didProgressTo progress: NSTimeInterval) {
        self.playheadLabel.text = formatTime(progress)
        let duration = CMTimeGetSeconds(session.player.currentItem!.duration)
        let percent = progress / duration
        self.playheadSlider.value = Float(percent)
    }
    
    func playbackSession(session: BCOVPlaybackSession, didReceiveLifecycleEvent lifecycleEvent: BCOVPlaybackSessionLifecycleEvent) {
        if (kBCOVPlaybackSessionLifecycleEventPlay == lifecycleEvent.eventType) {
            self.playPauseButton.selected = true
            self.reestablishTimer()
        }
        else if (kBCOVPlaybackSessionLifecycleEventPause == lifecycleEvent.eventType) {
            self.playPauseButton.selected = false
            self.invalidateTimerAndShowControls()
        }
        
    }
    
    
    @IBAction func handlePlayPauseButtonPressed(sender: UIButton) {
        if sender.selected {
            self.currentPlayer.pause()
        } else {
            self.currentPlayer.play()
        }
    }
    
    @IBAction func handlePlayheadSliderValueChanged(sender: UISlider) {
        let newCurrentTime = Double(sender.value) * CMTimeGetSeconds(self.currentPlayer.currentItem!.duration)
        self.playheadLabel.text = formatTime(newCurrentTime)
    }
    
    @IBAction func handlePlayheadSliderTouchBegin(sender: UISlider) {
        self.playingOnSeek = self.playPauseButton.selected
        self.currentPlayer.pause()
    }
    
    @IBAction func handlePlayheadSliderTouchEnd(sender: UISlider) {
        let newCurrentTime: NSTimeInterval = Double(sender.value) * CMTimeGetSeconds(self.currentPlayer.currentItem!.duration)
        let seekToTime: CMTime = CMTimeMakeWithSeconds(newCurrentTime, 600)
        self.currentPlayer.seekToTime(seekToTime, completionHandler: {(finished: Bool) -> Void in
            
            if finished && self.playingOnSeek {
                self.playingOnSeek = false
                self.currentPlayer.play()
            }
        })
    }
    @IBAction func handleFullScreenButtonPressed(sender: UIButton) {
        if sender.selected {
            sender.selected = false
            self.delegate!.handleExitFullScreenButtonPressed!()
        } else {
            sender.selected = true
            self.delegate!.handleEnterFullScreenButtonPressed!()
        }
    }
    
    func fadeControlsIn() {
        UIView.animateWithDuration(kViewControllerFadeControlsInAnimationDuration, animations: { self.showControls() }, completion: { (finished: Bool) in
            if finished {
                self.reestablishTimer()
            }
        })
    }
    
    func fadeControlsOut() {
        UIView.animateWithDuration(kViewControllerFadeControlsOutAnimationDuration, animations: { self.hideControls() })
    }
    
    func hideControls() {
        self.controlsContainer.alpha = 0.0
    }
    
    func showControls() {
        self.controlsContainer.alpha = 1.0
    }
    
    func reestablishTimer() {
        self.controlTimer.invalidate()
        self.controlTimer = NSTimer.scheduledTimerWithTimeInterval(kViewControllerControlsVisibleDuration, target: self, selector: #selector(ControlsViewController.fadeControlsOut), userInfo: nil, repeats: false)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view!.isKindOfClass(UIButton.self) || touch.view!.isKindOfClass(UISlider.self) {
            return false
        }
        return true
    }
    
    func tapDetected(gestureRecognizer: UIGestureRecognizer) {
        if self.playPauseButton.selected {
            if self.controlsContainer.alpha == 0.0 {
                self.fadeControlsIn()
            } else if self.controlsContainer.alpha == 1.0 {
                self.fadeControlsOut()
            }
        }
    }
    
    func invalidateTimerAndShowControls() {
        self.controlTimer.invalidate()
        self.showControls()
    }
    
    func formatTime(timeInterval: NSTimeInterval) -> String {
        let numberFormatter = NSNumberFormatter()
    
        dispatch_once(&token, {
            numberFormatter.paddingCharacter = "0"
            numberFormatter.minimumIntegerDigits = 2
        })
        if isnan(timeInterval) || !isfinite(timeInterval) || timeInterval == 0 {
            return "00:00"
        }
        let hours = floor(timeInterval / 60.0 / 60.0)
        let minutes = (timeInterval / 60.0) % 60
        let seconds = timeInterval  % 60
        let formattedMinutes = numberFormatter.stringFromNumber((minutes))
        let formattedSeconds = numberFormatter.stringFromNumber((seconds))
        var ret = ""
        if hours > 0 {
            ret = "\((hours)):\(formattedMinutes!):\(formattedSeconds!)"
        } else {
            ret = "\(formattedMinutes!):\(formattedSeconds!)"
        }
        return ret
    }
}
