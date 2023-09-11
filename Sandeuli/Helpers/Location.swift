//
//  Location.swift
//  Sandeuli
//
//  Created by 황홍필 on 2023/09/06.
//

import Foundation
import CoreLocation
import Contacts
import UIKit

extension CLLocation {
    
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
    
}


extension CLPlacemark {
    /// street name, eg. Infinite Loop
    var streetName: String? { thoroughfare }
    /// // eg. 1
    var streetNumber: String? { subThoroughfare }
    /// city, eg. Cupertino
    var city: String? { locality }
    /// neighborhood, common name, eg. Mission District
    var neighborhood: String? { subLocality }
    /// state, eg. CA
    var state: String? { administrativeArea }
    /// county, eg. Santa Clara
    var county: String? { subAdministrativeArea }
    /// zip code, eg. 95014
    var zipCode: String? { postalCode }
    /// postal address formatted
    @available(iOS 11.0, *)
    var postalAddressFormatted: String? {
        guard let postalAddress = postalAddress else { return nil }
        return CNPostalAddressFormatter().string(from: postalAddress)
    }
    
}


// MARK: - 우리나라 시도 명칭 (미세먼지 측정을 위한 변수값)
var daegu: String { "대구광역시" }
var chungnam: String { "충청남도" }
var incheon: String { "인천광역시" }
var daejeon: String { "대전광역시" }
var gyeongbuk: String { "경상북도" }
var sejong: String { "세종특별자치시" }
var gwangju: String { "광주광역시" }
var jeonbuk: String { "전라북도" }
var gangwon: String { "강원도" }
var ulsan: String { "울산광역시" }
var jeonnam: String { "전라남도" }
var seoul: String { "서울특별시" }
var busan: String { "부산광역시" }
var jeju: String { "제주특별자치도" }
var chungbuk: String { "충청북도" }
var gyeongnam: String { "경상남도" }
var gyeonggi: String { "경기도" }

// MARK: - 미세먼지 농도를 측정하기 위해 필요한 지역 이름을 담은 메소드
func searchLocation(location: String) -> String{
    
    print("지금 들어오는 값은 \(location)")
    
    switch location {
    case daegu:
        return "daegu"
    case chungnam:
        return "chungnam"
    case incheon:
        return "incheon"
    case daejeon:
        return "daejeon"
    case gyeongbuk:
        return "gyeongbuk"
    case sejong:
        return "sejong"
    case gwangju:
        return "gwangju"
    case jeonbuk:
        return "jeonbuk"
    case gangwon:
        return "gangwon"
    case ulsan:
        return "ulsan"
    case jeonnam:
        return "jeonnam"
    case seoul:
        return "seoul"
    case busan:
        return "busan"
    case jeju:
        return "jeju"
    case chungbuk:
        return "chungbuk"
    case gyeongnam:
        return "gyeongnam"
    case gyeonggi:
        return "gyeonggi"
    default: return ""
    }
}

