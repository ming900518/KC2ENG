//
// Created by CC on 2019-03-10.
// Copyright (c) 2019 CC. All rights reserved.
//

import Foundation
import HandyJSON

class BattleCombinedEach: JsonBean {

    var api_result: Int = 0
    var api_result_msg: String = ""
    var api_data: BattleCombinedEachData? = BattleCombinedEachData()

    override func process() {
        Battle.instance.friendCombined = true
        Battle.instance.enemyCombined = true
        Battle.instance.friendFormation = api_data?.api_formation[0] ?? -1
        Battle.instance.enemyFormation = api_data?.api_formation[1] ?? -1
        Battle.instance.heading = api_data?.api_formation[2] ?? -1
        Battle.instance.airCommand = api_data?.api_kouku?.api_stage1?.api_disp_seiku ?? -1

        var enemies = Array<Ship>()
        if let list = api_data?.api_ship_ke {
            for (index, id) in list.enumerated() {
                if let rawShip = Raw.instance.rawShipMap[id] {
                    let enemy = Ship(rawShip: rawShip)
                    enemy.level = api_data?.api_ship_lv[safe: index] ?? 0
                    enemy.nowHp = api_data?.api_e_nowhps[safe: index] ?? 0
                    enemy.maxHp = api_data?.api_e_maxhps[safe: index] ?? 0
                    if let slots = api_data?.api_eSlot[safe: index] {
                        enemy.items.append(contentsOf: slots)
                    }
                    enemies.append(enemy)
                }
            }
        }
        Battle.instance.enemyList = enemies
        var subEnemies = Array<Ship>()
        if let list = api_data?.api_ship_ke_combined {
            for (index, id) in list.enumerated() {
                if let rawShip = Raw.instance.rawShipMap[id] {
                    let enemy = Ship(rawShip: rawShip)
                    enemy.level = api_data?.api_ship_lv_combined[safe: index] ?? 0
                    enemy.nowHp = api_data?.api_e_nowhps_combined[safe: index] ?? 0
                    enemy.maxHp = api_data?.api_e_maxhps_combined[safe: index] ?? 0
                    if let slots = api_data?.api_eSlot_combined[safe: index] {
                        enemy.items.append(contentsOf: slots)
                    }
                    subEnemies.append(enemy)
                }
            }
        }
        Battle.instance.subEnemyList = subEnemies

        Battle.instance.newTurn()

        Battle.instance.calcFriendOrdinalDamage(damageList: api_data?.api_kouku?.api_stage3?.api_fdam)
        Battle.instance.calcFriendOrdinalDamage(damageList: api_data?.api_kouku?.api_stage3_combined?.api_fdam, combined: true)
        Battle.instance.calcEnemyOrdinalDamage(damageList: api_data?.api_kouku?.api_stage3?.api_edam)
        Battle.instance.calcEnemyOrdinalDamage(damageList: api_data?.api_kouku?.api_stage3_combined?.api_edam, combined: true)
        Battle.instance.calcFriendOrdinalDamage(damageList: api_data?.api_air_base_injection?.api_stage3?.api_fdam)
        Battle.instance.calcEnemyOrdinalDamage(damageList: api_data?.api_air_base_injection?.api_stage3?.api_edam)
        Battle.instance.calcFriendOrdinalDamage(damageList: api_data?.api_injection_kouku?.api_stage3?.api_fdam)
        Battle.instance.calcEnemyOrdinalDamage(damageList: api_data?.api_injection_kouku?.api_stage3?.api_edam)
        api_data?.api_air_base_attack.forEach { it in
//            Battle.instance.calcFriendOrdinalDamage(damageList: it.api_stage3?.api_fdam)
            Battle.instance.calcEnemyOrdinalDamage(damageList: it.api_stage3?.api_edam)
            Battle.instance.calcEnemyOrdinalDamage(damageList: it.api_stage3_combined?.api_edam, combined: true)
        }

        Battle.instance.calcEnemyOrdinalDamage(damageList: api_data?.api_support_info?.api_support_airattack?.api_stage3?.api_edam)
        Battle.instance.calcEnemyOrdinalDamage(damageList: api_data?.api_support_info?.api_support_hourai?.api_damage)

        Battle.instance.calcTargetDamage(targetList: api_data?.api_opening_taisen?.api_df_list,
                damageList: api_data?.api_opening_taisen?.api_damage,
                flagList: api_data?.api_opening_taisen?.api_at_eflag)
        Battle.instance.calcFriendOrdinalDamage(damageList: api_data?.api_opening_atack?.api_fdam)
        Battle.instance.calcEnemyOrdinalDamage(damageList: api_data?.api_opening_atack?.api_edam)
        Battle.instance.calcTargetDamage(targetList: api_data?.api_hougeki1?.api_df_list,
                damageList: api_data?.api_hougeki1?.api_damage,
                flagList: api_data?.api_hougeki1?.api_at_eflag)
        Battle.instance.calcTargetDamage(targetList: api_data?.api_hougeki2?.api_df_list,
                damageList: api_data?.api_hougeki2?.api_damage,
                flagList: api_data?.api_hougeki2?.api_at_eflag)
        Battle.instance.calcTargetDamage(targetList: api_data?.api_hougeki3?.api_df_list,
                damageList: api_data?.api_hougeki3?.api_damage,
                flagList: api_data?.api_hougeki3?.api_at_eflag)
        Battle.instance.calcFriendOrdinalDamage(damageList: api_data?.api_raigeki?.api_fdam)
        Battle.instance.calcEnemyOrdinalDamage(damageList: api_data?.api_raigeki?.api_edam)

        Battle.instance.calcRank()

        Battle.instance.phaseShift(value: Phase.BattleCombinedEach)
    }
}

