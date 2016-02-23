//
//  Errors.swift
//  Pixapals
//
//  Created by DARI on 2/23/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import Foundation
enum Errors <Title, Error: ErrorType> {
    case Success(Title)
    case Failure(Error)
}
