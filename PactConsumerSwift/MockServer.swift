import Foundation
import PactMockServer

import SwiftyJSON

public class MockServer {
  private var port: Int32 = -1

  public init(port: Int) {
    self.port = Int32(port)
  }

  public func withPact(pact: Pact) {
    let json = JSON(pact.payload())
    port = PactMockServer.create_mock_server(json.rawString()!, port)
    print("Server started on port \(port)")
  }

  public func mismatches() -> String? {
    return String.fromCString(PactMockServer.mock_server_mismatches(port))
  }

  public func matched() -> Bool {
    return PactMockServer.mock_server_matched(port)
  }

  public func cleanup() {
    PactMockServer.cleanup_mock_server(port)
  }

}
