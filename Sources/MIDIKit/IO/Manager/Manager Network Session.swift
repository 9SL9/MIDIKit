//
//  Manager.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import CoreMIDI

extension MIDI.IO {
    
    public enum NetworkConnectionPolicy: UInt, Equatable {
        
        case noOne
        case hostsInContactList
        case anyone
        
        internal init(_ coreMIDIPolicy: MIDINetworkConnectionPolicy) {
            
            switch coreMIDIPolicy {
            case .noOne:
                self = .noOne
                
            case .hostsInContactList:
                self = .hostsInContactList
                
            case .anyone:
                self = .anyone
                
            @unknown default:
                self = .noOne
            }
            
        }
        
        internal var coreMIDIPolicy: MIDINetworkConnectionPolicy {
            
            switch self {
            case .noOne:
                return .noOne
                
            case .hostsInContactList:
                return .hostsInContactList
                
            case .anyone:
                return .anyone
            }
            
        }
        
    }
    
}

extension MIDI.IO.Manager {
    
    /// Sets the default (global) MIDI Network Session state.
    ///
    /// Supported on macOS 10.15+, macCatalyst 13.0+ and iOS 4.2+.
    ///
    /// - Parameters:
    ///   - enabled: Enable or disable the default MIDI network session.
    ///   - policy: The policy that determines who can connect to this session.
    @available(macOS 10.15, macCatalyst 13.0, iOS 4.2, *)
    public static func setGlobalNetworkSession(enabled: Bool,
                                               policy: MIDI.IO.NetworkConnectionPolicy) {
        
        MIDINetworkSession.default().isEnabled = enabled
        MIDINetworkSession.default().connectionPolicy = policy.coreMIDIPolicy
        
    }
    
}
