//
//  AnimationUtils.swift
//  memory-cards-game
//
//  Created by Kristīne Kazakēviča on 05/05/2020.
//  Copyright © 2020 Kristīne Kazakēviča. All rights reserved.
//

import RxCocoa
import RxAnimated

extension AnimatedSink where Base: UIImageView {
    public var backgroundColor: Binder<UIColor> {
        return Binder(self.base) { view, backgroundColor in
            self.type.animate(view: view, binding: {
                view.backgroundColor = backgroundColor
            })
        }
    }
}
