import Foundation

struct Levels {
    let titleImageName: String
    let gameImageName: String
    let backgroundGameImageName: String
    let scoreLevel: String
    let items: [String]
    let holeOpened: Bool
    let mission: String
}

struct LevelsModel {
    let levels = [Levels(titleImageName: "level1", gameImageName: "levelImage1", backgroundGameImageName: "backLevel1", scoreLevel: "level1", items: LevelsItems.level1, holeOpened: false, mission: "mission1"), Levels(titleImageName: "level2", gameImageName: "levelImage2", backgroundGameImageName: "backLevel2", scoreLevel: "level2", items: LevelsItems.level2, holeOpened: false, mission: "mission2"), Levels(titleImageName: "level3", gameImageName: "levelImage3", backgroundGameImageName: "backLevel3", scoreLevel: "level3", items: LevelsItems.level3, holeOpened: true, mission: "mission3"), Levels(titleImageName: "level4", gameImageName: "levelImage4", backgroundGameImageName: "backLevel4", scoreLevel: "level4", items: LevelsItems.level4, holeOpened: false, mission: "mission4"), Levels(titleImageName: "level5", gameImageName: "levelImage5", backgroundGameImageName: "backLevel5", scoreLevel: "level5", items: LevelsItems.level5, holeOpened: true, mission: "mission5"), Levels(titleImageName: "level6secret", gameImageName: "levelImage6secret", backgroundGameImageName: "backLevelSecret", scoreLevel: "level6", items: LevelsItems.levelBonus, holeOpened: true, mission: "mission6")]
}
