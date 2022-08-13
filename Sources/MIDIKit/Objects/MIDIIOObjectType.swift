//
//  MIDIIOObjectType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

import Foundation

/// Enum defining a `MIDIIOObjectProtocol`'s MIDI object type.
public enum MIDIIOObjectType: CaseIterable, Equatable, Hashable {
    case device
    case entity
    case inputEndpoint
    case outputEndpoint
}

#endif
