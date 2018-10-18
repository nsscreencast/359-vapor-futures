import Routing
import Vapor

public func routes(_ router: Router) throws {
    
    router.get("future1") { req -> Future<String> in
        let promise: Promise<String> = req.eventLoop.newPromise()
        
        DispatchQueue.global().async {
            sleep(1)
            promise.succeed(result: "My work here is done.")
        }
        
        return promise.futureResult
    }

    router.get("future2") { req -> Future<String> in
        return randomNumber(on: req).map(to: String.self) { number in
            return String(number)
        }
    }
    
    router.get("future3") { req -> Future<[String]> in
    
        return randomNumber(on: req)
            .and(randomNumber(on: req))
            .map(to: [Int].self) { tuple in
                return [tuple.0, tuple.1]
            }.map(to: [String].self) { $0.map(String.init) }
    }
    
    func randomNumber(on worker: Worker) -> Future<Int> {
        return worker.future(Int.random(in: 1...100))
    }
}
