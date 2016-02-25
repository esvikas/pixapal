//
//  Errors.swift
//  Pixapals
//
//  Created by DARI on 2/23/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
//error messages
//server errors
enum APIConnectionErrorMessage: String {
    case ConnectionErrorMessage = "Can't connect right now. Check your internet settings."
    case NoDataFoundErrorMessage = "No not found in the server."
    case InvalidEmailPasswordErrorMessage = "The email or password you've entered doesn't match any account."
    case FacebookCantLoginErrorMessage = "You can't login using the facebook account."
    case FacebookLoginConnectionErrorMessage = "Can't connect to your facebook account. Please use other form to login or try again later."
    case CantAuthenticateErrorMessage = "Connection to authentication server failed."
    case NoMoreDataInServerErrorMessage = "No newer feeds. Please try again later."
    case CantGetUserInfoFromFacebookErrorMessage = "Can't access your information from facebook."
    case CantGetFriendInfoFromFacebookErrorMessage = "Can't access your facebook's friend list"
}
//validation errors
enum ValidationErrorMessage: String {
    case InvalidEmailErrorMessage = "The email you've entered is incorrect."
    case EmptyPasswordFieldErrorMessage = "Password field is empty."
    case EmptyUsernameFieldErrorMessage = "Username field is empty."
    case GenderNotSelectedErrorMessage = "Please choose a gender."
    case EmptyFullNameErrorMessage = "Full name field is empty."
    case PasswordNotConfirmedErrorMessage = "Password and confirm password doesn't match"
}

//accessibilities error
enum AccessibilityErrorMessage: String {
    case LocationNotEnabledErrorMessage = "Location service is turned off. Please turn on location."
    case LocationAccessDeniedErrorMessage = "Location access to the app is denied. Check settings for app in settings."
}
//feed error
enum FeedErrorMessage: String {
    case CantLoveItLeaveItErrorMessage = "An error occurred while processing this request. Please try again later."
    case NoFeedDataAvailableErrorMessage = "No feed data is available in the server."
}

//fed error
enum FedErrorMessage: String {
    case CantFedTheUserErrorMessage = "An error occurred while processing this request. Please try again later."
}

//fed success
enum FedSuccessMessage: String {
    case FedSuccessfullySuccessMessage = "Thank you! You have successfully fed the user."
}

enum MiscErrorMessage: String {
   case NotAvailableErrorMessage = "Not Available"
}

////error titles
////server error title
//enum APIConnectionErrorTitle: String {
//    case ConnectionErrorMessage = "Error"
//    case NoDataFoundErrorMessage = "Error"
//    case InvalidEmailPasswordErrorMessage = "Error"
//    case FacebookCantLoginErrorMessage = "Error"
//    case FacebookLoginConnectionErrorMessage = "Error"
//    case CantAuthenticateErrorMessage = "Error"
//    case NoMoreDataInServer = "Error"
//}
//
//enum ValidationErrorTitle: String {
//    case InvalidEmailErrorMessage = "Error"
//    case EmptyPasswordFieldErrorMessage = "Error"
//    case EmptyUsernameFieldErrorMessage = "Error"
//    case GenderNotSelectedErrorMessage = "Error"
//}
//
//enum AccessibilityErrorMessage: String {
//    case LocationNotEnabledErrorMessage = "Error"
//    case LocationAccessDeniedErrorMessage = "Error"
//}
//
//enum FeedErrorMessage: String {
//    case CantLoveItLeaveItErrorMessage = "Error"
//    case NoFeedDataAvailableErrorMessage = "Error"
//}
//
//enum FedErrorMessage: String {
//    case CantFedTheUserErrorMessage = "Error"
//}
//
//enum FedSuccessMessage: String {
//    case FedSuccessfullySuccessMessage = "Error"
//}

enum PixaPalsErrorType {
    
