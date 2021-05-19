//
//  VoiceCallViewController.swift
//  Courail
//
//  Created by Omeesh Sharma on 01/05/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import AVFoundation
import TwilioVoice
import PushKit
import CallKit
import Speech

protocol PushKitEventDelegate: AnyObject {
    func credentialsUpdated(credentials: PKPushCredentials) -> Void
    func credentialsInvalidated() -> Void
    func incomingPushReceived(payload: PKPushPayload) -> Void
    func incomingPushReceived(payload: PKPushPayload, completion: @escaping () -> Void) -> Void
}

class DilaPadCVC : UICollectionViewCell{
    
   @IBOutlet weak var innerView: UIView!
   @IBOutlet weak var dialBtn: UIButton!
    
}

class VoiceCallViewController: UIViewController {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var callStatus: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var callControlViewHeight: NSLayoutConstraint!
    @IBOutlet weak var callControlView: UIView!
    @IBOutlet weak var muteSwitch: UIButton!
    @IBOutlet weak var speakerSwitch: UIButton!
    @IBOutlet weak var dialPadBtn: UIButton!
    
    @IBOutlet weak var callingView: UIViewCustomClass!
    @IBOutlet weak var hideBtnView: UIViewCustomClass!
    @IBOutlet weak var endCallBtn: UIButton!
    
    @IBOutlet weak var dialerView: UIViewCustomClass!
    @IBOutlet weak var dialerEndCall: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK:- VARIABLES
    
    var audioPlayer = AVAudioPlayer()
    
    var recordings = [RecordingModel]()
    
    var completion: ((String)->())?
    
    var pushKitEventDelegate: PushKitEventDelegate?
    var voipRegistry = PKPushRegistry.init(queue: DispatchQueue.main)
    
    
    let accessTokenEndpoint = "/accessToken"
    let identity = "Courial"
    let twimlParamTo = "to"
    
    var storePhone = ""
    var finalTranscription = ""
        
    let kCachedDeviceToken = "CachedDeviceToken"
    
    var incomingPushCompletionCallback: (() -> Void)?
    
    var isSpinning: Bool
    var incomingAlertController: UIAlertController?
    
    var callKitCompletionCallback: ((Bool) -> Void)? = nil
    var audioDevice = TVODefaultAudioDevice()
    var activeCallInvites: [String: TVOCallInvite]! = [:]
    var activeCalls: [String: TVOCall]! = [:]
    
    // activeCall represents the last connected call
    var activeCall: TVOCall? = nil
    
    let callKitProvider: CXProvider
    let callKitCallController: CXCallController
    var userInitiatedDisconnect: Bool = false
    
    var playCustomRingback = false
    var ringtonePlayer: AVAudioPlayer? = nil
    
    var timer = Timer()
    var sfTask : SFSpeechRecognitionTask?
    
    var fromSite = true
    
    var dialers = ["1","2","3","4","5","6","7","8","9","*","0","#"]
    
    var crossPressed = false
    
    required init?(coder aDecoder: NSCoder) {
        isSpinning = false
        
        let configuration = CXProviderConfiguration(localizedName: "Courial")
        configuration.maximumCallGroups = 1
        configuration.maximumCallsPerCallGroup = 1
        
        if let callKitIcon = UIImage(named: "logo_main") {
            configuration.iconTemplateImageData = callKitIcon.pngData()
        }
        
        callKitProvider = CXProvider(configuration: configuration)
        callKitCallController = CXCallController()
        
        super.init(coder: aDecoder)
        callKitProvider.setDelegate(self, queue: nil)
    }
    
    deinit {
        // CallKit has an odd API contract where the developer must call invalidate or the CXProvider is leaked.
        self.timer.invalidate()
        callKitProvider.invalidate()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePushKit()
        
        toggleUIState(isEnabled: true, showCallControl: false)
        TwilioVoice.audioDevice = audioDevice
                
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.makeCall()
    }
    
    //MARK:- BUTTONS ACTIONS
    
    func removeView(){
        self.timer.invalidate()
        callKitProvider.invalidate()
        DispatchQueue.main.async {
            self.removeFromParent()
            self.view.removeFromSuperview()
        }
    }
    
    
    @IBAction func crossBtn(_ sender: UIButton) {
        crossPressed = true
        self.endCall()
    }
    
