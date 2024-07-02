//
//  NoteViewModel.swift
//  Notes
//
//  Created by Mazen DEKHIL on 03/07/2024.
//

import UIKit

class NotesViewModel: ObservableObject {
    @Published var notes: NSAttributedString

    init(notes: NSAttributedString) {
        self.notes = notes
    }

    func insertImage(_ image: UIImage, in range: NSRange) {
        let textAttachment = NSTextAttachment()
        textAttachment.image = image
        
        let attributedString = NSAttributedString(attachment: textAttachment)
        let mutableNotes = NSMutableAttributedString(attributedString: notes)
        
        mutableNotes.replaceCharacters(in: range, with: attributedString)
        self.notes = mutableNotes
    }

    func detectLinks() {
        guard !notes.string.isEmpty else { return }

        let mutableNotes = NSMutableAttributedString(attributedString: notes)
        let text = mutableNotes.string
        let linkDetector: NSDataDetector?

        do {
            linkDetector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        } catch {
            print("Failed to create link detector: \(error)")
            return
        }

        guard let matches = linkDetector?.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) else {
            return
        }

        for match in matches {
            if let url = match.url {
                mutableNotes.addAttribute(.link, value: url, range: match.range)
            }
        }
        self.notes = mutableNotes
    }
}