    case ConnectionError
    case NoDataFoundError
    case InvalidEmailPasswordError
    case FacebookCantLoginError
    case FacebookLoginConnectionError
    case CantAuthenticateError
    case NoMoreDataInServerError
    case CantGetUserInfoFromFacebookError
    case CantGetFriendInfoFromFacebookError
    
    //validation errors
    case InvalidEmailError
    case EmptyPasswordFieldError
    case EmptyUsernameFieldError
    case GenderNotSelectedError
    case EmptyFullNameError
    case PasswordNotConfirmedError
    
    //accessibilities error
    case LocationNotEnabledError
    case LocationAccessDeniedError
    
    //feed error
    case CantLoveItLeaveItError
    case NoFeedDataAvailableError
    
    //fed error
    case CantFedTheUserError
    
    //fed success
    case FedSuccessfully
    
    
    //settings errors
    case NotAvailableError

    
    func show(viewController: UIViewController, var title: String? = nil, var message: String? = nil) {
        if let _ = message {
            
        } else {
            message = {
                switch self {
                case .CantAuthenticateError:
                    return APIConnectionErrorMessage.CantAuthenticateErrorMessage.rawValue
                case .CantFedTheUserError:
                    return FedErrorMessage.CantFedTheUserErrorMessage.rawValue
                case .CantLoveItLeaveItError:
                    return FeedErrorMessage.CantLoveItLeaveItErrorMessage.rawValue
                case .ConnectionError:
                    return APIConnectionErrorMessage.ConnectionErrorMessage.rawValue
                case .EmptyPasswordFieldError:
                    return ValidationErrorMessage.EmptyPasswordFieldErrorMessage.rawValue
                case .EmptyUsernameFieldError:
                    return ValidationErrorMessage.EmptyUsernameFieldErrorMessage.rawValue
                case .FacebookCantLoginError:
                    return APIConnectionErrorMessage.FacebookCantLoginErrorMessage.rawValue
                case .FacebookLoginConnectionError:
                    return APIConnectionErrorMessage.FacebookLoginConnectionErrorMessage.rawValue
                case .FedSuccessfully:
                    return FedSuccessMessage.FedSuccessfullySuccessMessage.rawValue
                case .GenderNotSelectedError:
                    return ValidationErrorMessage.GenderNotSelectedErrorMessage.rawValue
                case .InvalidEmailError:
                    return ValidationErrorMessage.InvalidEmailErrorMessage.rawValue
                case .InvalidEmailPasswordError:
                    return APIConnectionErrorMessage.InvalidEmailPasswordErrorMessage.rawValue
                case .LocationAccessDeniedError:
                    return AccessibilityErrorMessage.LocationAccessDeniedErrorMessage.rawValue
                case .LocationNotEnabledError:
                    return AccessibilityErrorMessage.LocationNotEnabledErrorMessage.rawValue
                case .NoDataFoundError:
                    return APIConnectionErrorMessage.NoDataFoundErrorMessage.rawValue
                case .NoFeedDataAvailableError:
                    return FeedErrorMessage.NoFeedDataAvailableErrorMessage.rawValue
                case .NoMoreDataInServerError:
                    return APIConnectionErrorMessage.NoMoreDataInServerErrorMessage.rawValue
                case .EmptyFullNameError:
                    return ValidationErrorMessage.EmptyFullNameErrorMessage.rawValue
                case .PasswordNotConfirmedError:
                    return ValidationErrorMessage.PasswordNotConfirmedErrorMessage.rawValue
                case .NotAvailableError:
                    return MiscErrorMessage.NotAvailableErrorMessage.rawValue
                case CantGetUserInfoFromFacebookError:
                    return APIConnectionErrorMessage.CantGetUserInfoFromFacebookErrorMessage.rawValue
                case CantGetFriendInfoFromFacebookError:
                    return APIConnectionErrorMessage.CantGetFriendInfoFromFacebookErrorMessage.rawValue
                }
            }()
        }
        
        if title == nil {
            title = "Error"
        }
        self.showAlert(viewController, title: title!, message: message!)
    }
    
    private func showAlert(viewController: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(okAction)
        
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
}