    @IBAction func endCallBtn(_ sender: UIButton) {
        crossPressed = false
        self.endCall()
    }
    
    func endCall(){
        if activeCall != nil{
            userInitiatedDisconnect = true
            performEndCallAction(uuid: activeCall!.uuid)
            toggleUIState(isEnabled: false, showCallControl: false)
        } else{
            guard let result = self.completion else {
                self.removeView()
                return
            }
            result("-")
            self.removeView()
        }
        
    }
    @IBAction func hideBtn(_ sender: UIButton) {
        self.view.isHidden = true
        guard let result = self.completion else {
            return
        }
        result("-Hide")
    }
    
    
    @IBAction func dialPadBtn(_ sender: UIButton) {
        self.dialerView.isHidden = false
        self.callingView.isHidden = true
    }
    
    @IBAction func hideDialerBtn(_ sender: UIButton) {
        self.dialerView.isHidden = true
        self.callingView.isHidden = false
    }
    
    
    @IBAction func muteSwitchToggled(_ sender: UIButton) {
        guard let activeCall = activeCall else { return }
        
        if sender.tintColor == .darkGray{
           sender.tintColor = appColor
            activeCall.isMuted = true
        } else{
            sender.tintColor = .darkGray
            activeCall.isMuted = false
        }
    }
    
    @IBAction func speakerSwitchToggled(_ sender: UIButton) {
        if sender.tintColor == .darkGray{
             sender.tintColor = appColor
            toggleAudioRoute(toSpeaker: true)
        } else{
            sender.tintColor = .darkGray
            toggleAudioRoute(toSpeaker: false)
        }
    }
    
    @objc func dialBtn(_ sender: UIButton){
        self.activeCall?.sendDigits(self.dialers[sender.tag])
        
        AudioServicesPlayAlertSound(SystemSoundID(1104))
    }
    
}

extension VoiceCallViewController {
    
    func makeCall() {
        checkRecordPermission { [weak self] permissionGranted in
            let uuid = UUID()
            let handle = "Voice Bot"
            
            guard !permissionGranted else {
                self?.performStartCallAction(uuid: uuid, handle: handle)
                return
            }
            
            self?.showMicrophoneAccessRequest(uuid, handle)
        }
    }
    
    func fetchAccessToken() -> String? {
        let endpointWithIdentity = String(format: "%@?identity=%@", accessTokenEndpoint, identity)
        
        guard let accessTokenURL = URL(string: twilioBaseURL + endpointWithIdentity) else { return nil }
        
        return try? String(contentsOf: accessTokenURL, encoding: .utf8)
    }
    
    func toggleUIState(isEnabled: Bool, showCallControl: Bool) {
        //        placeCallButton.isEnabled = isEnabled
        if showCallControl {
            callControlView.isHidden = false
            self.muteSwitch.tintColor = .darkGray
            self.speakerSwitch.tintColor = appColor
        } else {
            callControlView.isHidden = true
        }
    }
    
    func showMicrophoneAccessRequest(_ uuid: UUID, _ handle: String) {
        let alertController = UIAlertController(title: "Voice Quick Start",
                                                message: "Microphone permission not granted",
                                                preferredStyle: .alert)
        
        let continueWithoutMic = UIAlertAction(title: "Continue without microphone", style: .default) { [weak self] _ in
            self?.performStartCallAction(uuid: uuid, handle: handle)
        }
        
        let goToSettings = UIAlertAction(title: "Settings", style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                      options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly: false],
                                      completionHandler: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.toggleUIState(isEnabled: true, showCallControl: false)
            self?.stopSpin()
        }
        
        [continueWithoutMic, goToSettings, cancel].forEach { alertController.addAction($0) }
        
