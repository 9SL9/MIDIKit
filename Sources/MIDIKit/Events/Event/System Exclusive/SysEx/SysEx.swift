//
//  SysEx.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// System Exclusive: Manufacturer-specific
    ///
    /// - remark: MIDI 1.0 Spec:
    ///
    /// - "Receivers should ignore non-universal Exclusive messages with ID numbers that do not correspond to their own ID."
    ///
    /// - "Any manufacturer of MIDI hardware or software may use the system exclusive codes of any existing product without the permission of the original manufacturer. However, they may not modify or extend it in any way that conflicts with the original specification published by the designer. Once published, an Exclusive format is treated like any other part of the instruments MIDI implementation — so long as the new instrument remains within the definitions of the published specification."
    public struct SysEx: Equatable, Hashable {
        
        /// SysEx Manufacturer ID
        public var manufacturer: SysExManufacturer
        
        /// Data bytes
        public var data: [MIDI.Byte]
        
        /// UMP Group (0x0...0xF)
        public var group: MIDI.UInt4 = 0x0
        
    }
    
    /// System Exclusive: Manufacturer-specific
    ///
    /// - remark: MIDI 1.0 Spec:
    ///
    /// "Receivers should ignore non-universal Exclusive messages with ID numbers that do not correspond to their own ID."
    ///
    /// "Any manufacturer of MIDI hardware or software may use the system exclusive codes of any existing product without the permission of the original manufacturer. However, they may not modify or extend it in any way that conflicts with the original specification published by the designer. Once published, an Exclusive format is treated like any other part of the instruments MIDI implementation — so long as the new instrument remains within the definitions of the published specification."
    ///
    /// - Parameters:
    ///   - manufacturer: SysEx Manufacturer ID
    ///   - data: Data bytes
    ///   - group: UMP Group (0x0...0xF)
    public static func sysEx(manufacturer: SysExManufacturer,
                             data: [MIDI.Byte],
                             group: MIDI.UInt4 = 0x0) -> Self {
        
        .sysEx(
            .init(manufacturer: manufacturer,
                  data: data,
                  group: group)
        )
        
    }
    
}

extension MIDI.Event.SysEx {
    
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0xF0] + manufacturer.bytes + data + [0xF7]
        
    }
    
    #warning("> this needs specializing?")
    public static let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .data64bit
    
    public func umpRawWords() -> [MIDI.UMPWord] {
        
        #warning("> needs coding")
        
        let mtAndGroup = (Self.umpMessageType.rawValue.uInt8Value << 4) + group
        
        _ = manufacturer
        _ = data
        
        return []
        
    }
    
}