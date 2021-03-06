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
        let path = "https://api.parse.com/1/classes/Food"
        guard let url = NSURL(string: path) else {
            return
        }

        let task = session.dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            var result: FoodListResponse

            // We have to handle a few cases here:

            if let error = error {
                // 1. Something went wrong with the request. We pass along the error.
                result = FoodListResponse.Failure(error: error)
            } else if let data = data {
                // We got back some data. We'll attempt to parse it as JSON.
                do {
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary

                    // 2. We were able to parse the data. We need to map the JSON into Food objects.
                    var returnedFoods = [Food]()

                    if let foodEntries = jsonResult?["results"] as? NSArray {
                        for entry in foodEntries {
                            let foodEntry = entry as? NSDictionary
                            guard let identifier = foodEntry?["objectId"] as? String else { continue }
                            guard let name = foodEntry?["name"] as? String else { continue }
                            guard let isHealthy = foodEntry?["isHealthy"] as? Bool else { continue }
                            returnedFoods.append(Food(identifier: identifier, name: name, isHealthy: isHealthy))
                        }
                    }

                    result = FoodListResponse.Success(foods: returnedFoods)
                } catch let error as NSError {
                    // 3. Got back something that wasn't valid JSON.
                    result = FoodListResponse.Failure(error: error)
                }
            } else {
                // 4. Successful response, but no data returned... we'll treat this as an empty food list.
                result = FoodListResponse.Success(foods: [Food]())
            }

            // Call our completion handler on the main queue
            dispatch_async(dispatch_get_main_queue()) {
                completion(result)
            }
        }
        task.resume()
    }

    func createFoodWithName(name: String, isHealthy: Bool, completion: ((FoodCreatedResponse) -> Void)) {
        let path = "https://api.parse.com/1/classes/Food";
        guard let url = NSURL(string: path) else {
            return
        }

        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"

        do {
            let dict: [String: AnyObject] = [
                "name": name,
                "isHealthy": isHealthy
            ]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: [])
            let task = session.uploadTaskWithRequest(request, fromData: jsonData) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
                var result: FoodCreatedResponse
                if let data = data {
                    do {
                        let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary
                        if let identifier = jsonResult?["objectId"] as? String {
                            let food = Food(identifier: identifier, name: name, isHealthy: isHealthy)
                            result = FoodCreatedResponse.Success(food: food)
                        } else {
                            result = FoodCreatedResponse.Failure(error: FoodServiceError.UnexpectedAPIResponse)
                        }
                    } catch let error as NSError {
                        result = FoodCreatedResponse.Failure(error: error)
                    }
                } else {
                    result = FoodCreatedResponse.Failure(error: FoodServiceError.UnexpectedAPIResponse)
                }

                // Call our completion handler on the main queue
                dispatch_async(dispatch_get_main_queue()) {
                    completion(result)
                }
            }
            task.resume()
        } catch let error as NSError {
            completion(FoodCreatedResponse.Failure(error: error))
        }
    }
}
