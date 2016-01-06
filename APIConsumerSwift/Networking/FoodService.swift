//
//  FoodService.swift
//  APIConsumerSwift
//
//  Created by Andrew Dolce on 1/5/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

import Foundation

enum FoodServiceError: ErrorType {
    case UnexpectedAPIResponse
}

enum FoodListResponse {
    case Success(foods: [Food])
    case Failure(error: ErrorType)
}

enum FoodCreatedResponse {
    case Success(food: Food)
    case Failure(error: ErrorType)
}

class FoodService {

    static let sharedService = FoodService()

    private let session: NSURLSession = {
        let sessionConfig: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.HTTPAdditionalHeaders = [
            "Accept": "application/json",
            "X-Parse-Application-Id": "Zdcy5fLF91cWtsBbksRcQw67VWw67U9UiQ9eFAsV",
            "X-Parse-REST-API-Key": "7xvJvKtg6cVEV6isQrvxruDS7HZJz4QU7XI8QgsF"
        ]

        let session = NSURLSession(configuration: sessionConfig)
        return session
    }()

    func getFoodsWithCompletion(completion: ((FoodListResponse) -> Void)) {
        // TODO: Make a GET request to fetch the foods from Parse.
    }

    func createFoodWithName(name: String, isHealthy: Bool, completion: ((FoodCreatedResponse) -> Void)) {
        // TODO: Make a POST request to create a new food.
    }
}
