import Vapor

struct Data: Content {
    var name: String?
    var value: String?
}

var database = [Data]()

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
//    router.get("hello") { req in
//        return "Hello, world!"
//    }
    
    router.get("upcase", String.parameter) { req in
        return try req.parameters.next(String.self).uppercased()
    }
    
    router.post("store") { req -> Future<HTTPStatus> in
        return try req.content.decode(Data.self).map(to: HTTPStatus.self) { data in
            database.append(data)
            return .ok
        }
    }
    
    router.get("lookup", String.parameter) { req -> String in
        let name = try req.parameters.next(String.self)
        var value: String?
        for data in database {
            if name == data.name {
                value = data.value
            }
        }
        guard value != nil else { return "No value" }
        return value!
    }
    
    router.get("retrieve") { req in
        return database
    }
    
    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}


