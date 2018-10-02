import Foundation
import PromiseKit

public enum ResponseStatusError: Error {
    case Canceled
}

/// Extension of the standard HTTP with Promises.
public extension HTTP {
    
    func executeRequestAsync<T>(request: Request) -> Promise<Response<T>> {
        return Promise { seal in
            executeRequest(request: request,
                           completionHandler: { (result: Result<Response<T>, Error?>) in
                switch result {
                case .Failure(let error):
                    if error!.isCancelled {
                        seal.reject(ResponseStatusError.Canceled)
                    } else {
                        seal.reject(error!)
                    }
                case .Success(let data):
                    seal.fulfill(data)
                }
            })
        }
    }
    
}
