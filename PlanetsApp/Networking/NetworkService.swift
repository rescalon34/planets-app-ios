//
//  NetworkService.swift
//  PlanetsApp
//
//  Created by rescalon on 18/5/24.
//

import Foundation
import Combine

/**
 A NetworkService to handle API calls using URLSession native API.
 */
class NetworkService {
    
    var cancellable = Set<AnyCancellable>()
    private let BASE_URL = "https://jsonplaceholder.typicode.com/"
    
    /**
     Generic function to fetch object data from the API,
     it will decode the object represented as T generic parameter.
     */
    
    /// - Parameter urlParam: The URL param to be appended to the BASE_URL.
    /// - Parameter onSuccess: A callback returned whenever the API call gives a success response.
    /// - Parameter onFailure: A callback returned whenever the API call gives a failure response.
    func getData<T: Codable>(
        urlParam : String,
        onSuccess: @escaping (_ decodedData: T?) -> (),
        onFailure: @escaping (_ errorMessage: String) -> ()
    ) {
        guard let url = URL(string: BASE_URL + urlParam) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let data = data,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
                onFailure(error?.localizedDescription ?? "ERROR!")
                return
            }
            
            guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                onFailure(error?.localizedDescription ?? "ERROR!")
                return
            }
            onSuccess(decodedData)
        }
        .resume()
    }
    
    /**
     Generic function to fetch list data of objects from the API,
     it will decode the list of objects represented as List<T> generic parameter.
     */
    
    /// - Parameter urlParam: The URL param to be appended to the BASE_URL.
    /// - Parameter onSuccess: A callback returned whenever the API call gives a success response.
    /// - Parameter onFailure: A callback returned whenever the API call gives a failure response.
    func getListData<T: Codable>(
        urlParam : String,
        onSuccess: @escaping (_ decodedData: [T]?) -> (),
        onFailure: @escaping (_ errorMessage: String) -> ()
    ) {
        guard let url = URL(string: BASE_URL + urlParam) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let data = data,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
                onFailure(error?.localizedDescription ?? "ERROR!")
                return
            }
            
            guard let decodedData = try? JSONDecoder().decode([T].self, from: data) else {
                onFailure(error?.localizedDescription ?? "ERROR!")
                return
            }
            onSuccess(decodedData)
        }
        .resume()
    }
    
    /**
     Generic function to fetch list data of objects from the API using combine.
     This function will also decode the object represented as T generic parameter.
     */
    
    // Combine steps.
    /*
     /// 1. Create the publisher.
     /// 2. Subscribe to publisher on background thread. (it's done automatically).
     /// 3. Receive on the main thread.
     /// 4. tryMap (check if the data is ok).
     /// 5. Decode the data to the given object.
     /// 6. Sink (Return the data into the UI).
     /// 7. Store (Cancell call if needed).
     */
    func getDataWithCombine<T: Codable>(
        urlParam: String,
        onSuccess: @escaping (T?) -> (),
        onFailure: @escaping (String) -> ()
    ) {
        guard let url = URL(string: BASE_URL + urlParam) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap(handleApiOutputResponse(output:))
            .decode(type: T.self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .failure(let error):
                    onFailure(error.localizedDescription)
                case .finished: ()
                }
            } receiveValue: { data in
                onSuccess(data)
            }
            .store(in: &cancellable)
    }
    
    /**
     Generic function to fetch list data of objects from the API using combine.
     This function will decode the list of objects represented as List<T> generic parameter.
     */
    func getListDataWithCombine<T: Codable>(
        urlParam: String,
        onSuccess: @escaping ([T]?) -> (),
        onFailure: @escaping (String) -> ()
    ) {
        guard let url = URL(string: BASE_URL + urlParam) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap(handleApiOutputResponse(output:))
            .decode(type: [T].self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .failure(let error):
                    onFailure(error.localizedDescription)
                case .finished: ()
                }
            } receiveValue: { data in
                onSuccess(data)
            }
            .store(in: &cancellable)
    }
    
    /*
     Helper function to handle API Responses.
     */
    func handleApiOutputResponse(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        return output.data
    }
}
