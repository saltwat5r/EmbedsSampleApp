//
//  ViewsFactory.swift
//  EmbedsSampleApp
//
//

import UIKit

class ViewsFactory {
    static func makeScrollView() -> UIScrollView {
        let sv = UIScrollView(frame: .zero)
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }

    static func makeTextLabel() -> UILabel {
        let lbl = UILabel(frame: .zero)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = Self.randomText()
        return lbl
    }

    private static func randomText() -> String {
        let strings = [
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec hendrerit vulputate vestibulum. Nam ut risus eu odio volutpat mollis. Sed orci sem, fringilla vel imperdiet sit amet, tincidunt nec ligula. Suspendisse malesuada nibh nec fringilla eleifend. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse quis est arcu. Integer leo libero, molestie in facilisis et, pretium sed lacus. Quisque in magna nisi.",
            "Nullam bibendum leo a lorem pellentesque malesuada. Sed ut bibendum augue. Pellentesque at mi quis dui pulvinar maximus. Duis ut accumsan lectus. Vivamus venenatis varius quam non porttitor. Praesent faucibus mi non arcu pellentesque venenatis. Suspendisse tincidunt sem vitae semper vulputate. Duis sodales gravida dui, sit amet eleifend libero aliquet nec. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.",
            "Nulla nec dignissim orci. Nam sit amet vulputate ipsum, varius tempus nisl. Aliquam porta consectetur risus vel imperdiet. Maecenas vestibulum ante ut eros ornare tempor. Praesent pellentesque faucibus erat, sed cursus erat molestie non. Curabitur placerat enim sed faucibus molestie. Vestibulum mi felis, viverra laoreet urna vel, tincidunt ultricies justo."
        ]
        let random = Int.random(in: Range.init(uncheckedBounds: (0, strings.count - 1)))
        return strings[random]
    }
}
