//
// Copyright 2016 Sinch AB (reg. no 556969-5397)
//
// This SDK and all the associated software, documents and other content in
// this package file (the "Software") is provided by the Swedish company
// Sinch AB (reg. no 556969-5397) under the Sinch Terms of Service
// located at http://www.sinch.com/terms-of-service (the "Terms of Service").
//
// You are not allowed to in any way use or handle or access the Software
// before accepting the Terms of Service. Not limiting anything in the
// Terms of Service; by downloading, accessing and/or using the Software,
// you acknowledge that you have read and understand the Terms of Service
// and accept to be bound by them.

// The Software contains valuable, confidential and proprietary information of
// Sinch AB. Unauthorized reproduction, transmission, distribution
// or use of the Software is a violation of Sinch AB's rights and
// applicable laws.
//

import Foundation

// The following import should only be in effect when compiling these
// Swift bindings as part of the SinchVerification-Swift pod.
#if COCOAPODS
import SinchVerificationObjC
#endif

/**
    Protocol for a Verification.
*/

public protocol Verification {
    
    /**
    Initiate the verification.
    
    A request will be sent to the Sinch backend to initiate the verification.
    A SMS-based verification will initiate sending an SMS to the destination phone number.
    A Callout-based verification will initiate placing phone call the destination phone number.
    
    - parameter completion: Closure that will be invoked upon completion.
    */
    func initiate(_ completion: @escaping (InitiationResult, Error?) -> Void);
  
    /**
    Complete the verification by verifying the verification code sent to the user.

    - parameter code: Verification code that the user received and have given as input to the application.
    
    - parameter completion: Closure that will be invoked upon completion.
    */
    func verify(_ code: String, completion: @escaping (Bool, Error?) -> Void);

    /**
    Cancel the verification (client-side only).
    
    Note that cancelling is a client-side only action, i.e. it will not send any
    further requests to the Sinch platform and it does not guarantee that a SMS
    or a callout won't be made to the user's device. What it will do is cancel any
    long-polling requests that this verification instance may be maintaining (e.g.
    a callout verification is performing polling to query the Sinch platform for
    the status of the verification)

    If the verification is in a state where a completion handler have been specified, 
    the handler will be invoked with the error code SINVerificationErrorCancelled.
    
    */
    func cancel();

    
    /**
    Specify a dispatch queue on which `completion` blocks should be invoked on.
    
    Unless specified, the main queue is used by default.
    
    This must be set before initiate(1) or verify(2) is called.
    
    - parameter queue: GCD dispatch queue
    */
    func completionQueue(_ queue: DispatchQueue);
    
    /**
    Specify a specific Sinch environment host. (This is not mandatory.)
    
    This must be set before initiate(1) or verify(2) is called.
    
    - parameter host: Host for base URL for the Sinch API environment to be used. E.g. 'sandbox.sinch.com'
    */
    func environmentHost(_ host: String);
    

}

/**
Create a new SMS verification.

- parameter applicationKey: Application key identifying the application.
    
- parameter phoneNumber: The phone number to verify.
                    The phone number should be given according to E.164 number formatting
                    (http://en.wikipedia.org/wiki/E.164) and should be prefixed with a '+'.
                    E.g. to call the US phone number 415 555 0101, it should be specified as
                    "+14155550101", where the '+' is the required prefix and the US country
                    code '1' added before the local subscriber number.
- parameter languages: The preferred content language for SMS verification. It is specified via
                   a list of IETF language tags in order of priority. If the first language
                   is not available, the next one will be selected and so forth. The default
                   is 'en-US'.
- returns: A new SMS Verification object.
*/
public func SMSVerification(_ applicationKey: String, phoneNumber: String, languages: [String]) -> Verification {
    return VerificationWrapper(
      SINVerification.smsVerification(withApplicationKey: applicationKey, phoneNumber: phoneNumber, languages: languages));
}

/**
 Create a new SMS verification.
 
 - parameter applicationKey: Application key identifying the application.
 
 - parameter phoneNumber: The phone number to verify.
 The phone number should be given according to E.164 number formatting
 (http://en.wikipedia.org/wiki/E.164) and should be prefixed with a '+'.
 E.g. to call the US phone number 415 555 0101, it should be specified as
 "+14155550101", where the '+' is the required prefix and the US country
 code '1' added before the local subscriber number.
 
 - returns: A new SMS Verification object.
 */
