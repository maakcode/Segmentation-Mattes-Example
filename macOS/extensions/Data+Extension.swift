//Copyright © 2023 MaakCode. All rights reserved.

import Cocoa

extension Data {
    var cgImage: CGImage? {
        return NSImage(data: self)?.cgImage(forProposedRect: nil, context: nil, hints: nil)
    }
}
