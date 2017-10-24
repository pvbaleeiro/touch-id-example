//
//  TouchIDViewController.swift
//  touch-id-example
//
//  Created by Victor Baleeiro on 24/10/17.
//  Copyright © 2017 Going2. All rights reserved.
//

import UIKit
import LocalAuthentication


class TouchIDViewController: UIViewController {

    //-------------------------------------------------------------------------------------------------------------
    //MARK: Properties
    //-------------------------------------------------------------------------------------------------------------
    var context = LAContext()
    
    
    //-------------------------------------------------------------------------------------------------------------
    //MARK: Lifecycle
    //-------------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        var policy: LAPolicy?
        // Depending the iOS version we'll need to choose the policy we are able to use
        if #available(iOS 9.0, *) {
            // iOS 9+ users with Biometric and Passcode verification
            policy = .deviceOwnerAuthentication
        } else {
            // iOS 8+ users with Biometric and Custom (Fallback button) verification
            context.localizedFallbackTitle = "Fuu!"
            policy = .deviceOwnerAuthenticationWithBiometrics
        }
        
        var err: NSError?
        
        // Check if the user is able to use the policy we've selected previously
        guard context.canEvaluatePolicy(policy!, error: &err) else {
            //image.image = UIImage(named: "TouchID_off")
            // Print the localized message received by the system
            //message.text = err?.localizedDescription
            return
        }
        
        // Great! The user is able to use his/her Touch ID 👍
        //image.image = UIImage(named: "TouchID_on")
        //message.text = kMsgShowFinger
        loginProcess(policy: policy!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //-------------------------------------------------------------------------------------------------------------
    //MARK: Login
    //-------------------------------------------------------------------------------------------------------------
    private func loginProcess(policy: LAPolicy) {
        // Start evaluation process with a callback that is executed when the user ends the process successfully or not
        context.evaluatePolicy(policy, localizedReason: "OK" /*kMsgShowReason*/, reply: { (success, error) in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5, animations: {
                    //self.refresh.alpha = 1
                })
                
                guard success else {
                    guard let error = error else {
                        //self.showUnexpectedErrorMessage()
                        return
                    }
                    switch(error) {
                    case LAError.authenticationFailed:
                        //self.message.text = "There was a problem verifying your identity."
                        print("There was a problem verifying your identity.")
                    case LAError.userCancel:
                        print("Authentication was canceled by user.")
                        //self.message.text = "Authentication was canceled by user."
                        // Fallback button was pressed and an extra login step should be implemented for iOS 8 users.
                    // By the other hand, iOS 9+ users will use the pasccode verification implemented by the own system.
                    case LAError.userFallback:
                        print("The user tapped the fallback button (Fuu!)")
                        //self.message.text = "The user tapped the fallback button (Fuu!)"
                    case LAError.systemCancel:
                        print("Authentication was canceled by system.")
                        //self.message.text = "Authentication was canceled by system."
                    case LAError.passcodeNotSet:
                        print("Passcode is not set on the device.")
                        //self.message.text = "Passcode is not set on the device."
                    case LAError.touchIDNotAvailable:
                        print("Touch ID is not available on the device.")
                        //self.message.text = "Touch ID is not available on the device."
                    case LAError.touchIDNotEnrolled:
                        print("Touch ID has no enrolled fingers.")
                        //self.message.text = "Touch ID has no enrolled fingers."
                    // iOS 9+ functions
                    case LAError.touchIDLockout:
                        print("There were too many failed Touch ID attempts and Touch ID is now locked.")
                        //self.message.text = "There were too many failed Touch ID attempts and Touch ID is now locked."
                    case LAError.appCancel:
                        print("Authentication was canceled by application.")
                        //self.message.text = "Authentication was canceled by application."
                    case LAError.invalidContext:
                        print("LAContext passed to this call has been previously invalidated.")
                        //self.message.text = "LAContext passed to this call has been previously invalidated."
                    // MARK: IMPORTANT: There are more error states, take a look into the LAError struct
                    default:
                        print("Touch ID may not be configured")
                        //self.message.text = "Touch ID may not be configured"
                        break
                    }
                    return
                }
                
                // Good news! Everything went fine 👏
                //self.message.text = self.kMsgFingerOK
            }
        })
    }
}

