import Speech

// class SFSpeechRecognizer : NSObject      핵심적인 음성 인식: 권한 요청, 객체 생성, 오디오 컨텐츠 준비해서 SFSPeechRecognitionRequest -> 음성인식 메서드 호출(recognitionTask 메서드)
// class SFSpeechAudioBufferRecognitionRequest      SFSpeechRecognitionRequest: 오디오 음성인식
// class SFSpeechRecognitionTask : NSObject     음성인식 작업 상태 확인, 중지, 취소, 작업종료 신호

class SpeechRecognizer: NSObject, ObservableObject, SFSpeechRecognizerDelegate {    // NSObject: Foundation에서 Class가 제공하는 기본 기능
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))!     //SFSpeechRecognizer로 음성인식 기능 처리하고 결과 반환하게함
    //앞에 것이 옵셔널 타입을 반환하는 생성자여서 반환값 nil일 가능성 제거
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?      // 실시간, 녹음된 오디오 데이터를 음성인식 서비스에 전달
    private var recognitionTask: SFSpeechRecognitionTask?       // 음성인식 상태 관리, 결과
    private let audioEngine = AVAudioEngine()       // 오디오 입력 및 출력 관리, 오디오 녹음 -> 입력 실시간 처리 -> recognitionTask에 오디오 데이터 전달
    
    @Published var transcript = ""      // 텍스트로 변환된 string 변수 -> Published여서 view에서 감지하고 업데이트 가능
    private var isTranscribing = false      // 음성인식 중인지 여부 파악
    @Published var sttText = ""
    
    override init() {       // 상위 클래스의 init 메소드를 재정의, 하위 클래스의 init 동작 바꾸기
        super.init()        // 상위 클래스의 초기화 작업 무시하지 않고 추가 작업
        self.speechRecognizer.delegate = self       // 위임: SpeechRecognizer의 이벤트(음성인식 시작, 종료)를 현재 class가 처리
    }
    
    func startTranscribing() {
        // 기존 음성 인식중인지 판단
        guard !isTranscribing else { return }       // guard는 조건이 참이 아니면 함수 종료
        
        // 음성 인식 시작 판별 프로퍼티 상태 변경
        isTranscribing = true
        
        // 오디오 엔진이 실행 중이면 중지하고 모든 tap을 제거
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }

        
        // 기존 실행된 음성 인식 작업인, recognitionTask가 있다면 해당 작업 취소
        recognitionTask?.cancel()
        recognitionTask = nil
        
        // 오디오 세션 설정 및 활성화
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("오디오 세션 설정 실패: \(error)")
            isTranscribing = false
            return
        }
        
        // 음성 인식 요청 생성
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()        // 오디오 데이터 애플의 음성 인식 서버로 전송
        guard let recognitionRequest = recognitionRequest else {
          // 설정 중 오류 시 음성 인식 상태 변경
          isTranscribing = false
          return
        }
        
        // 부분적 결과 보고 설정 :  중간 인식 결과를 지속적으로 받아볼 수 있도록
        recognitionRequest.shouldReportPartialResults = true
        
        // 음성 인식 작업 설정
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let strongSelf = self else { return }     // 음성인식 작업 시작 텍스트 변환 작업
            // 비동기적으로 수행되며 결과와 오류는 클로저를 통해 처리
            
            var isFinal = false
            
            if let result = result {
                DispatchQueue.main.async {      // 텍스트 변환 값 메인 뷰에 반영
                    strongSelf.transcript = result.bestTranscription.formattedString
                }
                isFinal = result.isFinal
            }
            // 실제 결과 처리 클로저로 음성 인식 결과가 있을 경우 변환된 텍스트에 값을 넣기 위해 가장 정확한 변환 텍스트이 값을 저장하는 코드
            
            
            if error != nil || isFinal {
                // 초기화
                strongSelf.cleanup()
            }
        }
        
        // 오디오 엔진에 tap을 추가 -> 음성데이터를 실시간으로 받아와서 음성 인식 요청 객체로 보내기 위한 단계
        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)     // 오디오 엔진에서 마이크로 입력받는 오디오 형식
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        // inputNode: 오디오 입력
        // tap: 설치해서 실시간으로 오디오 받을 수 있도록
        // onBus: 오디오 노드 내 특정 버스에 tap을 설치 -> 0번 버스는 단일 입력 노드
        // bufferSize: 콜백에서 캡처할 오디오 데이터의 버퍼 크기 설정
        // format: 캡처할 오디오 데이터의 포캣 설정
        // SFSpeechAidopBufferRecognitionRequest 객체에 오디오 버퍼를 추가해 음성을 실시간으로 음성 인식 서비스로 전송하고 텍스르트로 변환
        
        do {
            try audioEngine.start()
        } catch {
            print("오디오 엔진 시작 실패: \(error)")
            cleanup()
        }
    }
    
    func stopTranscribing(){
        // 음성인식 종료!
        recognitionTask?.cancel()
        sttText = transcript
        cleanup()
    }
    
    private func cleanup(){
        // 설정 초기화!
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask = nil
        isTranscribing = false //  인식 중 상태 해제
    }
}
