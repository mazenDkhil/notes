//
//  NoteView.swift
//  Notes
//
//  Created by Mazen DEKHIL on 03/07/2024.
//

import SwiftUI
import RichTextKit

struct NoteView: View {
    
    @State var isEditing: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var selectedImage: UIImage? = nil
    @FocusState private var isTextFieldFocused: Bool
    @StateObject private var viewModel: NotesViewModel
    let context = RichTextContext()
    
    init() {
        _viewModel = StateObject(wrappedValue: NotesViewModel(notes: NSAttributedString(string: "Type your note here...")))
    }
    
    var body: some View {
        VStack {
            if isEditing {
                RichTextEditor(text: $viewModel.notes, context: context)
                    .focused($isTextFieldFocused)
                    .onChange(of: isTextFieldFocused) { newValue in
                        if (!newValue) {
                            handleTextFieldFocusChange()
                        }
                    }
                RichTextKeyboardToolbar(
                    context: context,
                    leadingButtons: { _ in
                        Button(action: {
                            showImagePicker = true
                        }) {
                            Image(systemName: "photo.on.rectangle.angled")
                        }
                    },
                    trailingButtons: { $0 },
                    formatSheet: {  $0 }
                )
            } else {
                RichTextViewer(viewModel.notes)
                    .onTapGesture {
                        isEditing = true
                    }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage, onImagePicked: { image in
                if let image = image {
                    viewModel.insertImage(image, in: context.selectedRange)
                }
            })
        }
        .onAppear {
            viewModel.detectLinks()
        }
    }
    
    private func handleTextFieldFocusChange() {
         finalizeEditing()
    }
    
    private func finalizeEditing() {
        isEditing = false
        viewModel.detectLinks()
    }
}
