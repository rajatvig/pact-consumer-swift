import Foundation
import PactMockServer

public class MockServer {
  private var port: Int32 = -1
  
  public init(port: Int) {
    self.port = Int32(port)
  }

  public func withPact(pact: Pact) {      
      let jsonData = try! NSJSONSerialization.dataWithJSONObject(pact.payload(), options: NSJSONWritingOptions.PrettyPrinted)
      
      let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
    
      print(jsonString)
      port = PactMockServer.create_mock_server(jsonString, port)
    
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
