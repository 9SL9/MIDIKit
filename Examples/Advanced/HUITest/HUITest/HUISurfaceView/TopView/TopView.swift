//
//  TopView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

extension HUISurfaceView {
    func TopView() -> some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Text((huiSurface.isRemotePresent ? "🟢" : "🔴") + " Host")
                        .font(.system(size: 10))
                        .foregroundColor(.white)
                    Spacer()
                        .frame(height: 8)
                    Text("hui")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .frame(width: Self.kLeftSideViewWidth)
                        .foregroundColor(.white)
                }
                MeterBridgeView()
                LargeTextDisplayView()
                    .frame(width: Self.kRightSideViewWidth)
                Spacer()
            }
            .background(Color.black)
        }
    }
}
