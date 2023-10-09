# PinkyStocky

## 프로젝트 소개

- 개요: 주식의 현재 주가와 차트, 경제 뉴스를 종합적으로 확인할 수 있는 앱입니다.
- 아키텍쳐: MVC
- 프로젝트 종류: 개인 프로젝트
- 진행 기간: 2023-02-22 ~ 2023-04-18



## 주요화면 및 기능

### 📈 주식 차트 화면 (Stock)
> - Reload 버튼을 눌러 실시간 주가를 업데이트 할 수 있습니다.
> - 주가를 받아오는 동안 Loading 화면을 나타냅니다.
> - UserDefaults를 사용하여 원하는 주식이 저장될 수 있게 구현했습니다.
> - 저장한 주식을 오른쪽으로 밀어 삭제할 수 있습니다.
> - 주식을 클릭하면 해당 주식의 자세한 데이터와 뉴스 기사 등을 확인할 수 있습니다.
> - 서치 바에 원하는 주식을 검색하여 주식을 메인 화면에 담을 수 있습니다.



|실시간 주가 업데이트|주식 삭제|주식의 Detail 화면|메인화면에 주식 담기|
|:---:|:---:|:---:|:---:|
|<img src="https://github.com/Marigoldflower/PinkyStocky/assets/100112897/081482b9-6f8c-47d6-a93c-cabb48a78bab" width="200" height="400"/>|<img src="https://github.com/Marigoldflower/PinkyStocky/assets/100112897/0c069c72-80ac-45db-896c-f937bc0a00aa" width="200" height="400"/>|<img src="https://github.com/Marigoldflower/PinkyStocky/assets/100112897/5a804545-5fd2-40ef-80c9-f31644555551" width="200" height="400"/>|<img src="https://github.com/Marigoldflower/PinkyStocky/assets/100112897/90d4c3ec-9dda-4ad3-b6cd-4662b1db3e9f" width="200" height="400"/>|



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


