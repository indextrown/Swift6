//
//  2.swift
//  Swift5
//
//  Created by 김동현 on 2/9/25.
//

import Foundation
import FeedKit

struct Post {
    let title: String       // 제목
    let content: String     // 글
    let url: String         // 링크
    let pubDate: Date       // 날짜
}

@main
struct Main {
    static func main() {
        let urlString = "https://rss.blog.naver.com/starspr227.xml"
        
        fe₩tchPosts(urlString: urlString) { posts in
            displayPosts(posts)
        }
        
        // RunLoop를 사용해 비동기 작업 대기
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 5))
    }
}


/// 📌 RSS, Atom, JSON 피드를 가져오는 함수
func fetchPosts(urlString: String, completion: @escaping (([Post]) -> Void)) {
    DispatchQueue.global().async {
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL: \(urlString)")
            completion([])
            return
        }
        
        let parser = FeedParser(URL: url)
        let result = parser.parse()
        
        DispatchQueue.main.async {
            let posts = handleFeedResult(result)
            completion(posts)
        }
    }
}

/// 📌 피드 결과를 `Post` 배열로 변환하는 함수
func handleFeedResult(_ result: Result<Feed, ParserError>) -> [Post] {
    guard case .success(let feed) = result else {
        if case .failure(let error) = result {
            print("❌ 피드 파싱 실패: \(error.localizedDescription)")
        }
        return []
    }

    switch feed {
    case let .rss(rssFeed):
        // print("✅ RSS 피드 감지됨")
        // print("🔹 블로그 제목: \(rssFeed.title ?? "제목 없음")\n")

        guard let items = rssFeed.items, !items.isEmpty else {
            print("❌ 게시물이 없습니다.")
            return []
        }

        return items.compactMap { item in
            guard let title = item.title, let link = item.link else { return nil }
            return Post(
                title: title,
                content: item.description ?? "내용 없음",
                url: link,
                pubDate: item.pubDate ?? Date()
            )
        }

    case let .atom(atomFeed):
        print("✅ Atom 피드 감지됨")
        print("🔹 블로그 제목: \(atomFeed.title ?? "제목 없음")\n")

        guard let entries = atomFeed.entries, !entries.isEmpty else {
            print("❌ 게시물이 없습니다.")
            return []
        }

        return entries.compactMap { entry in
            guard let title = entry.title, let link = entry.links?.first?.attributes?.href else { return nil }
            return Post(
                title: title,
                content: entry.summary?.value ?? "내용 없음",
                url: link,
                pubDate: entry.published ?? Date()
            )
        }

    case let .json(jsonFeed):
        print("✅ JSON 피드 감지됨")
        print("🔹 블로그 제목: \(jsonFeed.title ?? "제목 없음")\n")

        guard let items = jsonFeed.items, !items.isEmpty else {
            print("❌ 게시물이 없습니다.")
            return []
        }

        return items.compactMap { item in
            guard let title = item.title, let link = item.url else { return nil }
            return Post(
                title: title,
                content: item.contentText ?? "내용 없음",
                url: link,
                pubDate: item.datePublished ?? Date()
            )
        }
    }
}

/// 📌 `Post` 배열을 출력하는 함수
func displayPosts(_ posts: [Post]) {
    guard !posts.isEmpty else {
        print("❌ 게시물이 없습니다.")
        return
    }

    for (index, post) in posts.enumerated() {
        print("📌 [\(index + 1)] \(post.title)")
        print("   URL: \(post.url)")
        print("   게시 날짜: \(formatDate(post.pubDate))")
        print("   내용: \(post.content.prefix(100))...\n") // 긴 경우 앞부분만 출력
    }
}

/// 📌 날짜 포맷 변환 함수
func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd" // 포맷: YYYY-MM-DD HH:mm:ss
    formatter.locale = Locale(identifier: "ko_KR") // 한국어 로캘 설정
    return formatter.string(from: date)
}