public func SMSVerification(_ applicationKey: String, phoneNumber: String) -> Verification {
  return VerificationWrapper(SINVerification.smsVerification(withApplicationKey: applicationKey, phoneNumber: phoneNumber));
}

/**
 Create a new SMS verification.
 
 - parameter applicationKey: Application key identifying the application.
 
 - parameter phoneNumber: The phone number to verify.
 The phone number should be given according to E.164 number formatting
 (http://en.wikipedia.org/wiki/E.164) and should be prefixed with a '+'.
 E.g. to call the US phone number 415 555 0101, it should be specified as
 "+14155550101", where the '+' is the required prefix and the US country
 code '1' added before the local subscriber number.
 
 - parameter custom: Application-specific custom data that will be passed to
 REST API callbacks made to the application's backend.
 This custom data will also be written to CDRs (Call Detail Records).
 (If complex data is to be passed along, it must first be encoded as a
 NSString*, e.g. encoded as JSON or Base64.)
 
 - returns: A new SMS Verification object.
 */
public func SMSVerification(_ applicationKey: String, phoneNumber: String, custom: String) -> Verification {
    let objcVerification = SINVerification.smsVerification(withApplicationKey: applicationKey, phoneNumber: phoneNumber, custom:custom);
    return VerificationWrapper(objcVerification);
}

/**
 Create a new SMS verification.
 
 - parameter applicationKey: Application key identifying the application.
 
 - parameter phoneNumber: The phone number to verify.
 The phone number should be given according to E.164 number formatting
 (http://en.wikipedia.org/wiki/E.164) and should be prefixed with a '+'.
 E.g. to call the US phone number 415 555 0101, it should be specified as
 "+14155550101", where the '+' is the required prefix and the US country
 code '1' added before the local subscriber number.
 
 - parameter custom: Application-specific custom data that will be passed to
 REST API callbacks made to the application's backend.
 This custom data will also be written to CDRs (Call Detail Records).
 (If complex data is to be passed along, it must first be encoded as a
 NSString*, e.g. encoded as JSON or Base64.)
 
 - parameter languages: The preferred content language for SMS verification. It is specified via
 a list of IETF language tags in order of priority. If the first language
 is not available, the next one will be selected and so forth. The default
 is 'en-US'.
 
 - returns: A new SMS Verification object.
 */
public func SMSVerification(_ applicationKey: String, phoneNumber: String, custom: String, languages: [String])-> Verification {
  let objcVerification = SINVerification.smsVerification(withApplicationKey: applicationKey, phoneNumber: phoneNumber, custom:custom, languages:languages);
  return VerificationWrapper(objcVerification);
}

/**
Create a new Callout verification.

- parameter applicationKey: Application key identifying the application.
    
- parameter phoneNumber: The phone number to verify.
                    The phone number should be given according to E.164 number formatting
                    (http://en.wikipedia.org/wiki/E.164) and should be prefixed with a '+'.
                    E.g. to call the US phone number 415 555 0101, it should be specified as
                    "+14155550101", where the '+' is the required prefix and the US country
                    code '1' added before the local subscriber number.

- returns: A new Callout Verification object.
*/
public func CalloutVerification(_ applicationKey: String, phoneNumber: String) -> Verification {
    let objcVerification = SINVerification.calloutVerification(withApplicationKey: applicationKey, phoneNumber: phoneNumber);
    return VerificationWrapper(objcVerification);
}

/**
 Create a new Callout verification.
 
 - parameter applicationKey: Application key identifying the application.
 
 - parameter phoneNumber: The phone number to verify.
 The phone number should be given according to E.164 number formatting
 (http://en.wikipedia.org/wiki/E.164) and should be prefixed with a '+'.
 E.g. to call the US phone number 415 555 0101, it should be specified as
 "+14155550101", where the '+' is the required prefix and the US country
 code '1' added before the local subscriber number.
 
 - parameter custom: Application-specific custom data that will be passed to
 REST API callbacks made to the application's backend.
 This custom data will also be written to CDRs (Call Detail Records).
 (If complex data is to be passed along, it must first be encoded as a
 NSString*, e.g. encoded as JSON or Base64.)
 
 - returns: A new Callout Verification object.
 */
