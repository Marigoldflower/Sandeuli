# 산들이

## 프로젝트 소개

- 개요: 아기자기하고 산뜻한 UI를 바탕으로 사용자에게 실시간 온도, 하늘 상태, 최고 온도, 최저 온도 등의 날씨 정보를 제공하는 앱입니다.
- 아키텍쳐: MVVM, Combine
- 프로젝트 종류: 개인 프로젝트
- 진행 기간: 2023-07-22 ~ 2023-10-09



## 주요화면 및 기능

### 🌦️ 현재 날씨 상태 화면
> - 사용자 위치의 실시간 온도를 확인할 수 있습니다.
> - 사용자 위치의 실시간 하늘 상태를 나타냅니다. (비, 눈, 구름 많음 등)
> - 실시간 하늘 상태에 따라서 날씨 아이콘을 변경할 수 있도록 만들었습니다.
> - 실시간 하늘 상태에 따라서 날씨의 배경화면의 색상을 변경하였습니다.
> - 낮인지 밤인지에 따라서 배경화면의 색상을 밝게 또는 어둡게 설정하였습니다.
> - 오늘 날짜의 최고 온도와 최저 온도를 확인할 수 있습니다.
> - 일출 시간과 일몰 시간을 확인할 수 있습니다.
> - 오늘 하루의 날씨를 예보합니다.




|청명함|구름많음|주식의 Detail 화면|메인화면에 주식 담기|
|:---:|:---:|:---:|:---:|
|<img src="https://github.com/Marigoldflower/Sandeuli/assets/100112897/4621ed2a-451e-436e-a53b-e21e2ce05648" width="310" height="400"/>|<img src="https://github.com/Marigoldflower/Sandeuli/assets/100112897/01722f88-1cc7-44de-ab86-fbae2b791089" width="310" height="400"/>|<img src="https://github.com/Marigoldflower/PinkyStocky/assets/100112897/5a804545-5fd2-40ef-80c9-f31644555551" width="200" height="400"/>|<img src="https://github.com/Marigoldflower/PinkyStocky/assets/100112897/90d4c3ec-9dda-4ad3-b6cd-4662b1db3e9f" width="200" height="400"/>|


|낮|밤|
|:---:|:---:|
|<img src="https://github.com/Marigoldflower/Sandeuli/assets/100112897/ea6a903e-b7d4-4621-967c-d62e359a89a2" width="200" height="400"/>|<img src="https://github.com/Marigoldflower/Sandeuli/assets/100112897/83e134ac-e8de-46a5-9b8e-e55c9874b0ac" width="200" height="400"/>|



### 🌦️ 10일간의 일기 예보
> - 오늘로부터 10일간의 날씨를 예보합니다.
> - 10일간의 최고 온도와, 최저 온도를 확인할 수 있습니다.
> - 10일간의 하늘 상태를 확인할 수 있습니다.


|10일간의 일기 예보|
|:---:|
|<img src="https://github.com/Marigoldflower/Sandeuli/assets/100112897/7f7b5f31-f438-40b6-b39b-e66e71d45325" width="200" height="400"/>|




### 🌦️ 자외선 지수와 강우량 및 체감 온도
> - 현재 날짜의 자외선 지수를 체크할 수 있습니다. 자외선 지수에 따른 조치방법 또한 확인할 수 있습니다.
> - 자외선 지수의 농도에 따라 달라지는 표정 UI를 사용하여 자외선 지수가 좋은지 좋지 않은지 한 눈에 파악할 수 있도록 만들었습니다.
> - 현재 날짜의 강우량을 확인할 수 있으며, 강우 예보를 간략하게 체크할 수 있습니다.
> - 바람과 햇빛의 강도를 게산하여 현재 체감 온도를 측정합니다.

|자외선 지수|강우량|체감온도|
|:---:|:---:|:---:|
|<img src="https://github.com/Marigoldflower/Sandeuli/assets/100112897/6fbd1e00-2c62-4fef-9270-b6dacacdda5d" width="200" height="200"/>|<img src="https://github.com/Marigoldflower/Sandeuli/assets/100112897/3141978e-9e38-45db-afd5-e7f96ad91303" width="310" height="200"/>|<img src="https://github.com/Marigoldflower/Sandeuli/assets/100112897/f471d5e0-9868-4df5-8056-4cb722f3139a" width="311" height="200"/>|



### 🌦️ 습도와 미세먼지 & 초미세먼지
> - 현재 날짜의 습도와 이슬점을 실시간으로 확인할 수 있습니다. 
> - 미세먼지 농도와 초미세먼지 농도를 체크할 수 있습니다.
> - 미세먼지, 초미세먼지 농도가 좋을 때엔 파란색, 보통일 때엔 녹색, 나쁠 때엔 노란색, 매우 나쁠 때엔 빨간색으로 구분하여 사용자가 한 눈에 보기 편하도록 UI를 구성하였습니다.
> - 미세먼지, 초미세먼지의 농도에 따라 달라지는 표정 UI를 사용하여 미세먼지, 초미세먼지 농도가 좋은지 좋지 않은지 한 눈에 파악할 수 있도록 만들었습니다.


|습도|미세먼지 & 초미세먼지|
|:---:|:---:|
|<img src="https://github.com/Marigoldflower/Sandeuli/assets/100112897/becd747f-f619-4257-bb8a-68d200271b2a" width="310" height="200"/>|<img src="https://github.com/Marigoldflower/Sandeuli/assets/100112897/d8a5f05d-91d1-4bed-8ad1-382ee06322ed" width="310" height="200"/>|



