//
//  ViewController.swift
//  ProjectMemeGeneratorChallenge
//
//  Created by Ana Caroline de Souza on 19/03/20.
//  Copyright © 2020 Ana e Leo Corp. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imageView: UIImageView!
    var currentImage: UIImage?
    var topPhrase: String?
    var bottomPhrase: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        title = "THE MEME GENERATOOR"
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImageToScreen)),UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(sendMeme))]
        
        setupImageView()

    }
    
    func setupImageView(){
        
        imageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {return}
        currentImage = image
        dismiss(animated: true)
        
        let ac = UIAlertController(title: "Top Phrase", message: "Give your meme a top phrase ", preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Ok", style: .default) {
                [weak self, weak ac] _ in
                guard let topPhrase = ac?.textFields?[0].text else { return }
                self?.topPhrase = topPhrase
                self?.askBottomPhrase()
            })
        present(ac, animated: true)
    }
    
    func askBottomPhrase(){
        let ac2 = UIAlertController(title: "Bottom Phrase", message: "Give your meme a bottom phrase ", preferredStyle: .alert)
             ac2.addTextField()
             ac2.addAction(UIAlertAction(title: "Ok", style: .default) {
                 [weak self, weak ac2] _ in
                 guard let bottomPhrase = ac2?.textFields?[0].text else { return }
                 self?.bottomPhrase = bottomPhrase
                 self?.buildMeme()
             })
         present(ac2, animated: true)
    }
    
    func buildMeme() {
        
        guard let realImage = currentImage else {return}
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: realImage.size.width , height: realImage.size.height))
        
                let imageToShare = renderer.image { ctx in
        
                    realImage.draw(at: CGPoint(x: 0, y: 0))
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = .center
                    paragraphStyle.lineBreakMode = .byClipping
                    
                    let attrs: [NSAttributedString.Key: Any] = [
                        .font: UIFont.systemFont(ofSize: 72),
                        .foregroundColor: UIColor.white,
                        .paragraphStyle: paragraphStyle,
                        .strokeColor: UIColor.black
                    ]

                    
                    if let topPhraseString = topPhrase {
                        let attributedString = NSAttributedString(string: topPhraseString, attributes: attrs)
                        
                        attributedString.draw(with:
                            CGRect(x: 20,
                                   y: 80,
                                   width: realImage.size.width,
                                   height: 300),
                                   options: .usesFontLeading,
                                   context: nil)
                    }

                    if let bottomPhraseString = bottomPhrase {
                        let attributedString = NSAttributedString(string: bottomPhraseString, attributes: attrs)

                        attributedString.draw(with:
                            CGRect(x: 20,
                                   y: 400,
                                   width: realImage.size.width,
                                   height: 300),
                                   options: .usesFontLeading,
                                   context: nil)
                    }

                }
        imageView.image = imageToShare
    }
    
    @objc func addImageToScreen() {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        picker.allowsEditing = true
        picker.delegate = self
        present(picker,animated: true)
    }
    
    @objc func sendMeme() {
        guard let image = imageView.image else {return}
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
         vc.popoverPresentationController?.barButtonItem =
             navigationItem.rightBarButtonItem
         present(vc, animated: true)
    }
}