public func CalloutVerification(_ applicationKey: String, phoneNumber: String, custom:String) -> Verification {
    let objcVerification = SINVerification.calloutVerification(withApplicationKey: applicationKey, phoneNumber: phoneNumber, custom:custom);
    return VerificationWrapper(objcVerification);
}

/**
 Get version string and set log callback of the Sinch Verification SDK
*/
open class SinchVerification {

    /**
     - returns: Version string of the Sinch Verification SDK
    */
    static public func version() -> String {
        return SINVerification.version();
    }
  
    /**
     Set a log callback block.

     The Sinch Verification SDK will emit all it's logging by invoking the specified block.

     - parameter logCallBack: log callback block. IMPORTANT: The block may be invoked on any thread / GCD queue.
    */
  
    static public func setLogCallback(logCallBack: @escaping LogCallback) -> Void {
      SINVerification.setLogCallback { (severity:SINVLogSeverity, area:String, message:String, timestamp:Date) in
        logCallBack(mapSINVLogSeverity(severity), area, message, timestamp)
      }
    }
}

public typealias LogCallback = (LogSeverity, String, String, Date) -> Swift.Void

public enum LogSeverity: Int {
  case trace
  case info
  case warning
  case critical
}

/**
 Return the initiation result and content language of the verification
*/
public class InitiationResult {
  /**
   A boolean value indicating whether the initiation succeed.
  */
  public let success:Bool;

  /**
   The content language for SMS verification, returned as an IETF language tag in 'Language-Region' format.

   Example: 'en-US' (English as used in the United States). For more information, check IETF's document at
    https://tools.ietf.org/html/bcp47
  */
  public let contentLanguage:String?;
  
  init(success:Bool, contentLanguage:String) {
    self.success = success;
    self.contentLanguage = contentLanguage;
  }
  
  init(fromSINInitiationResult result:SINInitiationResult) {
    self.success = result.success;
    if((result.contentLanguage) != nil) {
      self.contentLanguage = result.contentLanguage;
    } else {
      self.contentLanguage = nil;
    }
  }
  
}

fileprivate func mapSINVLogSeverity(_ sinchLogSeverity: SINVLogSeverity) -> LogSeverity {
  switch(sinchLogSeverity) {
  case SINVLogSeverity.trace:
    return LogSeverity.trace;
  case SINVLogSeverity.info:
    return LogSeverity.info
  case SINVLogSeverity.warning:
    return LogSeverity.warning
  case SINVLogSeverity.critical:
    return LogSeverity.critical
  }
}

/**
An opaque protocol representing a parsed phone number.

Example usage: 

- It be passed as an argument when creating a Sinch Verification
instance

- It can be passed as an argument to the PhoneNumberUtil formatting
  functions.
  
*/
public protocol PhoneNumber {
    /**
    Country calling code according to the International
    Telecommunication Union (ITU).
    
    (Sometimes also referred to as country dial in code.)

    IMPORTANT: This is _not_ the same as an ISO-3166-1 country code.
    */
    var countryCode : Int { get }
    
    /**
    - returns: The raw input that was provided when the phone number
      was parsed. May be nil (e.g. if the phone number is an example
      number, and was not parsed from user input).
    */
    var rawInput : String? { get }
}

/**
When formatting a phone number that is to be used to initiate a Sinch
Verification, the format PhoneNumberFormat.E164 should be used. The
other two formats (International and National) are primarily for
formatting for displaying in a GUI context.

For overview information on E.164 see
https://en.wikipedia.org/wiki/E.164. The International and National
formats are consistent with the definition in ITU-T Recommendation
E.123.
*/
public enum PhoneNumberFormat : Int {
    case e164
    case international
    case national
}

/**
Possible errors when parsing a string as a phone number.
*/
public enum PhoneNumberParseError: Error {
    case invalidCountryCode
    case notANumber
    case tooShortAfterIDD
    case tooShortNSN
    case tooLongNSN
}

/**
Possible errors when testing whether a string is a possible / viable
    phone number.
*/
public enum PhoneNumberValidationError {
    case invalidCountryCode
    case notANumber
    case tooShort
    case tooLong
}