class BattleCombinedEachData: HandyJSON {

    var api_deck_id: Int = 0
    var api_formation = Array<Int>()
    var api_f_nowhps = Array<Int>()
    var api_f_maxhps = Array<Int>()
    var api_f_nowhps_combined = Array<Int>()
    var api_f_maxhps_combined = Array<Int>()
    var api_fParam = Array<Array<Int>>()
    var api_fParam_combined = Array<Array<Int>>()
    var api_ship_ke = Array<Int>()
    var api_ship_lv = Array<Int>()
    var api_ship_ke_combined = Array<Int>()
    var api_ship_lv_combined = Array<Int>()
    var api_e_nowhps = Array<Int>()
    var api_e_maxhps = Array<Int>()
    var api_e_nowhps_combined = Array<Int>()
    var api_e_maxhps_combined = Array<Int>()
    var api_eSlot = Array<Array<Int>>()
    var api_eSlot_combined = Array<Array<Int>>()
    var api_eParam = Array<Array<Int>>()
    var api_eParam_combined = Array<Array<Int>>()
    var api_flavor_info = Array<ApiFlavorInfo>()
    var api_midnight_flag: Int = 0
    var api_search = Array<Int>()
    var api_air_base_attack = Array<EachAirBaseAttack>()
    var api_air_base_injection: ApiAirBaseInjection? = ApiAirBaseInjection()
    var api_injection_kouku: ApiInjectionKouku? = ApiInjectionKouku()
    var api_stage_flag = Array<Int>()
    var api_kouku: ApiCombinedKouku? = ApiCombinedKouku()
    var api_support_flag: Int = 0
    var api_support_info: ApiSupportInfo? = ApiSupportInfo()
    var api_opening_taisen_flag: Int = 0
    var api_opening_taisen: ApiOpeningTaisen? = ApiOpeningTaisen()
    var api_opening_flag: Int = 0
    var api_opening_atack: ApiOpeningAtack? = ApiOpeningAtack()
    var api_hourai_flag = Array<Int>()
    var api_hougeki1: ApiHougeki? = ApiHougeki()
    var api_hougeki2: ApiHougeki? = ApiHougeki()
    var api_hougeki3: ApiHougeki? = ApiHougeki()
    var api_raigeki: CombinedRaigeki? = CombinedRaigeki()

    required init() {

    }

}

class EachAirBaseAttack: HandyJSON {

    var api_base_id: Int = 0
    var api_stage_flag = Array<Int>()
    var api_plane_from = Array<Any>()
    var api_squadron_plane = Array<ApiSquadronPlane>()
    var api_stage3: ApiStage3? = ApiStage3()
    var api_stage2: ApiStage2? = ApiStage2()
    var api_stage1: ApiStage1? = ApiStage1()
    var api_stage3_combined: ApiStage3Combined? = ApiStage3Combined()

    required init() {

    }

}

class CombinedRaigeki: HandyJSON {

    var api_fdam = Array<Double>()
    var api_edam = Array<Double>()

    required init() {

    }

}

class ApiSquadronPlane: HandyJSON {

    var api_mst_id: Int = 0
    var api_count: Int = 0

    required init() {

    }

}

class ApiFlavorInfo: HandyJSON {

    var api_boss_ship_id: String = ""
    var api_type: String = ""
    var api_voice_id: String = ""
    var api_class_name: String = ""
    var api_ship_name: String = ""
    var api_message: String = ""
    var api_pos_x: String = ""
    var api_pos_y: String = ""
    var api_data: String = ""

    required init() {

    }

}
