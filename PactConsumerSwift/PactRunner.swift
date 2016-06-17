import Foundation

@objc public class PactRunner : NSObject {
  private let pact: Pact
  private let mockServer: MockServer
  private var interactions: [Interaction] = []
  
  private static let defaultPort = 1234
  public var baseUrl: String {
    get {
      return "http://localhost:\(PactRunner.defaultPort)"
    }
  }

  public init(provider: String, consumer: String, mockServer: MockServer) {
    self.pact = Pact(provider: provider, consumer: consumer)
    self.mockServer = mockServer
  }

  @objc(initWithProvider: consumer: )
  public convenience init(provider: String, consumer: String) {
    self.init(provider: provider, consumer: consumer, mockServer: MockServer(port: PactRunner.defaultPort))
  }

  public func given(providerState: String) -> Interaction {
    let interaction = Interaction().given(providerState)
    interactions.append(interaction)
    return interaction
  }

  @objc(uponReceiving:)
  public func uponReceiving(description: String) -> Interaction {
    let interaction = Interaction().uponReceiving(description)
    interactions.append(interaction)
    return interaction
  }

  @objc public func run(testFunction: (testComplete: () -> Void) -> Void) -> Void {
    pact.withInteractions(interactions)
    mockServer.withPact(pact)
    testFunction{ () in
      if(!self.mockServer.matched()) {
        print(self.mockServer.mismatches())
        fatalError("Fatal error: \(self.mockServer.mismatches())")
      }
      self.mockServer.cleanup()
    }
  }
}