/**
PhoneNumberUtil provides functionality to parse and format phone
numbers, and to test whether a string is a possible phone number.
*/
public protocol PhoneNumberUtil {
    /**
    Parse a string as a phone number. 

    The returned phone number object can then be passed to the
    formatting method `PhoneNumberUtil.parse`.

    - parameter input: String to be parsed

    - parameter defaultRegion: default region as ISO-3166-1 country code.

    - returns: a PhoneNumber

    - throws: PhoneNumberParseError

    */
    func parse(_ input: String, defaultRegion: String) throws -> PhoneNumber;

    /**
    Format a phone number in the specified format.

    - parameter phoneNumber: a phone number instance.
    
    - parameter format: a format specifier, e.g. E.164.

    - returns: The formatted phone number. Returns empty string if input is invalid.
    */
    func format(_ phoneNumber: PhoneNumber, format: PhoneNumberFormat) -> String;

    /**
    Get an example phone number.
 
    Defaults to returning a Mobile example number.
 
    - parameter isoCountryCode: region / country as ISO-3166-1 country code.

    - returns: an example phone number. May return nil if the input
               region country code is invalid.
    */
    func exampleNumber(_ isoCountryCode: String) -> PhoneNumber?;

    /**
    Checks whether input is a possible phone number, given a
    ISO-3166-1 country code where the number would be dialed from.

    Note that even if this method indicates that the input is a
    possible phone number, it doesn't necessarily mean it's a valid
    phone number. I.e. this is a less strict check.

    - parameter string: string to test whether it's a viable phone number.
    
    - parameter fromRegion: region / country as ISO-3166-1 country
                   code where the number will be dialed from.
                   
    - returns: A Bool `possible` that indicated whether the input is a
              viable phone number. An optional error indicating why
              the input is not considered a viable phone number. 
    */
    func isPossibleNumber(_ string: String, fromRegion: String) -> (possible: Bool, error: PhoneNumberValidationError?);
    
    /**
     Checks whether a parsed phone number is a viable phone number.
     
     - parameter phoneNumber: a parsed phone number to test whether
                              it's a possible / viable phone number.
     
     - returns: A Bool `possible` that indicated whether the input is a
     viable phone number. An optional error indicating why
     the input is not considered a viable phone number.
     */
    func isPossibleNumber(_ phoneNumber: PhoneNumber) -> (possible: Bool, error: PhoneNumberValidationError?);

    /**
    Returns a region / country list structure that contains info on all
    countries / regions available by NSLocale.ISOCountryCodes.  Each
    entry in the list provides info such as ISO 3166-1 country code,
    country dialing code, and country display name (according to the
    given locale).

    - parameter forLocale: locale that will determine display names for regions.

    - returns: a region list (note, it's a bridged Objective-C type).

    */
    func regionList(forLocale locale:Locale) -> SINRegionList;
}

/**
Get a shared instance of PhoneNumberUtil.

- returns: shared PhoneNumberUtil
*/
public func SharedPhoneNumberUtil() -> PhoneNumberUtil {
    let instance = {
        PhoneNumberUtilWrapper(SINPhoneNumberUtil());
    }();
    return instance;
}

/**
TextFieldPhoneNumberFormatter is a helper to perform
As-You-Type-Formatting on a UITextField. The formatter performs
formatting based on the region country code given at initialization.

Example usage:

    let textField = TextField.init(...);
    let isoCountryCode = DeviceRegion.currentCountryCode();

    let formatter = TextFieldPhoneNumberFormatter(countryCode: isoCountryCode);
    formatter.textField = textField;
    textField.placeholder = formatter.exampleNumber(format:PhoneNumberFormat.National);

    formatter.onTextFieldTextDidChange = { (textField: UITextField) -> Void in
        let text = textField.text != nil ? textField.text! : "";
        let util = SharedPhoneNumberUtil();
        let isPossible = util.isPossibleNumber(textField.text, 
                                               fromRegion: isoCountryCode);

        // Update GUI to hint whether current 
        // user input is a viable phone number.
    }

*/
public final class TextFieldPhoneNumberFormatter {

    /**
    Default initialization. Equivalent to initializing with
    SharedPhoneNumberUtil() and DeviceRegion.currentCountryCode().
     */
    public init() {
        self.objcFormatter = SINUITextFieldPhoneNumberFormatter.init();
    }

