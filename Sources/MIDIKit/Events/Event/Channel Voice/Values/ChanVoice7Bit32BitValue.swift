//
//  ChanVoice7Bit32BitValue.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// Channel Voice 7-Bit (MIDI 1.0) / 32-Bit (MIDI 2.0) Value
    public enum ChanVoice7Bit32BitValue: Hashable {
        
        /// Protocol-agnostic unit interval (0.0...1.0)
        /// Scaled automatically depending on MIDI protocol (1.0/2.0) in use.
        case unitInterval(Double)
        
        /// MIDI 1.0 7-bit Channel Voice Value (0x00..0x7F)
        case midi1(MIDI.UInt7)
        
        /// MIDI 2.0 32-bit Channel Voice Value (0x00000000...0xFFFFFFFF)
        case midi2(UInt32)
        
    }
    
}

extension MIDI.Event.ChanVoice7Bit32BitValue: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        
        switch lhs {
        case .unitInterval(let lhsInterval):
            switch rhs {
            case .unitInterval(let rhsInterval):
                return lhsInterval == rhsInterval
                
            case .midi1(let rhsUInt7):
                return lhs.midi1Value == rhsUInt7
                
            case .midi2(let rhsUInt32):
                return lhs.midi2Value == rhsUInt32
                
            }
            
        case .midi1(let lhsUInt7):
            switch rhs {
            case .unitInterval(_):
                return lhsUInt7 == rhs.midi1Value
                
            case .midi1(let rhsUInt7):
                return lhsUInt7 == rhsUInt7
                
            case .midi2(let rhsUInt32):
                return lhs.midi2Value == rhsUInt32
                
            }
            
        case .midi2(let lhsUInt32):
            switch rhs {
            case .unitInterval(_):
                return lhsUInt32 == rhs.midi2Value
                
            case .midi1(let rhsUInt7):
                return lhs.midi1Value == rhsUInt7
                
            case .midi2(let rhsUInt32):
                return lhsUInt32 == rhsUInt32
                
            }
            
        }
        
    }
    
}

extension MIDI.Event.ChanVoice7Bit32BitValue {
    
    /// Returns value as protocol-agnostic unit interval, converting if necessary.
    @inline(__always)
    public var unitIntervalValue: Double {
        
        switch self {
        case .unitInterval(let interval):
            return interval.clamped(to: 0.0...1.0)
            
        case .midi1(let uInt7):
            return MIDI.Event.scaledUnitInterval(from7Bit: uInt7)
            
        case .midi2(let uInt32):
            return MIDI.Event.scaledUnitInterval(from32Bit: uInt32)
            
        }
        
    }
    
    /// Returns value as a MIDI 1.0 7-bit value, converting if necessary.
    @inline(__always)
    public var midi1Value: MIDI.UInt7 {
        
        switch self {
        case .unitInterval(let interval):
            return MIDI.Event.scaled7Bit(fromUnitInterval: interval)
            
        case .midi1(let uInt7):
            return uInt7
            
        case .midi2(let uInt32):
            return MIDI.Event.scaled7Bit(from32Bit: uInt32)
            
        }
        
    }
    
    /// Returns value as a MIDI 2.0 32-bit value, converting if necessary.
    @inline(__always)
    public var midi2Value: UInt32 {
        
        switch self {
        case .unitInterval(let interval):
            return MIDI.Event.scaled32Bit(fromUnitInterval: interval)
            
        case .midi1(let uInt7):
            return MIDI.Event.scaled32Bit(from7Bit: uInt7)
            
        case .midi2(let uInt32):
            return uInt32
            
        }
        
    }
    
}

extension MIDI.Event.ChanVoice7Bit32BitValue {
    
    @propertyWrapper
    public struct Validated: Equatable, Hashable {
        
        public typealias Value = MIDI.Event.ChanVoice7Bit32BitValue
        
        @inline(__always)
        private var value: Value
        
        @inline(__always)
        public var wrappedValue: Value {
            get {
                value
            }
            set {
                switch newValue {
                case .unitInterval(let interval):
                    value = .unitInterval(interval.clamped(to: 0.0...1.0))
                    
                case .midi1:
                    value = newValue
                    
                case .midi2:
                    value = newValue
                }
            }
        }
        
        @inline(__always)
        public init(wrappedValue: Value) {
            self.value = wrappedValue
        }
        
    }
    
}
