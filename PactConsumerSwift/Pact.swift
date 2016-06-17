import Foundation

public class Pact {
  private let provider: String
  private let consumer: String
  private var interactions: [Interaction] = []
  
  public init(provider: String, consumer: String) {
    self.provider = provider
    self.consumer = consumer 
  }
  
  public func withInteractions(interactions: [Interaction]) {
    self.interactions = interactions
  }

  public func payload() -> [String: AnyObject] {
    return [ "provider": provider, 
      "consumer": consumer,
      "interactions" : interactions.map({ $0.payload() }),
      "metadata": [ "pact-specification": [ "version": "1.0.0"] ]]
  }

  //public func asJson() -> String {
  //  do {
  //    let jsonData = try NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions.PrettyPrinted)
  //    // here "jsonData" is the dictionary encoded in JSON data
  //  } catch let error as NSError {
  //    print(error)
  //  }
  //  return "Blah"
  //}
}
