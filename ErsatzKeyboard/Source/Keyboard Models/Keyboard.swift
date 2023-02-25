//  Created by Robin Hill on 5/28/22.
//  Copyright © 2022 Apple. All rights reserved.
//

/// Model representing the layout of keys on the keyboard, with multiple pages
public final class Keyboard {
    var pages: [Page] = []
    
    /// Add a key to the given row on the given page
    public func add(key: Key, row: Int, page: Int) {
        if self.pages.count <= page {
            for _ in self.pages.count...page {
                self.pages.append(Page())
            }
        }
        
        self.pages[page].add(key: key, row: row)
    }
    
    public init() {}
}
