//
// Created by CC on 2019-03-17.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation

func buildHeadingStr(heading: Int) -> String {
    var result = ""
    switch (heading) {
    case 1:
        result = "Parallel"
        break
    case 2:
        result = "Head-on"
        break
    case 3:
        result = "T Advantage"
        break
    case 4:
        result = "T Disadvantage"
        break
    default:
        result = "Engagement Form Unknown"
        break
    }
    return result
}

func buildAirCommandStr(air: Int) -> String {
    var result = ""
    switch (air) {
    case 0:
        result = "Air Parity"
        break
    case 1:
        result = "Air Supremacy"
        break
    case 2:
        result = "Air Superiority"
        break
    case 3:
        result = "Air Denial"
        break
    case 4:
        result = "Air Incapability"
        break
    default:
        result = "Air State Unknown"
        break
    }
    return result
}
