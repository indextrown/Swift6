//
//  DiaryCoreData.swift
//  Diary
//
//  Created by 김동현 on 5/7/26.
//

import Foundation
import CoreData

// 기능 명세
protocol DiaryCoreDataProtocol {
    func saveDiary(diary: DiaryItem) -> Result<Bool, CoreDataError>         // 다이어리 생성
    func deleteDiary(id: String) -> Result<Bool, CoreDataError>             // 다이어리 제거
    func getDiary(id: String) -> Result<DiaryItem, CoreDataError>           // 다이어리 조회
    func getDiaryList(query: String?) -> Result<[DiaryItem], CoreDataError> // 다이어리 목록 조회
    func editDiary(id: String, title: String, content: String) -> Result<Bool, CoreDataError> // 다이어리 수정
}

struct DiaryCoreData: DiaryCoreDataProtocol {
    
    private let viewContext: NSManagedObjectContext
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    func saveDiary(diary: DiaryItem) -> Result<Bool, CoreDataError> {
        
        guard let entity = NSEntityDescription.entity(
            forEntityName: "Diary",
            in: viewContext
        ) else {
            return .failure(.entityNotFound("Diary"))
        }
        
        let diaryObject = NSManagedObject(
            entity: entity,
            insertInto: viewContext
        )
        
        // 내가 생각한 방식
        /*
        let mirror = Mirror(reflecting: diary)
        for attribute in mirror.children {
            diaryObject.setValue(
                attribute.value,
                forKey: "\(attribute.label ?? "")")
        }
         */
        
        // 기존 방식 주석
        diaryObject.setValue(diary.id, forKey: "id")
        diaryObject.setValue(diary.title, forKey: "title")
        diaryObject.setValue(diary.content, forKey: "content")
        diaryObject.setValue(diary.createdDate, forKey: "createdDate")
        diaryObject.setValue(diary.editedDate, forKey: "editedDate")
        
        do {
            try viewContext.save()
            return .success(true)
        } catch {
            return .failure(.saveError(error.localizedDescription))
        }
    }
    
    func deleteDiary(id: String) -> Result<Bool, CoreDataError> {
        let fetchRequest: NSFetchRequest<Diary> = Diary.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let diaryList: [Diary] = try viewContext.fetch(fetchRequest)
            diaryList.forEach { viewContext.delete($0) }
            try viewContext.save()
            return .success(true)
        } catch {
            return .failure(.deleteError(error.localizedDescription))
        }
    }
    
    func getDiary(id: String) -> Result<DiaryItem, CoreDataError> {
        let fetchRequest: NSFetchRequest<Diary> = Diary.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            guard let diary = try viewContext.fetch(fetchRequest).first,
                  let id = diary.id,
                  let title = diary.title,
                  let content = diary.content,
                  let createdDate = diary.createdDate,
                  let editedDate = diary.editedDate
            else {
                return .failure(.readError("Get Diary Fail id: \(id)"))
            }
            
            return .success(
                DiaryItem(
                    id: id,
                    title: title,
                    content: content,
                    createdDate: createdDate,
                    editedDate: editedDate
                )
            )
        } catch {
            return .failure(.readError(error.localizedDescription))
        }
    }
    
    func getDiaryList(query: String?) -> Result<[DiaryItem], CoreDataError> {
        let fetchRequest: NSFetchRequest<Diary> = Diary.fetchRequest()
        if let query = query, !query.isEmpty {
            let predicate = NSPredicate(format: "title CONTAINS[c] %@", query)
            fetchRequest.predicate = predicate
        }
        
        do {
            let diaryList = try viewContext.fetch(fetchRequest)
            let diaryItemList: [DiaryItem] = diaryList.compactMap { diary in
                guard let id = diary.id,
                      let title = diary.title,
                      let content = diary.content,
                      let createdDate = diary.createdDate,
                      let editedDate = diary.editedDate
                else { return nil }
                
                return DiaryItem(
                    id: id,
                    title: title,
                    content: content,
                    createdDate: createdDate,
                    editedDate: editedDate
                )
            }
            return .success(diaryItemList)
        } catch {
            return .failure(.readError(error.localizedDescription))
        }
    }
    
    func editDiary(id: String, title: String, content: String) -> Result<Bool, CoreDataError> {
        let fetchRequest: NSFetchRequest<Diary> = Diary.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let diary = try viewContext.fetch(fetchRequest).first
            diary?.title = title
            diary?.content = content
            diary?.editedDate = Date.now
            try viewContext.save()
            return .success(true)
        } catch {
            return .failure(.editError(error.localizedDescription))
        }
    }
}