        present(alertController, animated: true, completion: nil)
    }
    
    func checkRecordPermission(completion: @escaping (_ permissionGranted: Bool) -> Void) {
        let permissionStatus = AVAudioSession.sharedInstance().recordPermission
        
        switch permissionStatus {
        case .granted:
            // Record permission already granted.
            completion(true)
        case .denied:
            // Record permission denied.
            completion(false)
        case .undetermined:
            // Requesting record permission.
            // Optional: pop up app dialog to let the users know if they want to request.
            AVAudioSession.sharedInstance().requestRecordPermission { granted in completion(granted) }
        default:
            completion(false)
        }
    }
    
    
    
    // MARK: AVAudioSession
    
    func toggleAudioRoute(toSpeaker: Bool) {
        // The mode set by the Voice SDK is "VoiceChat" so the default audio route is the built-in receiver. Use port override to switch the route.
        audioDevice.block = {
            kTVODefaultAVAudioSessionConfigurationBlock()
            
            do {
                if toSpeaker {
                    try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
                } else {
                    try AVAudioSession.sharedInstance().overrideOutputAudioPort(.none)
                }
            } catch {
                NSLog(error.localizedDescription)
            }
        }
        
        audioDevice.block()
    }
    
    
    // MARK: Icon spinning
    
    func startSpin() {
        guard !isSpinning else { return }
        
        isSpinning = true
        spin(options: UIView.AnimationOptions.curveEaseIn)
    }
    
    func stopSpin() {
        isSpinning = false
    }
    
    func spin(options: UIView.AnimationOptions) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: options, animations: { [weak iconView] in
            if let iconView = iconView {
                iconView.transform = iconView.transform.rotated(by: CGFloat(Double.pi/2))
            }
        }) { [weak self] finished in
            guard let strongSelf = self else { return }
            
            if finished {
                if strongSelf.isSpinning {
                    strongSelf.spin(options: UIView.AnimationOptions.curveLinear)
                } else if options != UIView.AnimationOptions.curveEaseOut {
                    strongSelf.spin(options: UIView.AnimationOptions.curveEaseOut)
                }
            }
        }
    }
    
}

extension VoiceCallViewController: PKPushRegistryDelegate {
    
    func initializePushKit() {
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = Set([PKPushType.voIP])
    }
    
    // MARK: PKPushRegistryDelegate
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        NSLog("pushRegistry:didUpdatePushCredentials:forType:")
        
        if let delegate = self.pushKitEventDelegate {
            delegate.credentialsUpdated(credentials: credentials)
        }
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        NSLog("pushRegistry:didInvalidatePushTokenForType:")
        
        if let delegate = self.pushKitEventDelegate {
            delegate.credentialsInvalidated()
        }
    }
    
    /**
     * Try using the `pushRegistry:didReceiveIncomingPushWithPayload:forType:withCompletionHandler:` method if
     * your application is targeting iOS 11. According to the docs, this delegate method is deprecated by Apple.
     */
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        NSLog("pushRegistry:didReceiveIncomingPushWithPayload:forType:")
        
        if let delegate = self.pushKitEventDelegate {
            delegate.incomingPushReceived(payload: payload)
        }
    }
    
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        NSLog("pushRegistry:didReceiveIncomingPushWithPayload:forType:completion:")
        
        if let delegate = self.pushKitEventDelegate {
            delegate.incomingPushReceived(payload: payload, completion: completion)
        }
        
        if let version = Float(UIDevice.current.systemVersion), version >= 13.0 {
            completion()
        }
    }
}

// MARK: - PushKitEventDelegate
extension VoiceCallViewController: PushKitEventDelegate {
    func credentialsUpdated(credentials: PKPushCredentials) {
        guard
            let accessToken = fetchAccessToken(),
            UserDefaults.standard.data(forKey: kCachedDeviceToken) != credentials.token
            else { return }
        
        let cachedDeviceToken = credentials.token
        /*
         * Perform registration if a new device token is detected.
         */
        TwilioVoice.register(withAccessToken: accessToken, deviceToken: cachedDeviceToken) { error in
            if let error = error {
                NSLog("An error occurred while registering: \(error.localizedDescription)")
            } else {
                NSLog("Successfully registered for VoIP push notifications.")
                
                /*
                 * Save the device token after successfully registered.
                 */
                UserDefaults.standard.set(cachedDeviceToken, forKey: self.kCachedDeviceToken)
            }
        }
    }
    
