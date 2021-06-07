//
//  ITunesService.swift
//  Podcast
//
//  Created by liuliu on 2021/5/27.
//

import Combine
import FeedKit
import Moya
import Tiercel

enum ITunes {
    case search(term: String, page: Int)
    case lookUp(podcastID: String)
    case top(limit: Int, country: ITunesCountry)
    case episode(url: String)
}

enum ITunesCountry: String {
    case us, cn
}

extension ITunes: TargetType {
    var baseURL: URL {
        switch self {
        case .search:
            return URL(string: "https://itunes.apple.com/search")!
        case .lookUp:
            return URL(string: "https://itunes.apple.com/lookup")!
        case .top(var limit, let country):
            limit = max(1, limit)
            let string = "https://rss.itunes.apple.com/api/v1/\(country)/podcasts/top-podcasts/all/\(limit)/explicit.json"
            return URL(string: string)!
        case let .episode(url):
            return URL(string: url)!
        }
    }

    var path: String {
        return ""
    }

    var parameters: [String: Any] {
        var param = [String: Any]()
        switch self {
        case let .search(term, page):
            param["media"] = "podcast"
            param["term"] = term
            param["limit"] = Config.limitValue
            if page > 1 {
                let offset = (page - 1) * Config.limitValue
                param["offset"] = offset
            }
        case let .lookUp(podcastID):
            param["id"] = podcastID
            param["entity"] = "podcast"
        default:
            break
        }
        return param
    }

    var method: Moya.Method {
        return .get
    }

    var task: Moya.Task {
        switch self {
        default:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String: String]? {
        return nil
    }
}

class ITunesService {
    static let share = ITunesService()

    private var itunes: MoyaProvider<ITunes>

    init(itunes: MoyaProvider<ITunes> = MoyaProvider<ITunes>()) {
        self.itunes = itunes
    }
    
    var downloadManager: SessionManager = {
        var configuration = SessionConfiguration()
        let manager = SessionManager("default", configuration: configuration)
        return manager
    }()

    func search(_ text: String, page: Int = 1) -> AnyPublisher<[Podcast], NetError> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return itunes
            .requestPublisher(.search(term: text, page: page))
            .map([Podcast].self, atKeyPath: "results")
            .mapNetError()
    }

    func lookUp(_ podcastID: String) -> AnyPublisher<Podcast, NetError> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return itunes
            .requestPublisher(.lookUp(podcastID: podcastID))
            .map([Podcast].self, atKeyPath: "results")
            .tryMap({ results -> Podcast in
                if let result = results.first {
                    return result
                } else {
                    throw NetError.tip("No results")
                }
            })
            .mapNetError()
    }

    func topPodcasts(limit: Int, country: ITunesCountry) -> AnyPublisher<[Podcast], NetError> {
        let request = itunes
            .requestPublisher(.top(limit: limit, country: country))
            .map([Podcast].self, atKeyPath: "feed.results")
            .mapNetError()
        return request
    }

    func fetchEpisodes(feedUrl: String) -> (AnyPublisher<([Episode], String?), NetError>, AnyPublisher<Double, NetError>) {
        let request = itunes.requestWithProgressPublisher(.episode(url: feedUrl))
        let progress = request.filterProgress().removeDuplicates().mapNetError()
        let data = request
            .filterCompleted()
            .tryMap { response -> ([Episode], String?) in
                let result = FeedParser(data: response.data).parse()
                switch result {
                case let .success(f):
                    if let feed = f.rssFeed {
                        log.debug("fetchEpisodes \(feedUrl)")
                        log.debug(feed.iTunes?.iTunesSummary ?? "")
                        return (feed.toEpisodes(), feed.iTunes?.iTunesSummary)
                    } else {
                        throw NetError.tip("No Feed")
                    }
                case let .failure(error):
                    throw error
                }
            }
            .mapNetError()
        return (data, progress)
    }
}
