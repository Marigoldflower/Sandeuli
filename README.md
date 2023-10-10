# 산들이

## 프로젝트 소개

- 개요: 아기자기하고 산뜻한 UI를 바탕으로 사용자에게 실시간 온도, 하늘 상태, 최고 온도, 최저 온도 등의 날씨 정보를 제공하는 앱입니다.
- 아키텍쳐: MVVM, Combine
- 프로젝트 종류: 개인 프로젝트
- 진행 기간: 2023-07-22 ~ 2023-10-09



## 주요화면 및 기능

### ⛅️ 현재 날씨 상태 화면
> - 사용자 위치의 실시간 온도를 확인할 수 있습니다.
> - 사용자 위치의 실시간 하늘 상태를 나타냅니다. (비, 눈, 구름 많음 등)
> - 실시간 하늘 상태에 따라서 날씨 아이콘을 변경할 수 있도록 만들었습니다.
> - 실시간 하늘 상태에 따라서 날씨의 배경화면의 색상을 변경하였습니다.
> - 낮인지 밤인지에 따라서 배경화면의 색상을 밝게 또는 어둡게 설정하였습니다.
> - 오늘 날짜의 최고 온도와 최저 온도를 확인할 수 있습니다.
> - 일출 시간과 일몰 시간을 확인할 수 있습니다.



|청명함|구름많음|주식의 Detail 화면|메인화면에 주식 담기|
|:---:|:---:|:---:|:---:|
|<img src="https://github.com/Marigoldflower/Sandeuli/assets/100112897/1299caad-0bba-44df-b321-1ff323eebdd0" width="200" height="400"/>|<img src="https://github.com/Marigoldflower/Sandeuli/assets/100112897/01722f88-1cc7-44de-ab86-fbae2b791089" width="200" height="400"/>|<img src="https://github.com/Marigoldflower/PinkyStocky/assets/100112897/5a804545-5fd2-40ef-80c9-f31644555551" width="200" height="400"/>|<img src="https://github.com/Marigoldflower/PinkyStocky/assets/100112897/90d4c3ec-9dda-4ad3-b6cd-4662b1db3e9f" width="200" height="400"/>|


|낮|밤|
|:---:|:---:|
|<img src="https://github.com/Marigoldflower/Sandeuli/assets/100112897/ea6a903e-b7d4-4621-967c-d62e359a89a2" width="200" height="400"/>|<img src="https://github.com/Marigoldflower/Sandeuli/assets/100112897/83e134ac-e8de-46a5-9b8e-e55c9874b0ac" width="200" height="400"/>|



### 🏦 금융 정보 화면 (Financial)
> - 환율과 코인의 실시간 가격을 확인할 수 있습니다. 오른쪽으로 스크롤하여 더 많은 데이터를 확인할 수 있습니다.
> - Reload 버튼을 눌러 실시간 환율과 코인 및 주식의 가격을 업데이트 할 수 있습니다.
> - 아래로 스크롤하여 최신 경제 뉴스를 확인할 수 있습니다. (테이블 뷰로 구현)
> - 우량주의 현재가와 실시간 데이터를 확인합니다.


|환율과 코인의 실시간 가격 확인|실시간 환율, 코인 및 주식 가격 업데이트|최신 경제 뉴스 확인|
|:---:|:---:|:---:|
|<img src="https://github.com/Marigoldflower/PinkyStocky/assets/100112897/414755da-9f0b-4288-a27f-e1993d063499" width="200" height="400"/>|<img src="https://github.com/Marigoldflower/PinkyStocky/assets/100112897/a9eef009-f4e5-45aa-8737-f634b05e64d6" width="200" height="400"/>|<img src="https://github.com/Marigoldflower/PinkyStocky/assets/100112897/cb8abeaa-639a-415d-9eb5-fb8193692305" width="200" height="400"/>|



### 🌏 글로벌 뉴스 화면 (World Wide News)
> - 전 세계 최신 뉴스를 확인할 수 있는 화면입니다.
> - Top News를 큰 화면으로 배치했으며, 컬렉션 뷰를 통해 오른쪽으로 스크롤할 수 있도록 구현했습니다.
> - 아래로 스크롤하여 전 세계 최신 뉴스를 확인할 수 있습니다 (테이블 뷰로 구현)
> - 스크롤 바를 이용해 뉴스를 검색할 수 있도록 구현했습니다.

|Top News|최신 뉴스|최신 뉴스 검색|
|:---:|:---:|:---:|
|<img src="https://github.com/Marigoldflower/PinkyStocky/assets/100112897/9e67c42b-7ffc-4c91-bfd8-dc829e044acd" width="200" height="400"/>|<img src="https://github.com/Marigoldflower/PinkyStocky/assets/100112897/67228bb0-2ad1-43a8-8da8-06653e954c70" width="200" height="400"/>|<img src="https://github.com/Marigoldflower/PinkyStocky/assets/100112897/a9863a05-4d3f-48f8-a534-1fa81ae7220a" width="200" height="400"/>|


