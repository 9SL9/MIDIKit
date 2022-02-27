//
//  Manager ManagedType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import CoreMIDI

extension MIDI.IO.Manager {
    
    public enum ManagedType: CaseIterable, Hashable {
        
        case inputConnection
        case outputConnection
        case nonPersistentThruConnection
        case input
        case output
        
    }
    
    public enum TagSelection: Hashable {
        
        case all
        case withTag(String)
        
    }
    
}