    func credentialsInvalidated() {
        guard let deviceToken = UserDefaults.standard.data(forKey: kCachedDeviceToken),
            let accessToken = fetchAccessToken() else { return }
        
        TwilioVoice.unregister(withAccessToken: accessToken, deviceToken: deviceToken) { error in
            if let error = error {
                NSLog("An error occurred while unregistering: \(error.localizedDescription)")
            } else {
                NSLog("Successfully unregistered from VoIP push notifications.")
            }
        }
        
        UserDefaults.standard.removeObject(forKey: kCachedDeviceToken)
    }
    
    func incomingPushReceived(payload: PKPushPayload) {
        // The Voice SDK will use main queue to invoke `cancelledCallInviteReceived:error:` when delegate queue is not passed
        TwilioVoice.handleNotification(payload.dictionaryPayload, delegate: self, delegateQueue: nil)
    }
    
    func incomingPushReceived(payload: PKPushPayload, completion: @escaping () -> Void) {
        // The Voice SDK will use main queue to invoke `cancelledCallInviteReceived:error:` when delegate queue is not passed
        TwilioVoice.handleNotification(payload.dictionaryPayload, delegate: self, delegateQueue: nil)
        
        if let version = Float(UIDevice.current.systemVersion), version < 13.0 {
            // Save for later when the notification is properly handled.
            incomingPushCompletionCallback = completion
        }
    }
    
    func incomingPushHandled() {
        guard let completion = incomingPushCompletionCallback else { return }
        
        incomingPushCompletionCallback = nil
        completion()
    }
}


// MARK: - TVONotificaitonDelegate
extension VoiceCallViewController: TVONotificationDelegate {
    func callInviteReceived(_ callInvite: TVOCallInvite) {
        NSLog("callInviteReceived:")
        
        let from = (callInvite.from ?? "Voice Bot").replacingOccurrences(of: "client:", with: "")
        
        // Always report to CallKit
        reportIncomingCall(from: from, uuid: callInvite.uuid)
        activeCallInvites[callInvite.uuid.uuidString] = callInvite
    }
    
    func cancelledCallInviteReceived(_ cancelledCallInvite: TVOCancelledCallInvite, error: Error) {
        NSLog("cancelledCallInviteCanceled:error:, error: \(error.localizedDescription)")
        
        guard let activeCallInvites = activeCallInvites, !activeCallInvites.isEmpty else {
            NSLog("No pending call invite")
            return
        }
        
        let callInvite = activeCallInvites.values.first { invite in invite.callSid == cancelledCallInvite.callSid }
        
        if let callInvite = callInvite {
            performEndCallAction(uuid: callInvite.uuid)
        }
    }
}


// MARK: - TVOCallDelegate
extension VoiceCallViewController: TVOCallDelegate {
    func callDidStartRinging(_ call: TVOCall) {
        NSLog("callDidStartRinging:")
        
        self.callStatus.text = "Ringing..."
        //        placeCallButton.setTitle("Ringing", for: .normal)
        
        /*
         When [answerOnBridge](https://www.twilio.com/docs/voice/twiml/dial#answeronbridge) is enabled in the
         <Dial> TwiML verb, the caller will not hear the ringback while the call is ringing and awaiting to be
         accepted on the callee's side. The application can use the `AVAudioPlayer` to play custom audio files
         between the `[TVOCallDelegate callDidStartRinging:]` and the `[TVOCallDelegate callDidConnect:]` callbacks.
         */
        if playCustomRingback {
            playRingback()
        }
    }
    
    func callDidConnect(_ call: TVOCall) {
        NSLog("callDidConnect:")
        
        if playCustomRingback {
            stopRingback()
        }
        
        if let callKitCompletionCallback = callKitCompletionCallback {
            callKitCompletionCallback(true)
        }
        
        self.callStatus.text = "Connected"
        //        placeCallButton.setTitle("Hang Up", for: .normal)
        
        toggleUIState(isEnabled: true, showCallControl: true)
        stopSpin()
        toggleAudioRoute(toSpeaker: true)
    }
    
    func call(_ call: TVOCall, isReconnectingWithError error: Error) {
        NSLog("call:isReconnectingWithError:")
        
        self.callStatus.text = "Reconnecting..."
        //        placeCallButton.setTitle("Reconnecting", for: .normal)
        
        toggleUIState(isEnabled: false, showCallControl: false)
    }
    
