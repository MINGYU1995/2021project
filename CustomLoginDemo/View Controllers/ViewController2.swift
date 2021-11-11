//
//  ViewController.swift
//  storyboardtest
//
//  Created by 박민규 on 2021/10/31.

import CoreML
import UIKit
import MobileCoreServices

class ViewController2:UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate { //delegate 를 위한 채택작업..

    @IBOutlet var imgView: UIImageView! //아웃렛 변수추가
    
    
    @IBOutlet weak var label: UILabel! = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "?"
        label.numberOfLines = 0
        return label
    }()

    

    
    //UIImagePickerController의 인스턴스 변수 생성
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    //사진 저장 여부를 나타낼 변수
    var flagImageSave = false
    // 사진을 저장할 변수
    var captureImage: UIImage!
    var videoURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        // Do any additional setup after loading the view.
        //delegate 쓰는데의 과정 위임자 정의
    }
    //사진 촬영하기
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
 
        label.frame = CGRect( //label 위치 값 좌표
            x: 155,
            y: view.safeAreaInsets.top+(view.frame.size.width-40)+10,
            width: view.frame.size.width-40,
            height: 450
        )
    }
    
    
    private func analyzeImage(image: UIImage?) {
        guard let buffer = image?.resize(size: CGSize(width: 299, height: 299))?
                .getCVPixelBuffer() else {
            return
        }

        do {
            let config = MLModelConfiguration()
            let model = try MyImageClassifier_1(configuration: config)
            let input = MyImageClassifier_1Input(image: buffer)

            let output = try model.prediction(input: input)
            let text = output.classLabel
            label.text = text
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    
    @IBAction func btnCaptureImageFromCamera(_ sender: Any) {
        
        //사진촬영
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
              // 사진 저장 플래그를 true로 설정
              flagImageSave = true
              
              // 이미지 피커의 델리케이트 self로 설정
              imagePicker.delegate = self
              // 이미지 피커의 소스 타입을 camera로 설정
              imagePicker.sourceType = .camera
              // 미디어 타입 kUTTypeImage로 설정
              imagePicker.mediaTypes = [kUTTypeImage as String]
              
              // 편집을 허용하지 않음
              imagePicker.allowsEditing = false
              
              // 현재 뷰 컨트롤러를 imagePicker로 대체. 즉 뷰에 imagePicker가 보이게 함
              present(imagePicker, animated: true, completion: nil)
          } else {
              // 카메라를 사용할 수 없을 때는 경고창을 나타냄
              myAlert("Camera inaccessable", message: "Application cannot access the camera.")
          }
        
    }
    

    
    @IBAction func btnLoadImageFromLibrary(_ sender: Any) { //사진불러오기
        
        
               if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
                   flagImageSave = false
                   
                   imagePicker.delegate = self
                   // 이미지 피커의 소스 타입을 PhotoLibrary로 설정
                   imagePicker.sourceType = .photoLibrary
                   
                   imagePicker.mediaTypes = [kUTTypeImage as String]
                   // 편집을 허용
                   imagePicker.allowsEditing = true
                   
                   present(imagePicker, animated: true, completion: nil)
               } else {
                   myAlert("Photo album inaccessable", message: "Application cannot access the photo album.")
               }
        }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
//        imageView2.image = image
        analyzeImage(image: image)
        
            // 미디어 종류 확인
            let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
           
            // 미디어 종류가 사진(Image)일 경우
            if mediaType.isEqual(to: kUTTypeImage as NSString as String){
                
                captureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                
                
            if flagImageSave { // flagImageSave가 true이면
                              // 사진을 포토 라이브러리에 저장
                              UIImageWriteToSavedPhotosAlbum(captureImage, self, nil, nil)
                          }
                          imgView.image = captureImage // 가져온 사진을 이미지 뷰에 출력
                
            // 미디어 종류가 비디오(Movie)일 경우
            } else if mediaType.isEqual(to: kUTTypeMovie as NSString as String) {
                 
            }
            // 현재의 뷰 컨트롤러를 제거. 즉, 뷰에서 이미지 피커 화면을 제거하여 초기 뷰를 보여줌
            self.dismiss(animated: true, completion: nil)
        }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // 현재의 뷰(이미지 피커) 제거
            self.dismiss(animated: true, completion: nil)
        }
        
        // 경고 창 출력 함수
        func myAlert(_ title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default , handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    
}
    

    





