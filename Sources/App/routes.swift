import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
//    router.get("hello") { req in
//        return "Hello, world!"
//    }
    
    router.get("upcase", String.parameter) { req in
        return try req.parameters.next(String.self).uppercased()
    }
    
    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}