    func callDidReconnect(_ call: TVOCall) {
        NSLog("callDidReconnect:")
        
        self.callStatus.text = "Connected"
        //        placeCallButton.setTitle("Hang Up", for: .normal)
        
        toggleUIState(isEnabled: true, showCallControl: true)
    }
    
    func call(_ call: TVOCall, didFailToConnectWithError error: Error) {
        NSLog("Call failed to connect: \(error.localizedDescription)")
        
        if let completion = callKitCompletionCallback {
            completion(false)
        }
        
        performEndCallAction(uuid: call.uuid)
        callDisconnected(call)
    }
    
    func call(_ call: TVOCall, didDisconnectWithError error: Error?) {
        if let error = error {
            NSLog("Call failed: \(error.localizedDescription)")
        } else {
            NSLog("Call disconnected")
        }
        print("Call Sid :- \(call.sid)")
        if !userInitiatedDisconnect {
            var reason = CXCallEndedReason.remoteEnded
            if error != nil {
                reason = .failed
            }
            callKitProvider.reportCall(with: call.uuid, endedAt: Date(), reason: reason)
        }
        
        callDisconnected(call)
    }
    
    
    func callDisconnected(_ call: TVOCall) {
        if call == activeCall {
            activeCall = nil
        }
        
        activeCalls.removeValue(forKey: call.uuid.uuidString)
        
        userInitiatedDisconnect = false
        
        if playCustomRingback {
            stopRingback()
        }
        
        stopSpin()
        toggleUIState(isEnabled: true, showCallControl: false)
        //        placeCallButton.setTitle("Call", for: .normal)
        
        self.endCallBtn.setTitle("Call Ended", for: .normal)
        self.endCallBtn.isUserInteractionEnabled = false
        self.callStatus.text = "Call Ended"
        
        if self.crossPressed{
            guard let result = self.completion else {
                self.removeView()
                return
            }
            result("-")
            self.removeView()
        } else{
//            self.callDetailsApi(callSid: call.sid)
            self.transcriptionEnded()
        }
        
    }
    
    
    // MARK: Ringtone
    
    func playRingback() {
        let ringtonePath = URL(fileURLWithPath: Bundle.main.path(forResource: "ringtone", ofType: "wav")!)
        
        do {
            ringtonePlayer = try AVAudioPlayer(contentsOf: ringtonePath)
            ringtonePlayer?.delegate = self
            ringtonePlayer?.numberOfLoops = -1
            
            ringtonePlayer?.volume = 1.0
            ringtonePlayer?.play()
        } catch {
            NSLog("Failed to initialize audio player")
        }
    }
    
    func stopRingback() {
        guard let ringtonePlayer = ringtonePlayer, ringtonePlayer.isPlaying else { return }
        
        ringtonePlayer.stop()
    }
}


