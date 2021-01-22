//
//  Instagram.swift
//  EmbedsSampleApp
//
//

import Foundation
import CoreGraphics

struct Instagram: Codable {
    let authorName: String
    let thumbnailUrl : String
    let html : String
    let width: CGFloat
    let thumbnailHeight: CGFloat

    private enum CodingKeys: String, CodingKey {
        case authorName = "author_name"
        case thumbnailUrl = "thumbnail_url"
        case html
        case width
        case thumbnailHeight = "thumbnail_height"
    }
}
