//
//  RemoteLocationsServiceTests.swift
//  LocationsTests
//
//  Created by Mohammed Alwaili on 03/08/2024.
//

import XCTest

struct Coordinates {
    let latitude: Double
    let longitude: Double
}

struct Location: Decodable {
    let name: String
    let coordinates: Coordinates
    
    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "long"
        case coordinates
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? "Unknown location"
        self.coordinates = Coordinates(latitude: latitude, longitude: longitude)
    }
}

protocol LocationsService {
    func fetch() async throws -> [Location]
}

enum RemoteLocationsServiceError: Error {
    case invalidURL
}

struct GitHubAPI {
    static let urlString = "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json"
}

final class RemoteLocationsService: LocationsService {
    
    struct Response: Decodable {
        let locations: [Location]
    }
    
    private let urlSession: URLSession
    private let urlString: String
    
    init(urlSession: URLSession,
         urlString: String) {
        self.urlSession = urlSession
        self.urlString = urlString
    }
    
    func fetch() async throws -> [Location] {
        guard let url = URL(string: urlString) else {
            throw RemoteLocationsServiceError.invalidURL
        }
        let (data, _) = try await urlSession.data(from: url)
        let result = try JSONDecoder().decode(Response.self, from: data)
        
        return result.locations
    }
}

final class RemoteLocationsServiceTests: XCTestCase {
    
    override func setUp() async throws {
        try await super.setUp()
        URLProtocolMock.error = nil
        URLProtocolMock.requestHandler = nil
    }
    
    func test_fetch_throwsInvalidURL() async {
        let sut = makeSUT(urlString: "This is not a URL because it doesn't have a scheme like http:// or https://")
        
        do {
            _ = try await sut.fetch()
            XCTFail("Expected fetch to fail with: \(RemoteLocationsServiceError.invalidURL)")
        } catch {
            guard let serviceError = error as? RemoteLocationsServiceError,
                  serviceError == .invalidURL else {
                XCTFail()
                return
            }
        }
    }
    
    func test_fetch_failsOnNetworkError() async {
        URLProtocolMock.error = NSError(domain: "RemoteLocationsServiceTests", code: 0)
        
        let sut = makeSUT()
        
        do {
            _ = try await sut.fetch()
            XCTFail("Expected fetch to fail")
        } catch {
            let nsError = error as NSError
            XCTAssertEqual(nsError.code, 0)
            XCTAssertEqual(nsError.domain, "RemoteLocationsServiceTests")
        }
    }
    
    func test_fetch_failsOnDecodingErrorWhenMissingTheLongitude() async throws {
        let json = """
        {
            "locations": [
                {
                    "name": "Amsterdam",
                    "lat": 52.3547498,
                    "long": ""
                }
            ]
        }
        """
        do {
            _ = try await performFetch(with: json)
            XCTFail("Expected fetch to fail with DecodingError")
        } catch {
            guard error is DecodingError else {
                XCTFail()
                return
            }
        }
    }
    
    func test_fetch_returnsMappedLocations() async throws {
        let json = """
        {
            "locations": [
                {
                    "name": "Amsterdam",
                    "lat": 52.3547498,
                    "long": 4.8339215
                },
                {
                    "lat": 40.4380638,
                    "long": -3.7495758
                }
            ]
        }
        """
        
        let locations = try await performFetch(with: json)
        XCTAssertEqual(locations.count, 2)
        
        XCTAssertEqual(locations[0].name, "Amsterdam")
        XCTAssertEqual(locations[0].coordinates.latitude, 52.3547498)
        XCTAssertEqual(locations[0].coordinates.longitude, 4.8339215)
        
        XCTAssertEqual(locations[1].name, "Unknown location")
        XCTAssertEqual(locations[1].coordinates.latitude, 40.4380638)
        XCTAssertEqual(locations[1].coordinates.longitude, -3.7495758)
    }
    
    func performFetch(
        with json: String,
        file: StaticString = #file,
        lint: UInt = #line
    ) async throws -> [Location] {
        let responseData = try XCTUnwrap(json.data(using: .utf8))
        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(
                url: URL(string: GitHubAPI.urlString)!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            return (response, responseData)
        }
        
        let sut = makeSUT()
        
        return try await sut.fetch()
    }
}

private extension RemoteLocationsServiceTests {
    
    func makeSUT(
        urlString: String = GitHubAPI.urlString,
        file: StaticString = #file,
        line: UInt = #line
    ) -> LocationsService {
        let sut = RemoteLocationsService(
            urlSession: makeURLSessionMock(),
            urlString: urlString
        )
        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut, file: file, line: line)
        }
        return sut
    }
    
    func makeURLSessionMock() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: configuration)
    }
}
