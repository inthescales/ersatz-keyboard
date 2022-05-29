//  Created by Robin Hill on 5/28/22.
//  Copyright © 2022 Apple. All rights reserved.

/// A single page of the keyboard – a set of keys visible at one time
class Page {
    var rows: [[Key]] = []
    
    /// Add a key to the page at the given row
    func add(key: Key, row: Int) {
        if self.rows.count <= row {
            for _ in self.rows.count...row {
                self.rows.append([])
            }
        }

        self.rows[row].append(key)
    }
}
