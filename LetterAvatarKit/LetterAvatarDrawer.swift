//
//  LetterAvatarDrawer.swift
//  LetterAvatarKit
//
//  Created by Victor Peschenkov on 7/26/18.
//  Copyright © 2018 Victor Peschenkov. All rights reserved.
//

import Foundation

// MARK: Typealiases

public typealias DrawHandler = (
    _ letters: String,
    _ backgroundColor: CGColor,
    _ configuration: LetterAvatarBuilderConfiguration
    ) -> UIImage?

// MARK: Factory Method
// swiftlint:disable identifier_name
public func LetterAvatarDrawHandlerMake(_ type: DrawerType) -> DrawHandler {
    switch type {
    case .square:
        return makeSquareDrawer()
    }
}
// swiftlint:enable identifier_name
// MARK: Private Methods

private func makeSquareDrawer() -> DrawHandler {
    return { letters, backgroundColor, configuration in
        let size = configuration.size
        let rect = CGRect(
            x: 0.0,
            y: 0.0,
            width: size.width,
            height: size.height
        )
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        if let context = UIGraphicsGetCurrentContext() {
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
            let avatarImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return avatarImage
        }
        return nil
    }
}
