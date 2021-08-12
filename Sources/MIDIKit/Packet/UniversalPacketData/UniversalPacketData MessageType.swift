//
//  UniversalMIDIPacket MessageType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Packet.UniversalPacketData {
    
    public enum MessageType: MIDI.Nibble, CaseIterable {
        
        case utility                 = 0x0
        case systemRealTimeAndCommon = 0x1
        case midi1ChannelVoice       = 0x2
        case data64bit               = 0x3
        case midi2ChannelVoice       = 0x4
        case data128bit              = 0x5
        
        // 0x6...0xF are reserved as of MIDI 2.0 spec
        
    }
    
}