    /**
    Initialize with a specific country code.

    - parameter countryCode ISO 3166-1 two-letter country code that
                            indicates the country/region where the
                            phone number is being entered.
    */
    public init(countryCode: String) {
        self.objcFormatter = SINUITextFieldPhoneNumberFormatter.init(countryCode: countryCode);
    }

    public var textField: UITextField? {
        get {
            return self.objcFormatter.textField;
        }
        set(textField){
            self.objcFormatter.textField = textField;
        }
    }

    public var countryCode: String {
        get {
            return self.objcFormatter.countryCode;
        }
        set(countryCode){
            self.objcFormatter.countryCode = countryCode;
        }
    }

    /**
    onTextFieldTextDidChange is a callback that is invoked when the
    text value of the observed UITextField changes. This callback
    handles both events from UITextFieldTextDidChangeNotification and
    KVO-events for the UITextField.text property.

    It can be used to implement additional hooks like indicating to
    the user whether the current input is a possibly valid phone
    number, e.g. with PhoneNumberUtil.isPossibleNumber.
    */
    public var onTextFieldTextDidChange: ((UITextField) -> Void)? {
        get {
            return self.objcFormatter.onTextFieldTextDidChange;
        }
        set(closure){
            self.objcFormatter.onTextFieldTextDidChange = closure;
        }
    }
    
    /** 
    Get a an example phone number formatted according to given format.

    The returned string can be used as placeholder text for a
    UITextField.
    
    - returns: a formatted phone number string. Will return an empty
               string if no example phone number is available for the
               given region country code.
    */
    public func exampleNumber(_ format:PhoneNumberFormat) -> String? {
        return self.objcFormatter.exampleNumber(with: ConvertPhoneNumberFormat(format));
    }

    fileprivate var objcFormatter: SINUITextFieldPhoneNumberFormatter;
}

/*
DeviceRegion is a helper class to get the current device's ISO-3166-1
country code from the carrier information / SIM card.
*/

open class DeviceRegion {
    /**
     Get the current device's current region ISO-3166-1 country code based  on:
     
     Primarily, the current SIM card's carrier country code information if available.
     Fallback to querying [NSLocale currentLocale] for NSLocaleCountryCode.
     
     - returns: A ISO-3166-1 country code (uppercased)
     */
    static public func currentCountryCode() -> String {
        return SINDeviceRegion.currentCountryCode();
    }
}

/* 
* Below follows internal implementation classes. Primarily wrappers around the Objective-C APIs.
*/

/**
    VerificationWrapper - wrapper around Objective-C verification object.
*/
internal class VerificationWrapper: Verification {
  
    init(_ verification: SINVerificationProtocol) {
        self.objcVerification = verification;
        
        // Specify, for analytics purposes, that the Swift bindings are used.
        let setIsSwiftFlavor = Selector(("sin_setSinchSDKIsSwiftFlavor"));
        if objcVerification.responds(to: setIsSwiftFlavor){
            self.objcVerification.perform(setIsSwiftFlavor);
        }
    }
  
    func initiate(_ completion: @escaping (InitiationResult, Error?) -> Void) {
        self.objcVerification.initiate(completionHandler: { (result:SINInitiationResult, error: Error?) -> Void in
          let initiationResult = InitiationResult(fromSINInitiationResult:result);
          completion(initiationResult, error);
        });
    }
  
    func verify(_ code: String, completion: @escaping (Bool, Error?) -> Void) {
        self.objcVerification.verifyCode(code, completionHandler: { (success: Bool, error: Error?) -> Void in
          completion(success, error);
        });
    }

    func cancel() {
        self.objcVerification.cancel();
    }
    
    func completionQueue(_ queue: DispatchQueue) {
        self.objcVerification.setCompletionQueue(queue);
    }

    func environmentHost(_ host: String) {
        self.objcVerification.setEnvironmentHost(host);
    }
    
    fileprivate var objcVerification: SINVerificationProtocol;

}

internal class PhoneNumberWrapper : PhoneNumber {
    init(_ phoneNumber: SINPhoneNumber) {
        self.objcPhoneNumber = phoneNumber;
    }
    
    var countryCode : Int { return self.objcPhoneNumber.countryCode.intValue; }
    
    var rawInput : String? { return self.objcPhoneNumber.rawInput }

    fileprivate var objcPhoneNumber: SINPhoneNumber;
}

internal class PhoneNumberUtilWrapper: PhoneNumberUtil {
    
