//
//  RouterEntryPoint.swift
//  Healthio
//
//  Created by Marek Baláž on 25/10/2024.
//

import Foundation
import SwiftUI
import Combine

private class RouterEntryPointViewModel<T>: ObservableObject {
    
	@Published var isPresenting: Bool = false
    
	@Published var data: T? = nil
	
	private let entry: RouteEntry<T>
    
	private let router: Router
	
	private var cancellables: Set<AnyCancellable> = []
		
	init(entry: RouteEntry<T>, router: Router) {
		self.entry = entry
		self.router = router
		
		router.$path
			.sink { [weak self] path in
				guard let item = path.first(where: { $0.id.getName() == self?.entry.name }) else {
					self?.isPresenting = false
					return
				}
				guard let typedData = item.data as? T else {
					assertionFailure("Data type corruption")
					return
				}
				self?.data = typedData
				self?.isPresenting = true
			}
			.store(in: &cancellables)
	}

}

struct RouterEntryPoint<T, DestinationContent: View>: ViewModifier {
    
	@StateObject private var model: RouterEntryPointViewModel<T>
    
	@ViewBuilder var routeDestination: (T) -> DestinationContent
		
	init(router: Router, entry: RouteEntry<T>, @ViewBuilder content: @escaping (T) -> DestinationContent) {
		self.routeDestination = content
		self._model = StateObject(wrappedValue: RouterEntryPointViewModel(entry: entry, router: router))
	}

	func body(content: Content) -> some View {
		content.fullScreenCover(isPresented: $model.isPresenting) {
			if let data = model.data {
				routeDestination(data)
			}
		}
	}
}

extension RouterEntryPoint where T == Void {
    
	init(router: Router, entry: RouteEntry<T>, @ViewBuilder content: @escaping () -> DestinationContent) {
		self.routeDestination = { _ in content() }
		self._model = StateObject(wrappedValue: RouterEntryPointViewModel(entry: entry, router: router))
	}
}

extension View {
    
	func registerRouteEntry(_ entry: RouteEntry<Void>, router: Router, @ViewBuilder content: @escaping () -> some View) -> some View {
        modifier(RouterEntryPoint(router: router, entry: entry, content: content))
	}
	
	func registerRouteEntry<T>(_ entry: RouteEntry<T>, router: Router, @ViewBuilder content: @escaping (T) -> some View) -> some View {
        modifier(RouterEntryPoint(router: router, entry: entry, content: content))
	}
}