// MARK: - CXProviderDelegate
extension VoiceCallViewController: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        NSLog("providerDidReset:")
        audioDevice.isEnabled = true
    }
    
    func providerDidBegin(_ provider: CXProvider) {
        NSLog("providerDidBegin")
    }
    
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        NSLog("provider:didActivateAudioSession:")
        audioDevice.isEnabled = true
    }
    
    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        NSLog("provider:didDeactivateAudioSession:")
    }
    
    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        NSLog("provider:timedOutPerformingAction:")
    }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        NSLog("provider:performStartCallAction:")
        
        toggleUIState(isEnabled: false, showCallControl: false)
        startSpin()
        
        audioDevice.isEnabled = false
        audioDevice.block()
        
        provider.reportOutgoingCall(with: action.callUUID, startedConnectingAt: Date())
        
        performVoiceCall(uuid: action.callUUID, client: "") { success in
            if success {
                provider.reportOutgoingCall(with: action.callUUID, connectedAt: Date())
                action.fulfill()
            } else {
                action.fail()
            }
        }
    }
    
    
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        NSLog("provider:performAnswerCallAction:")
        
        audioDevice.isEnabled = false
        audioDevice.block()
        
        performAnswerVoiceCall(uuid: action.callUUID) { success in
            if success {
                action.fulfill()
            } else {
                action.fail()
            }
        }
        
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        NSLog("provider:performEndCallAction:")
        
        if let invite = activeCallInvites[action.callUUID.uuidString] {
            invite.reject()
            activeCallInvites.removeValue(forKey: action.callUUID.uuidString)
        } else if let call = activeCalls[action.callUUID.uuidString] {
            call.disconnect()
        } else {
            NSLog("Unknown UUID to perform end-call action with")
            self.callStatus.text = "Unable to connect"
        }
        
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        NSLog("provider:performSetHeldAction:")
        
        if let call = activeCalls[action.callUUID.uuidString] {
            call.isOnHold = action.isOnHold
            action.fulfill()
        } else {
            action.fail()
        }
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        NSLog("provider:performSetMutedAction:")
        
        if let call = activeCalls[action.callUUID.uuidString] {
            call.isMuted = action.isMuted
            action.fulfill()
        } else {
            action.fail()
        }
    }
    
    
    // MARK: Call Kit Actions
    func performStartCallAction(uuid: UUID, handle: String) {
        let callHandle = CXHandle(type: .generic, value: handle)
        let startCallAction = CXStartCallAction(call: uuid, handle: callHandle)
        let transaction = CXTransaction(action: startCallAction)
        
        callKitCallController.request(transaction) { error in
            if let error = error {
                NSLog("StartCallAction transaction request failed: \(error.localizedDescription)")
                return
            }
            
            NSLog("StartCallAction transaction request successful")
            
            let callUpdate = CXCallUpdate()
            
            callUpdate.remoteHandle = callHandle
            callUpdate.supportsDTMF = true
            callUpdate.supportsHolding = true
            callUpdate.supportsGrouping = false
            callUpdate.supportsUngrouping = false
            callUpdate.hasVideo = false
            
            self.callKitProvider.reportCall(with: uuid, updated: callUpdate)
        }
    }
    
    func reportIncomingCall(from: String, uuid: UUID) {
        let callHandle = CXHandle(type: .generic, value: from)
        
        let callUpdate = CXCallUpdate()
        
        callUpdate.remoteHandle = callHandle
        callUpdate.supportsDTMF = true
        callUpdate.supportsHolding = true
        callUpdate.supportsGrouping = false
        callUpdate.supportsUngrouping = false
        callUpdate.hasVideo = false
        
        callKitProvider.reportNewIncomingCall(with: uuid, update: callUpdate) { error in
            if let error = error {
                NSLog("Failed to report incoming call successfully: \(error.localizedDescription).")
            } else {
                NSLog("Incoming call successfully reported.")
            }
        }
    }
    
    func performEndCallAction(uuid: UUID) {
        
        let endCallAction = CXEndCallAction(call: uuid)
        let transaction = CXTransaction(action: endCallAction)
        
        callKitCallController.request(transaction) { error in
            if let error = error {
                NSLog("EndCallAction transaction request failed: \(error.localizedDescription).")
            } else {
                NSLog("EndCallAction transaction request successful")
            }
        }
    }
    
    func performVoiceCall(uuid: UUID, client: String?, completionHandler: @escaping (Bool) -> Void) {
        guard let accessToken = fetchAccessToken() else {
            completionHandler(false)
            return
        }
        
        let connectOptions = TVOConnectOptions(accessToken: accessToken) { builder in
            builder.params = [
                self.twimlParamTo: self.storePhone
            ]
            builder.uuid = uuid
        }
        
        let call = TwilioVoice.connect(with: connectOptions, delegate: self)
        
        activeCall = call
        activeCalls[call.uuid.uuidString] = call
        callKitCompletionCallback = completionHandler
    }
    
    func performAnswerVoiceCall(uuid: UUID, completionHandler: @escaping (Bool) -> Void) {
        guard let callInvite = activeCallInvites[uuid.uuidString] else {
            NSLog("No CallInvite matches the UUID")
            return
        }
        
        let acceptOptions = TVOAcceptOptions(callInvite: callInvite) { builder in
            builder.uuid = callInvite.uuid
        }
        
        let call = callInvite.accept(with: acceptOptions, delegate: self)
        activeCall = call
        activeCalls[call.uuid.uuidString] = call
        callKitCompletionCallback = completionHandler
        
        activeCallInvites.removeValue(forKey: uuid.uuidString)
        
        guard #available(iOS 13, *) else {
            incomingPushHandled()
            return
        }
    }
}


