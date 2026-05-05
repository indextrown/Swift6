//
//  1.swift
//  Swift5
//
//  Created by 김동현 on 2/8/25.
//

import FeedKit
import Foundation

//@main
//struct Main {
//    static func main() {
//        let feed = try await Feed(urlstring: "https://rss.blog.naver.com/starspr227.xml")
//        
//        switch feed {
//        case let .atom(feed):
//            print("atom")
//        case let .rss(feed):
//            print("rss")
//        case let .json(feed):
//            print("json")
//        }
//    }
//}


//@main
//struct Main {
//    static func main() async {
//        let url = URL(string: "https://rss.blog.naver.com/starspr227.xml")!
//        let parser = FeedParser(URL: url)
//
//        switch parser.parse() {
//        case .success(let feed):
//            switch feed {
//            case .atom(let atomFeed):
//                print("Atom Feed: \(atomFeed.title ?? "No Title")")
//            case .rss(let rssFeed):
//                print("RSS Feed: \(rssFeed.title ?? "No Title")")
//            case .json(let jsonFeed):
//                print("JSON Feed: \(jsonFeed.version ?? "No Version")")
//            }
//        case .failure(let error):
//            print("Parsing failed with error: \(error)")
//        }
//    }
//}



//
//@main
//struct Main {
//    static func main() {
//        
//        guard let url = URL(string: "https://rss.blog.naver.com/starspr227.xml") else {
//            print("Invalid URL")
//            return
//        }
//
//        DispatchQueue.global().async {
//            
//            let parser = FeedParser(URL: url) // FeedParser 초기화
//            let result = parser.parse() // 동기적으로 피드 파싱
//            
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let feed):
//                    switch feed {
//                    case let .rss(rssFeed):
//                        print("Detected Feed Type: RSS")
//                        print("Title: \(rssFeed.title ?? "제목 없음")")
//                    case let .atom(atomFeed):
//                        print("Detected Feed Type: Atom")
//                        print("Title: \(atomFeed.title ?? "제목 없음")")
//                    case let .json(jsonFeed):
//                        print("Detected Feed Type: JSON")
//                        print("Title: \(jsonFeed.title ?? "제목 없음")")
//                    }
//                case .failure(let error):
//                    print("Parsing error: \(error.localizedDescription)")
//                }
//            }
//        }
//        
//        // RunLoop를 사용해 비동기 작업 대기
//        RunLoop.main.run(until: Date(timeIntervalSinceNow: 5))
//    }
//}



@main
struct Main {
    static func main() {
        guard let url = URL(string: "https://rss.blog.naver.com/starspr227.xml") else {
            print("Invalid URL")
            return
        }

        DispatchQueue.global().async {
            let parser = FeedParser(URL: url) // FeedParser 초기화
            let result = parser.parse() // 동기적으로 피드 파싱

            DispatchQueue.main.async {
                switch result {
                case .success(let feed):
                    switch feed {
                    case let .rss(rssFeed):
                        print("✅ RSS 피드 감지됨")
                        print("🔹 블로그 제목: \(rssFeed.title ?? "제목 없음")\n")
                        
                        if let items = rssFeed.items {
                            for (index, item) in items.enumerated() {
                                print("📌 [\(index + 1)] \(item.title ?? "제목 없음")")
                                print("   URL: \(item.link ?? "링크 없음")")
                                print("   게시 날짜: \(item.pubDate ?? Date())\n")
                            }
                        } else {
                            print("❌ 게시물이 없습니다.")
                        }
                        
                    case let .atom(atomFeed):
                        print("✅ Atom 피드 감지됨")
                        print("🔹 블로그 제목: \(atomFeed.title ?? "제목 없음")\n")
                        
                        if let entries = atomFeed.entries {
                            for (index, entry) in entries.enumerated() {
                                print("📌 [\(index + 1)] \(entry.title ?? "제목 없음")")
                                print("   URL: \(entry.links?.first?.attributes?.href ?? "링크 없음")")
                                print("   게시 날짜: \(entry.published ?? Date())\n")
                            }
                        } else {
                            print("❌ 게시물이 없습니다.")
                        }
                        
                    case let .json(jsonFeed):
                        print("✅ JSON 피드 감지됨")
                        print("🔹 블로그 제목: \(jsonFeed.title ?? "제목 없음")\n")
                        
                        if let items = jsonFeed.items {
                            for (index, item) in items.enumerated() {
                                print("📌 [\(index + 1)] \(item.title ?? "제목 없음")")
                                print("   URL: \(item.url ?? "링크 없음")")
                                print("   게시 날짜: \(item.datePublished ?? Date())\n")
                            }
                        } else {
                            print("❌ 게시물이 없습니다.")
                        }
                    }
                    
                case .failure(let error):
                    print("❌ 피드 파싱 실패: \(error.localizedDescription)")
                }
            }
        }

        // RunLoop를 사용해 비동기 작업 대기
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 5))
    }
}
