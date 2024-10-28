//
//  Router.swift
//  Healthio
//
//  Created by Marek Baláž on 25/10/2024.
//

import SwiftUI
import Combine

struct RoutePath {
	
}

struct RouterPathEntry {
    
	var id: AnyRouteEntry
    
	var data: Any
}

class RouterPathModifier {
    
	private(set) var path: [RouterPathEntry]
		
	init(path: [RouterPathEntry]) {
		self.path = path
	}
	
	func clear() {
		path = []
	}
	
	func add<T>(_ path: RouteEntry<T>, data: T) {
        self.path.append(RouterPathEntry(id: AnyRouteEntry(item: path), data: data))
	}
	
	func add<T>(_ path: RouteEntry<T>) {
		self.path.append(RouterPathEntry(id: AnyRouteEntry(item: path), data: ()))
	}
	
	func removeLast() {
		if path.count > 0 {
			path.removeLast()
		}
	}
	
	func removeTo<T>(to: RouteEntry<T>) {
		if let index = path.lastIndex(where: { $0.id.getName() == to.name }) {
			path = Array(path.prefix(Int(index)))
		}
	}
}

class Router: ObservableObject {
    
	@Published private(set) var path: [RouterPathEntry] = []
		
	func popToRoot() {
		path = []
	}
	
	func pop() {
		if path.count > 0 {
			path.removeLast()
		}
	}
	
	func pop<T>(to: RouteEntry<T>) {
		if let index = path.lastIndex(where: { $0.id.getName() == to.name }) {
			path = Array(path.prefix(Int(index)))
		}
	}
	
	func present<T>(_ path: RouteEntry<T>, data: T) {
		self.path.append(RouterPathEntry(id: AnyRouteEntry(item: path), data: data))
	}
	
	func present<T>(_ path: RouteEntry<T>) {
		self.path.append(RouterPathEntry(id: AnyRouteEntry(item: path), data: ()))
	}

	func changeRoute(transform: (RouterPathModifier) -> Void) {
		let modifier = RouterPathModifier(path: self.path)
		transform(modifier)
		self.path = modifier.path
	}
}


struct RouterView<T: View>: View {
    
	@ViewBuilder var content: T
	
    var body: some View {
        content
			.environmentObject(Router())
    }
}


struct Router_Previews: PreviewProvider {
    
    static var previews: some View {
		RouterView {
			Text("RootView")
		}
    }
}
