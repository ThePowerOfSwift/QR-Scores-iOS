//
//  Survey.swift
//  QR Scores
//
//  Created by Erick Sanchez on 12/4/18.
//  Copyright © 2018 LinnierGames. All rights reserved.
//

import Foundation

protocol SurveyProtocol: CreateSurveyProtocol {
    
    var id: String { get }
    
    associatedtype Participants: SurveyParticipants
    
    var participants: Participants { get }
}

protocol SurveyParticipants {
    var count: Int { get }
}

extension SurveyProtocol {
    var numberOfParticipants: Int {
        return self.participants.count
    }
}

class Survey: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case description
        case surveyType
        case generatedUrl
        case isClosed
        case isArchived
    }
    
    let id: String
    var title: String
    var description: String
    let surveyType: SurveyType
    
    let generatedUrl: URL
    var isClosed: Bool
    var isArchived: Bool
    
    var allowsDuplicateVotes: Bool {
        set {
            fatalError("\(#function) not implemented")
        }
        get {
            fatalError("\(#function) not implemented")
        }
    }
}

func check(
    survey: Survey,
    scanToVote: (ScanToVoteSurvey) -> Void,
    likeOrDislike: (LikeOrDislikeSurvey) -> Void,
    sliderAverage: (SliderAverageSurvey) -> Void,
    sliderHistogram: (SliderHistogramSurvey) -> Void) {
    
    if let castedSurvey = survey as? ScanToVoteSurvey {
        scanToVote(castedSurvey)
    } else if let castedSurvey = survey as? LikeOrDislikeSurvey {
        likeOrDislike(castedSurvey)
    } else if let castedSurvey = survey as? SliderAverageSurvey {
        sliderAverage(castedSurvey)
    } else if let castedSurvey = survey as? SliderHistogramSurvey {
        sliderHistogram(castedSurvey)
    }
}

func casted(_ survey: Survey) -> Survey {
    
    if let castedSurvey = survey as? ScanToVoteSurvey {
        return castedSurvey
    } else if let castedSurvey = survey as? LikeOrDislikeSurvey {
        return castedSurvey
    } else if let castedSurvey = survey as? SliderAverageSurvey {
        return castedSurvey
    } else if let castedSurvey = survey as? SliderHistogramSurvey {
        return castedSurvey
    } else {
        assertionFailure("No survey found")
        
        return survey
    }
}

class ScanToVoteSurvey: Survey, SurveyProtocol {
    
    enum InnerCodingKeys: String, CodingKey {
        case surveyMetadata
        case participants
        case options
    }
    
    var surveyMetadata: Metadata
    struct Metadata: SurveyMetadata, Codable {
        let thisIsEmpty: Bool = true
    }
    
    var options: Options
    struct Options: SurveyOptions, Codable {
        var allowsDuplicateVotes: Bool
    }
    
    override var allowsDuplicateVotes: Bool {
        set {
            options.allowsDuplicateVotes = newValue
        }
        get {
            return options.allowsDuplicateVotes
        }
    }
    
    var participants: Participants
    struct Participants: SurveyParticipants, Codable {
        let count: Int
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: InnerCodingKeys.self)
        self.surveyMetadata = try container.decode(Metadata.self, forKey: .surveyMetadata)
        self.options = try container.decode(Options.self, forKey: .options)
        self.participants = try container.decode(Participants.self, forKey: .participants)
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: InnerCodingKeys.self)
        try container.encode(self.surveyMetadata, forKey: .surveyMetadata)
        try container.encode(self.options, forKey: .options)
        try container.encode(self.participants, forKey: .participants)
        
        try super.encode(to: encoder)
    }
}

class LikeOrDislikeSurvey: Survey, SurveyProtocol {
    
    enum InnerCodingKeys: String, CodingKey {
        case surveyMetadata
        case participants
        case options
    }
    
    var surveyMetadata: Metadata
    struct Metadata: SurveyMetadata, Codable {
        let thisIsEmpty: Bool = true
    }
    
    var options: Options
    struct Options: SurveyOptions, Codable {
        var allowsDuplicateVotes: Bool
    }
    
