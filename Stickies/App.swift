import SwiftUI

enum AppInfo {
    static let name: String = "Stickies"
    static let id: String = ""
    static let bundleID = "com.mesiow.Stickies"
    static let url: String = "https://apps.apple.com/app/id\(id)"
    static let termsUrl = "https://www.crispyappsllc.com/terms"
    static let privacyPolicyUrl = "https://www.crispyappsllc.com/privacy"
    static let supportEmail = "support@crispyappsllc.com"
    
    //Colors
    static let mainTintColor = Color("PrimaryAppTintColor")
    static let secondaryTintColor = Color("SecondaryAppTintColor")
    static let stickyNoteTintColor = Color("StickyNoteTintColor")
    static let stickyNoteBackgroundTintColor = Color("StickyNoteBackgroundTintColor")
    
    //Yellow Color
    static let actionButtonTintColor = Color("ActionButtonTintColor")
    static let actionButtonBackgroundTintColor = Color("ActionButtonBackgroundTintColor")
    
    //Red Color
    static let secondaryButtonTintColor = Color("SecondaryButtonTintColor")
    static let secondaryButtonBackgroundTintColor = Color("SecondaryButtonBackgroundTint")
    
    static let backgroundColor = secondaryTintColor.opacity(0.35)
    
    //Character image names
    static let sadCharacter = "character-sad"
    static let excitedCharacter = "character-excited"
}

enum SFSymbols {
    static let doc = "doc"
    static let wand = "wand.and.stars"
    static let photo = "photo"
    static let camera = "camera"
    static let chevronRight = "chevron.right"
    static let arrowRight = "arrow.right"
    static let share = "square.and.arrow.up"
    static let save = "square.and.arrow.down"
    static let checkmarkCircle = "checkmark.circle"
    static let checkmarkCircleFill = "checkmark.circle.fill"
    static let xmarkCircleFill = "xmark.circle.fill"
    static let checkmark = "checkmark"
    static let arrowClockwise = "arrow.clockwise"
    static let euro = "eurosign"
    static let appGift = "app.gift.fill"
    static let addFill = "plus.app.fill"
    static let xmark = "xmark"
    static let xmarkAppFill = "xmark.app.fill"
    static let plus = "plus"
    static let trash = "trash"
    static let deleteLeft = "delete.left"
    static let keyboardFill = "keyboard.fill"
    static let keyboard = "keyboard"
    static let tag = "tag"
    static let questionMarkCircle = "questionmark.circle"
    static let ellipseCircle = "ellipsis.circle"
    static let giftFill = "gift.fill"
    static let infoCircle = "info.circle"
    static let plusCircleFill = "plus.circle.fill"
    static let eye = "eye"
    static let eyeSlash = "eye.slash"
    static let chevronLeftTwo = "chevron.left.2"
    static let chevronRightTwo = "chevron.right.2"
}
