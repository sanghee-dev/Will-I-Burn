# Will I Burn🥵
사용자의 피부 타입과 위치에 따른 UV로 피부가 타는 시간을 계산해 알림을 띄우는 서비스입니다.

## Skills
### iOS
- Swift
- Storyboard
- UserDefaults

### Pattern
- MVVM
- Singleton

### Framework, Library
- Combine
- User Defaults
- SwiftLint

## 특징

### Combine 적용
- Combine의 이벤트 처리 연산자들을 통해 버튼 이벤트나 api등 비동기 이벤트들을 처리합니다.

### Singleton Pattern
- Burntime, WeatherApi, Location, UserDefaults, Notification 등을 관리하는 클래스를 싱글톤 패턴으로 작성하여 해당 인스턴스가 중복 생성되지 않도록 하였습니다.

## 화면

### 위치 요청
- 사용자 위치에 대한 허가를 요청합니다.
- 위치 허가가 완료되면 사용자의 위치 정보를 가져와 UserDefaults에 저장합니다.

<img src="https://user-images.githubusercontent.com/61302874/144183275-92459da8-bd32-42a5-a405-3689ce723787.png" width="300" >

### Api 처리
- UV api로부터 UV 정보를 가져와 피부가 타는 시간을 계산하는 동안 활동표시기를 띄우고 버튼을 비활성화합니다.
- 계산이 완료되었으면 화면에 띄웁니다.

<img src="https://user-images.githubusercontent.com/61302874/144183763-c8562ec0-7d71-46dc-8e15-e52ad8af2fdf.png" width="300" >

### Skin Type 변경
- 스킨 타입은 UserDefaults에 저장하며 변경할 수 있습니다.
- 타입이 변경되면 즉시 시간이 계산되고 피부 컬러칩과 피부 타입 이름 등 UI가 변경됩니다.

<img src="https://user-images.githubusercontent.com/61302874/144184084-18327387-2281-46b0-8697-87a0e25b04d7.png" width="300" >

### Skin
- Skin에는 type(Pale/Light, Fair, Medium...), time, color 정보를 가지고 있습니다.
- Skin은 convenience init을 활용하여 초기화할 수 있습니다.

<img src="https://user-images.githubusercontent.com/61302874/144184119-80ccd62e-380e-47d7-916d-e0d59ffdf689.png" width="300" >

### Notification
- 알림을 설정하면, 해당 시간 이후 알림을 띄웁니다.

<img src="https://user-images.githubusercontent.com/61302874/144183942-1f3e1320-3872-4cf3-9a22-8fa892993729.png" width="300" align="left" >
<img src="https://user-images.githubusercontent.com/61302874/127141631-af263b44-c731-4da9-b272-bf9eee2ff3f4.gif" width="300" >

### Darkmode
- 다크모드 적용이 가능합니다.

<img src="https://user-images.githubusercontent.com/61302874/144183950-e0dcb558-803a-4e5b-8835-289aac4a3a26.png" width="300" >
