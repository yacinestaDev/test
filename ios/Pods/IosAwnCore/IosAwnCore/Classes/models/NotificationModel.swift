//
//  NotificationModel.swift
//  awesome_notifications
//
//  Created by Rafael Setragni on 05/09/20.
//

import Foundation

public class NotificationModel : AbstractModel {
    
    private static let TAG = "NotificationModel"
    
    public var content:NotificationContentModel?
    public var actionButtons:[NotificationButtonModel]?
    public var schedule:NotificationScheduleModel?
    public var localizations: [String:NotificationLocalizationModel]?
    public var importance:NotificationImportance?
    
    public var nextValidDate:RealDateTime?
    
    public init(){}
    
    public convenience init?(fromMap arguments: [String : Any?]?){
        if arguments?.isEmpty ?? true { return nil }
        
        do {
            self.init()
            self.content = extractNotificationContent(Definitions.NOTIFICATION_MODEL_CONTENT, arguments)
            
            if(self.content == nil){ return nil }
            
            self.schedule = try extractNotificationSchedule(Definitions.NOTIFICATION_MODEL_SCHEDULE, arguments)
            self.actionButtons = extractNotificationButtons(Definitions.NOTIFICATION_MODEL_BUTTONS, arguments)
            self.localizations = extractLocalizations(Definitions.NOTIFICATION_MODEL_LOCALIZATIONS, arguments)
        }
        catch {
            Logger.shared.e("NotificationModel", error.localizedDescription)
            return nil
        }
    }
    
    public func toMap() -> [String : Any?] {
        var mapData:[String: Any?] = [:]
        
        mapData[Definitions.NOTIFICATION_MODEL_CONTENT] = self.content!.toMap()
        if(self.schedule != nil){
            mapData[Definitions.NOTIFICATION_MODEL_SCHEDULE] = self.schedule!.toMap()
        }
        
        if let actionButtons = self.actionButtons {
            let listButtons = actionButtons.compactMap { $0.toMap() }
            mapData[Definitions.NOTIFICATION_MODEL_BUTTONS] = listButtons
        }
        
        if let localizations = self.localizations {
            let localizationsData = Dictionary(uniqueKeysWithValues: localizations.map { key, value in
                (key, value.toMap())
            })
            mapData[Definitions.NOTIFICATION_MODEL_LOCALIZATIONS] = localizationsData
        }
        
        return mapData
    }
    
    func extractNotificationContent(_ reference:String, _ arguments:[String:Any?]?) -> NotificationContentModel? {
        guard let map:[String:Any?] = arguments?[reference] as? [String:Any?] else { return nil }
        if(map.isEmpty){ return nil }
        return NotificationContentModel(fromMap: map)
    }
    
    func extractNotificationSchedule(_ reference:String, _ arguments:[String:Any?]?) throws -> NotificationScheduleModel? {
        guard let map:[String:Any?] = arguments?[reference] as? [String:Any?] else { return nil }
        if(map.isEmpty){ return nil }
        
        if(
            map[Definitions.NOTIFICATION_CRONTAB_EXPRESSION] != nil ||
            map[Definitions.NOTIFICATION_PRECISE_SCHEDULES] != nil ||
            map[Definitions.NOTIFICATION_INITIAL_DATE_TIME] != nil ||
            map[Definitions.NOTIFICATION_EXPIRATION_DATE_TIME] != nil
        ){
            throw ExceptionFactory
                    .shared
                    .createNewAwesomeException(
                        className: NotificationModel.TAG,
                        code: ExceptionCode.CODE_INVALID_ARGUMENTS,
                        message: "Crontab schedules are not available for iOS",
                        detailedCode: ExceptionCode.DETAILED_INVALID_ARGUMENTS+".crontab.ios")
        }
        
        if map["interval"] != nil {
            return NotificationIntervalModel(fromMap: map)
        }
        else {
            return NotificationCalendarModel(fromMap: map)
        }
    }
    
    func extractNotificationButtons(_ reference:String, _ arguments:[String:Any?]?) -> [NotificationButtonModel]? {
        guard let actionButtonsData:[[String:Any?]] = arguments?[reference] as? [[String:Any?]] else { return nil }
        if(actionButtonsData.isEmpty){ return nil }
        
        var actionButtons:[NotificationButtonModel] = []
        
        for buttonData in actionButtonsData {
            guard let button:NotificationButtonModel = NotificationButtonModel(fromMap: buttonData)
            else { continue }
            actionButtons.append(button)
        }
        
        return actionButtons
    }
    
    func extractLocalizations(_ reference:String, _ arguments:[String:Any?]?) -> [String:NotificationLocalizationModel]? {
        guard let localizationsData:[String:[String:Any?]] = arguments?[reference] as? [String:[String:Any?]] else { return nil }
        if(localizationsData.isEmpty){ return nil }
        
        var localizations:[String:NotificationLocalizationModel] = [:]
        
        for (languageCode, localizationData) in localizationsData {
            guard let localizationModel = NotificationLocalizationModel(fromMap: localizationData)
            else { continue }
            localizations[languageCode] = localizationModel
        }
        
        return localizations
        
    }
    
    public func validate() throws {
        try self.content?.validate()
        try self.schedule?.validate()
        
        if(self.actionButtons != nil){
            for button in self.actionButtons! {
                try button.validate()
            }
        }
    }
}