    init(_ util: SINPhoneNumberUtilProtocol) {
        self.objcUtil = util;
    }
    
    fileprivate var objcUtil : SINPhoneNumberUtilProtocol;
    
    func parse(_ input: String, defaultRegion: String) throws -> PhoneNumber {
        do {
            return try PhoneNumberWrapper(self.objcUtil.parse(input, defaultRegion: defaultRegion));
        } catch let nsError as NSError {
            if(nsError.domain == SINPhoneNumberParseErrorDomain){
                if let objcError = SINPhoneNumberParseError.init(rawValue: nsError.code) {
                    switch (objcError){
                        case .invalidCountryCode:
                            throw PhoneNumberParseError.invalidCountryCode
                        case .notANumber:
                            throw PhoneNumberParseError.notANumber;
                        case .tooShortAfterIDD:
                            throw PhoneNumberParseError.tooShortAfterIDD;
                        case .tooShortNSN:
                            throw PhoneNumberParseError.tooShortNSN;
                        case .tooLongNSN:
                            throw PhoneNumberParseError.tooLongNSN;
                    }
                }
            }
            // Unexpected NSError
            throw nsError;
        }
    }
    
    func format(_ phoneNumber: PhoneNumber, format: PhoneNumberFormat) -> String {
        if let wrapper = phoneNumber as? PhoneNumberWrapper {
            return self.objcUtil.formatNumber(wrapper.objcPhoneNumber, format: ConvertPhoneNumberFormat(format));
        } else {
            NSLog("PhoneNumber is not wrapping an Objective-C PhoneNumber. Should not happen.");
            abort();
        }
    }
    
    func exampleNumber(_ isoCountryCode: String) -> PhoneNumber? {
        if let phoneNumber = self.objcUtil.exampleNumber(forRegion: isoCountryCode) {
            return PhoneNumberWrapper(phoneNumber);
        } else {
            return nil;
        }
    }
    
    func mapValidationError(_ nsError: NSError) -> PhoneNumberValidationError {
        if(nsError.domain == SINPhoneNumberValidationErrorDomain){
            if let objcError = SINPhoneNumberValidationError.init(rawValue: nsError.code) {
                switch (objcError){
                case SINPhoneNumberValidationError.invalidCountryCode:
                    return .invalidCountryCode;
                case SINPhoneNumberValidationError.notANumber:
                    return .notANumber;
                case SINPhoneNumberValidationError.tooShort:
                    return .tooShort;
                case SINPhoneNumberValidationError.tooLong:
                    return .tooLong;
                case SINPhoneNumberValidationError.invalidNumber:
                    // TODO: This mapping is not entirely thruthful, because
                    // we do not expose a Swift error code corresponding to the InvalidNumber
                    // error code that can be given from the Objective-C method isValidNumber.
                    // When / if isValidNumber is exposed as part of these Swift bindings,
                    // then this mapping should be updated.
                    return .notANumber;
                }
            }
        }
        // Unexpected NSError
        return .notANumber;
    }
    
    func isPossibleNumber(_ string: String, fromRegion: String) -> (possible: Bool, error: PhoneNumberValidationError?) {
        do {
            try self.objcUtil.isPossibleNumber(string, fromRegion: fromRegion);
            return (true, nil);
        } catch let nsError as NSError {
            return (false, mapValidationError(nsError));
        }
    }
    
    func isPossibleNumber(_ phoneNumber: PhoneNumber) -> (possible: Bool, error: PhoneNumberValidationError?) {
        do {
            if let wrapper = phoneNumber as? PhoneNumberWrapper {
                try self.objcUtil.isPossibleNumber(wrapper.objcPhoneNumber);
                return (true, nil);
            } else {
                return (false, PhoneNumberValidationError.notANumber);
            }
        } catch let nsError as NSError {
            return (false, mapValidationError(nsError));
        }
    }

    func regionList(forLocale locale:Locale) -> SINRegionList {
        return self.objcUtil.regionList(with: locale);
    }
}


internal func ConvertPhoneNumberFormat(_ format: PhoneNumberFormat) -> SINPhoneNumberFormat {
    switch(format){
    case .e164:
        return SINPhoneNumberFormat.E164;
    case .national:
        return SINPhoneNumberFormat.national;
    case .international:
        return SINPhoneNumberFormat.international;
    }
}

