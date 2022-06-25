//
//  Note Pressure Amount.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.Event.Note.Pressure {
    
    /// Channel Voice 7-Bit (MIDI 1.0) / 32-Bit (MIDI 2.0) Value
    public typealias Amount = MIDI.Event.ChanVoice7Bit32BitValue
    
    public typealias AmountValidated = MIDI.Event.ChanVoice7Bit32BitValue.Validated
    
}
