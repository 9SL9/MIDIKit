//
//  NoteOff.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// Channel Voice Message: Note Off (Status `0x8`)
    public struct NoteOff: Equatable, Hashable {
        
        public var note: MIDI.UInt7
        
        public var velocity: MIDI.UInt7
        
        public var channel: MIDI.UInt4
        
        public var group: MIDI.UInt4 = 0
        
    }
    
    /// Channel Voice Message: Note Off (Status `0x8`)
    public static func noteOff(_ note: MIDI.UInt7,
                               velocity: MIDI.UInt7,
                               channel: MIDI.UInt4,
                               group: MIDI.UInt4 = 0) -> Self {
        
        .noteOff(
            .init(note: note,
                  velocity: velocity,
                  channel: channel,
                  group: group)
        )
        
    }
    
}

extension MIDI.Event.NoteOff {
    
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0x80 + channel.uInt8Value,
         note.uInt8Value,
         velocity.uInt8Value]
        
    }
    
    public static let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .midi1ChannelVoice
    
    public func umpRawWords() -> [MIDI.UMPWord] {
        
        let mtAndGroup = (Self.umpMessageType.rawValue.uInt8Value << 4) + group
        
        let word = MIDI.UMPWord(mtAndGroup,
                                0x80 + channel.uInt8Value,
                                note.uInt8Value,
                                velocity.uInt8Value)
        
        return [word]
        
    }
    
}
