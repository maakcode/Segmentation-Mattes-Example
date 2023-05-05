//Copyright © 2023 MaakCode. All rights reserved.

import UIKit

extension Data {
    var cgImage: CGImage? {
        return UIImage(data: self)?.cgImage
    }
}