// MARK: - 우리나라 Region Code
// 이 함수의 결과값을 변수에 일단 담고 그 변수를 regionCode의 주소값에 넣어주면 된다.
func searchRegionCode(location: String) -> String {
    
    if location.contains("백령도") {
        return "11A00101"
    } else if location.contains("서울") {
        return "11B10101"
    } else if location.contains("과천") {
        return "11B10102"
    } else if location.contains("광명") {
        return "11B10103"
    } else if location.contains("강화") {
        return "11B20101"
    } else if location.contains("김포") {
        return "11B20102"
    } else if location.contains("인천") {
        return "11B20201"
    } else if location.contains("시흥") {
        return "11B20202"
    } else if location.contains("안산") {
        return "11B20203"
    } else if location.contains("부천") {
        return "11B20204"
    } else if location.contains("의정부") {
        return "11B20301"
    } else if location.contains("고양") {
        return "11B20302"
    } else if location.contains("양주") {
        return "11B20304"
    } else if location.contains("파주") {
        return "11B20305"
    } else if location.contains("동두천") {
        return "11B20401"
    } else if location.contains("연천") {
        return "11B20402"
    } else if location.contains("포천") {
        return "11B20403"
    } else if location.contains("가평") {
        return "11B20404"
    } else if location.contains("구리") {
        return "11B20501"
    } else if location.contains("남양주") {
        return "11B20502"
    } else if location.contains("양평") {
        return "11B20503"
    } else if location.contains("하남") {
        return "11B20504"
    } else if location.contains("수원") {
        return "11B20601"
    } else if location.contains("안양") {
        return "11B20602"
    } else if location.contains("오산") {
        return "11B20603"
    } else if location.contains("화성") {
        return "11B20604"
    } else if location.contains("성남") {
        return "11B20605"
    } else if location.contains("평택") {
        return "11B20606"
    } else if location.contains("의왕") {
        return "11B20609"
    } else if location.contains("군포") {
        return "11B20610"
    } else if location.contains("안성") {
        return "11B20611"
    } else if location.contains("용인") {
        return "11B20612"
    } else if location.contains("이천") {
        return "11B20701"
    } else if location.contains("광주") {
        return "11B20702"
    } else if location.contains("여주") {
        return "11B20703"
    } else if location.contains("충주") {
        return "11C10101"
    } else if location.contains("진천") {
        return "11C10102"
    } else if location.contains("음성") {
        return "11C10103"
    } else if location.contains("제천") {
        return "11C10201"
    } else if location.contains("단양") {
        return "11C10202"
    } else if location.contains("청주") {
        return "11C10301"
    } else if location.contains("보은") {
        return "11C10302"
    } else if location.contains("괴산") {
        return "11C10303"
    } else if location.contains("증평") {
        return "11C10304"
    } else if location.contains("추풍령") {
        return "11C10401"
    } else if location.contains("영동") {
        return "11C10402"
    } else if location.contains("옥천") {
        return "11C10403"
    } else if location.contains("서산") {
        return "11C20101"
    } else if location.contains("태안") {
        return "11C20102"
    } else if location.contains("당진") {
        return "11C20103"
    } else if location.contains("홍성") {
        return "11C20104"
    } else if location.contains("보령") {
        return "11C20201"
    } else if location.contains("서천") {
        return "11C20202"
    } else if location.contains("천안") {
        return "11C20301"
    } else if location.contains("아산") {
        return "11C20302"
    } else if location.contains("예산") {
        return "11C20303"
    } else if location.contains("대전") {
        return "11C20401"
    } else if location.contains("공주") {
        return "11C20402"
    } else if location.contains("계룡") {
        return "11C20403"
    } else if location.contains("세종") {
        return "11C20404"
    } else if location.contains("부여") {
        return "11C20501"
    } else if location.contains("청양") {
        return "11C20502"
    } else if location.contains("금산") {
        return "11C20601"
    } else if location.contains("논산") {
        return "11C20602"
    } else if location.contains("철원") {
        return "11D10101"
    } else if location.contains("화천") {
        return "11D10102"
    } else if location.contains("인제") {
        return "11D10201"
    } else if location.contains("양구") {
        return "11D10202"
    } else if location.contains("춘천") {
        return "11D10301"
    } else if location.contains("홍천") {
        return "11D10302"
    } else if location.contains("원주") {
        return "11D10401"
    } else if location.contains("횡성") {
        return "11D10402"
    } else if location.contains("영월") {
        return "11D10501"
    } else if location.contains("정선") {
        return "11D10502"
    } else if location.contains("평창") {
        return "11D10503"
    } else if location.contains("대관령") {
        return "11D20201"
    } else if location.contains("태백") {
        return "11D20301"
    } else if location.contains("속초") {
        return "11D20401"
    } else if location.contains("고성") {
        return "11D20402"
    } else if location.contains("양양") {
        return "11D20403"
    } else if location.contains("강릉") {
        return "11D20501"
    } else if location.contains("동해") {
        return "11D20601"
    } else if location.contains("삼척") {
        return "11D20602"
    } else if location.contains("울릉도") {
        return "1.10E+102"
    } else if location.contains("독도") {
        return "1.10E+103"
    } else if location.contains("전주") {
        return "11F10201"
    } else if location.contains("익산") {
        return "11F10202"
    } else if location.contains("정읍") {
        return "11F10203"
    } else if location.contains("완주") {
        return "11F10204"
    } else if location.contains("장수") {
        return "11F10301"
    } else if location.contains("무주") {
        return "11F10302"
    } else if location.contains("진안") {
        return "11F10303"
    } else if location.contains("남원") {
        return "11F10401"
    } else if location.contains("임실") {
        return "11F10402"
    } else if location.contains("순창") {
        return "11F10403"
    } else if location.contains("군산") {
        return "21F10501"
    } else if location.contains("김제") {
        return "21F10502"
    } else if location.contains("고창") {
        return "21F10601"
    } else if location.contains("부안") {
        return "21F10602"
    } else if location.contains("함평") {
        return "21F20101"
    } else if location.contains("영광") {
        return "21F20102"
    } else if location.contains("진도") {
        return "21F20201"
    } else if location.contains("완도") {
        return "11F20301"
    } else if location.contains("해남") {
        return "11F20302"
    } else if location.contains("강진") {
        return "11F20303"
    } else if location.contains("장흥") {
        return "11F20304"
    } else if location.contains("여수") {
        return "11F20401"
    } else if location.contains("광양") {
        return "11F20402"
    } else if location.contains("고흥") {
        return "11F20403"
    } else if location.contains("보성") {
        return "11F20404"
    } else if location.contains("순천시") {
        return "11F20405"
    } else if location.contains("광주") {
        return "11F20501"
    } else if location.contains("장성") {
        return "11F20502"
    } else if location.contains("나주") {
        return "11F20503"
    } else if location.contains("담양") {
        return "11F20504"
    } else if location.contains("화순") {
        return "11F20505"
    } else if location.contains("구례") {
        return "11F20601"
    } else if location.contains("곡성") {
        return "11F20602"
    } else if location.contains("순천") {
        return "11F20603"
    } else if location.contains("흑산도") {
        return "11F20701"
    } else if location.contains("목포") {
        return "21F20801"
    } else if location.contains("영암") {
        return "21F20802"
    } else if location.contains("신안") {
        return "21F20803"
    } else if location.contains("무안") {
        return "21F20804"
    } else if location.contains("성산") {
        return "11G00101"
    } else if location.contains("제주") {
        return "11G00201"
    } else if location.contains("성판악") {
        return "11G00302"
    } else if location.contains("서귀포") {
        return "11G00401"
    } else if location.contains("고산") {
        return "11G00501"
    } else if location.contains("이어도") {
        return "11G00601"
    } else if location.contains("추자도") {
        return "11G00800"
    } else if location.contains("울진") {
        return "11H10101"
    } else if location.contains("영덕") {
        return "11H10102"
    } else if location.contains("포항") {
        return "11H10201"
    } else if location.contains("경주") {
        return "11H10202"
    } else if location.contains("문경") {
        return "11H10301"
    } else if location.contains("상주") {
        return "11H10302"
    } else if location.contains("예천") {
        return "11H10303"
    } else if location.contains("영주") {
        return "11H10401"
    } else if location.contains("봉화") {
        return "11H10402"
    } else if location.contains("영양") {
        return "11H10403"
    } else if location.contains("안동") {
        return "11H10501"
    } else if location.contains("의성") {
        return "11H10502"
    } else if location.contains("청송") {
        return "11H10503"
    } else if location.contains("김천") {
        return "11H10601"
    } else if location.contains("구미") {
        return "11H10602"
    } else if location.contains("군위") {
        return "11H10603"
    } else if location.contains("고령") {
        return "11H10604"
    } else if location.contains("성주") {
        return "11H10605"
    } else if location.contains("대구") {
        return "11H10701"
    } else if location.contains("영천") {
        return "11H10702"
    } else if location.contains("경산") {
        return "11H10703"
    } else if location.contains("청도") {
        return "11H10704"
    } else if location.contains("칠곡") {
        return "11H10705"
    } else if location.contains("울산") {
        return "11H20101"
    } else if location.contains("양산") {
        return "11H20102"
    } else if location.contains("부산") {
        return "11H20201"
    } else if location.contains("창원") {
        return "11H20301"
    } else if location.contains("김해") {
        return "11H20304"
    } else if location.contains("통영") {
        return "11H20401"
    } else if location.contains("사천") {
        return "11H20402"
    } else if location.contains("거제") {
        return "11H20403"
    } else if location.contains("고성") {
        return "11H20404"
    } else if location.contains("남해") {
        return "11H20405"
    } else if location.contains("함양") {
        return "11H20501"
    } else if location.contains("거창") {
        return "11H20502"
    } else if location.contains("합천") {
        return "11H20503"
    } else if location.contains("밀양") {
        return "11H20601"
    } else if location.contains("의령") {
        return "11H20602"
    } else if location.contains("함안") {
        return "11H20603"
    } else if location.contains("창녕") {
        return "11H20604"
    } else if location.contains("진주") {
        return "11H20701"
    } else if location.contains("산청") {
        return "11H20703"
    } else if location.contains("하동") {
        return "11H20704"
    } else if location.contains("사리원") {
        return "11I10001"
    } else if location.contains("신계") {
        return "11I10002"
    } else if location.contains("해주") {
        return "11I20001"
    } else if location.contains("개성") {
        return "11I20002"
    } else if location.contains("장연") {
        return "11I20003"
    } else if location.contains("용연") {
        return "11I20003"
    } else if location.contains("신의주") {
        return "11J10001"
    } else if location.contains("삭주") {
        return "11J10002"
    } else if location.contains("수풍") {
        return "11J10002"
    } else if location.contains("구성") {
        return "11J10003"
    } else if location.contains("자성") {
        return "11J10004"
    } else if location.contains("종강") {
        return "11J10004"
    } else if location.contains("강계") {
        return "11J10005"
    } else if location.contains("희천") {
        return "11J10006"
    } else if location.contains("평양") {
        return "11J20001"
    } else if location.contains("진남포") {
        return "11J20002"
    } else if location.contains("남포") {
        return "11J20002"
    } else if location.contains("안주") {
        return "11J20004"
    } else if location.contains("양덕") {
        return "11J20005"
    } else if location.contains("청진") {
        return "11K10001"
    } else if location.contains("웅기") {
        return "11K10002"
    } else if location.contains("선봉") {
        return "11K10002"
    } else if location.contains("성진") {
        return "11K10003"
    } else if location.contains("무산") {
        return "11K10004"
    } else if location.contains("삼지연") {
        return "11K10004"
    } else if location.contains("함흥") {
        return "11K20001"
    } else if location.contains("장진") {
        return "11K20002"
    } else if location.contains("북청") {
        return "11K20003"
    } else if location.contains("신포") {
        return "11K20003"
    } else if location.contains("혜산") {
        return "11K20004"
    } else if location.contains("풍산") {
        return "11K20005"
    } else if location.contains("원산") {
        return "11L10001"
    } else if location.contains("고성") {
        return "11L10002"
    } else if location.contains("장전") {
        return "11L10002"
    } else if location.contains("평강") {
        return "11L10003"
    }
    
    return ""
}