// MARK: - AVAudioPlayerDelegate
extension VoiceCallViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            NSLog("Audio player finished playing successfully");
        } else {
            NSLog("Audio player finished playing with some error");
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            NSLog("Decode error occurred: \(error.localizedDescription)")
        }
    }
}


extension VoiceCallViewController {
    
    //Transcription
    
    func callDetailsApi(callSid : String){
        let params: Parameters = [
            "sid_number" : callSid
        ]
        
        showLoader()
        
        ApiInterface.requestApi(params: params, api_url: API.get_call_details , success: { (json) in
            if self.callStatus.text == "Unable to connect"{
                hideLoader()
                guard let result = self.completion else {
                    self.removeView()
                    return
                }
                result("--Unable to connect--")
                self.removeView()
            } else{
                if let data = json["data"].array{
                    self.recordings = data.map({RecordingModel.init(json: $0)})
                }
                
                var recordingURL = ("http://api.twilio.com" + (self.recordings.first?.uri ?? ""))
                recordingURL = recordingURL.replacingOccurrences(of: ".json", with: ".mp3")
                self.transcribeRecording(recordingURL)
            }
            
        }) { (error, json) in
            hideLoader()
            if self.callStatus.text == "Unable to connect"{
                guard let result = self.completion else {
                    self.removeView()
                    return
                }
                result("--Unable to connect--")
                self.removeView()
            } else{
                showSwiftyAlert("", error, false)
            }
        }
    }
    
    
    func transcribeRecording(_ url: String){
        guard let audioURL = URL(string: url) else {
            hideLoader()
            showSwiftyAlert("", "Unable to process Audio file", false)
            return
        }
        
        FileDownloader.loadFileAsync(url: audioURL) { (path, error) in
            print("Audio File downloaded to : \(path)")
            
            guard let audioPath = path else {
                hideLoader()
                showSwiftyAlert("", "Unable to process Audio file", false)
                return
            }
            
            let recognizer = SFSpeechRecognizer(locale: Locale.current)
            let request = SFSpeechURLRecognitionRequest(url: audioPath)
            
            DispatchQueue.main.async {
                self.callStatus.text = "Transcribing..."
            }
            
            // start recognition!
            self.sfTask = recognizer?.recognitionTask(with: request) { [unowned self] (result, error) in
                // abort if we didn't get any transcription back
                guard let result = result else {
//                    showSwiftyAlert("", error?.localizedDescription ?? "", false)
                    print("There was an error: \(error!) , file corrupted")
                    self.transcriptionEnded()
                    return
                }
                // if we got the final transcription back, print it
                self.finalTranscription = result.bestTranscription.formattedString
                print(self.finalTranscription)
                if result.isFinal {
                    // pull out the best transcription...
                    self.transcriptionEnded()
                } else{
                    self.setupTimer()
                }
            }
        }
    }
    
   
    
    func setupTimer(){
        self.timer.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(self.transcriptionEnded), userInfo: nil, repeats: false)
    }
    
    @objc func transcriptionEnded(){
//        DispatchQueue.main.async {
//            self.callStatus.text = "Transcription Completed"
//        }
        
        self.timer.invalidate()
        self.sfTask?.cancel()
        self.sfTask?.finish()
        hideLoader()
        print("Final Transcription = \(self.finalTranscription)")
        
        guard let result = self.completion else {
            self.removeView()
            return
        }
        result(self.finalTranscription)
        self.removeView()
    }
    
}

extension VoiceCallViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dialers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DilaPadCVC", for: indexPath)as! DilaPadCVC
        cell.dialBtn.setTitle(self.dialers[indexPath.item], for: .normal)
        
        if self.dialers[indexPath.item] == "*"{
            cell.dialBtn.titleLabel?.font = UIFont.init(name: "Roboto-Bold", size: 60)
            cell.dialBtn.titleEdgeInsets.top = 17
        } else{
            cell.dialBtn.titleLabel?.font = UIFont.init(name: "Roboto-Bold", size: 35)
            cell.dialBtn.titleEdgeInsets.top = 0
        }
        
        cell.dialBtn.tag = indexPath.item
        cell.dialBtn.addTarget(self, action: #selector(self.dialBtn(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 50, height: 50)
    }
   
}
