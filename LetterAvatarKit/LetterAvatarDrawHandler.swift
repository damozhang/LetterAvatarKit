//
//  LetterAvatarDrawHandler.swift
//  LetterAvatarKit
//
//  Created by Victor Peschenkov on 7/26/18.
//  Copyright © 2018 Victor Peschenkov. All rights reserved.
//

import Foundation

// MARK: Typealiases

public typealias DrawHandler = (_ args: DrawHandlerArgs) -> UIImage?

open class DrawHandlerArgs: NSObject {
    var letters: String
    var backgroundColor: CGColor
    var configuration: LetterAvatarBuilderConfiguration
    var context: CGContext
    var rect: CGRect
    
    init(
        letters: String,
        backgroundColor: CGColor,
        configuration: LetterAvatarBuilderConfiguration,
        context: CGContext,
        rect: CGRect
        ) {
        
        self.letters = letters
        self.backgroundColor = backgroundColor
        self.configuration = configuration
        self.context = context
        self.rect = rect
    }
}

// MARK: Factory Method
// swiftlint:disable identifier_name
public func LetterAvatarDrawHandlerMake(_ type: DrawerType) -> DrawHandler {
    switch type {
    case .square:
        return makeSquareDrawer()
    case .circle:
        return makeCircleDrawer()
    }
}
// swiftlint:enable identifier_name
// MARK: Private Methods
private func makeSquareDrawer() -> DrawHandler {
    return { args in
        let size = args.configuration.size
        let rect = args.rect
        let context = args.context
        let letters = args.letters
        let configuration = args.configuration
        let backgroundColor = args.backgroundColor
        
        // Drawing
        context.setFillColor(backgroundColor)
        context.fill(rect)
        let style = NSParagraphStyle.default.mutableCopy()
        let attributes = [
            NSAttributedStringKey.paragraphStyle: style,
            NSAttributedStringKey.font: configuration.font.withSize(min(size.height, size.width) / 2.0),
            NSAttributedStringKey.foregroundColor: configuration.color
        ]
        let lettersSize = letters.size(withAttributes: attributes)
        let lettersRect = CGRect(
            x: (rect.size.width - lettersSize.width) / 2.0,
            y: (rect.size.height - lettersSize.height) / 2.0,
            width: lettersSize.width,
            height: lettersSize.height
        )
        letters.draw(in: lettersRect, withAttributes: attributes)
        
        // Gets an image from the graphic context
        let avatarImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return avatarImage
    }
}

private func makeCircleDrawer() -> DrawHandler {
    return { args in
        let size = args.configuration.size
        let rect = args.rect
        let context = args.context
        let letters = args.letters
        let configuration = args.configuration
        let backgroundColor = args.backgroundColor
        
        // Drawing
        context.setFillColor(backgroundColor)
        context.fillEllipse(in: rect)
        let style = NSParagraphStyle.default.mutableCopy()
        let attributes = [
            NSAttributedStringKey.paragraphStyle: style,
            NSAttributedStringKey.font: configuration.font.withSize(min(size.height, size.width) / 2.0),
            NSAttributedStringKey.foregroundColor: configuration.color
        ]
        let lettersSize = letters.size(withAttributes: attributes)
        let lettersRect = CGRect(
            x: (rect.size.width - lettersSize.width) / 2.0,
            y: (rect.size.height - lettersSize.height) / 2.0,
            width: lettersSize.width,
            height: lettersSize.height
        )
        letters.draw(in: lettersRect, withAttributes: attributes)
        
        // Gets an image from the graphic context
        let avatarImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return avatarImage
    }
}
