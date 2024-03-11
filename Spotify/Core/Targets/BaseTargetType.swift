//
//  BaseTargetType.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 28.02.2024.
//

import Foundation
import Moya

protocol BaseTargetType: TargetType { }

extension BaseTargetType {
	var baseURL: URL {
		return URL(string: GlobalConstants.baseURL)!
	}
	
	var path: String {
		return ""
	}
	
	var method: Moya.Method {
		return .get
	}
	
	var task: Moya.Task {
		return .requestPlain
	}
	
	var headers: [String : String]? {
		return nil
	}
}