    override var allowsDuplicateVotes: Bool {
        set {
            options.allowsDuplicateVotes = newValue
        }
        get {
            return options.allowsDuplicateVotes
        }
    }
    
    var participants: Participants
    struct Participants: SurveyParticipants, Codable {
        let count: Int
        let likes: Int
        let dislikes: Int
    }
    
    var likes: Int {
        return participants.likes
    }
    
    var dislikes: Int {
        return participants.dislikes
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: InnerCodingKeys.self)
        self.surveyMetadata = try container.decode(Metadata.self, forKey: .surveyMetadata)
        self.options = try container.decode(Options.self, forKey: .options)
        self.participants = try container.decode(Participants.self, forKey: .participants)
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: InnerCodingKeys.self)
        try container.encode(self.surveyMetadata, forKey: .surveyMetadata)
        try container.encode(self.options, forKey: .options)
        try container.encode(self.participants, forKey: .participants)
        
        try super.encode(to: encoder)
    }
}

class SliderAverageSurvey: Survey, SurveyProtocol {
    
    enum InnerCodingKeys: String, CodingKey {
        case surveyMetadata
        case participants
        case options
    }
    
    var surveyMetadata: Metadata
    struct Metadata: SurveyMetadata, Codable {
        
        struct SliderData: Codable {
            var title: String
            var color: String
        }
        var left: SliderData
        var right: SliderData
    }
    
    var options: Options
    struct Options: SurveyOptions, Codable {
        var allowsDuplicateVotes: Bool
    }
    
    override var allowsDuplicateVotes: Bool {
        set {
            options.allowsDuplicateVotes = newValue
        }
        get {
            return options.allowsDuplicateVotes
        }
    }
    
    var participants: Participants
    struct Participants: SurveyParticipants, Codable {
        let count: Int
        let average: Float
    }
    
    var leftTitle: String {
        return surveyMetadata.left.title
    }
    
    var leftColor: String {
        return surveyMetadata.left.color
    }
    
    var rightTitle: String {
        return surveyMetadata.right.title
    }
    
    var rightColor: String {
        return surveyMetadata.right.color
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: InnerCodingKeys.self)
        self.surveyMetadata = try container.decode(Metadata.self, forKey: .surveyMetadata)
        self.options = try container.decode(Options.self, forKey: .options)
        self.participants = try container.decode(Participants.self, forKey: .participants)
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: InnerCodingKeys.self)
        try container.encode(self.surveyMetadata, forKey: .surveyMetadata)
        try container.encode(self.options, forKey: .options)
        try container.encode(self.participants, forKey: .participants)
        
        try super.encode(to: encoder)
    }
}

class SliderHistogramSurvey: Survey, SurveyProtocol {
    
    enum InnerCodingKeys: String, CodingKey {
        case surveyMetadata
        case participants
        case options
    }
    
    var surveyMetadata: Metadata
    struct Metadata: SurveyMetadata, Codable {
        var min: Int
        var max: Int
    }
    
    var options: Options
    struct Options: SurveyOptions, Codable {
        var allowsDuplicateVotes: Bool
    }
    
    override var allowsDuplicateVotes: Bool {
        set {
            options.allowsDuplicateVotes = newValue
        }
        get {
            return options.allowsDuplicateVotes
        }
    }
    
    var participants: Participants
    struct Participants: SurveyParticipants, Codable {
        let count: Int
        let histogram: [Int: Int]?
    }
    
    var min: Int {
        return surveyMetadata.min
    }
    
    var max: Int {
        return surveyMetadata.max
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: InnerCodingKeys.self)
        self.surveyMetadata = try container.decode(Metadata.self, forKey: .surveyMetadata)
        self.options = try container.decode(Options.self, forKey: .options)
        self.participants = try container.decode(Participants.self, forKey: .participants)
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: InnerCodingKeys.self)
        try container.encode(self.surveyMetadata, forKey: .surveyMetadata)
        try container.encode(self.options, forKey: .options)
        try container.encode(self.participants, forKey: .participants)
        
        try super.encode(to: encoder)
    }
}
