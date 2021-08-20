//
//  BookCollectionViewController.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 17/07/2021.
//

import UIKit

class BookCollectionViewController: UIViewController {

    
    // IBOutlet for navigation bar audio book button
    @IBOutlet weak var bookStopButton: UIBarButtonItem!
    
    // IBOutlet for the collection view
    @IBOutlet var collectionView: UICollectionView!
    
    // Variable to hold the chosen books name so it can be passed to the next VC
    var chosenBookName: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the collection view
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 120)
        collectionView.collectionViewLayout = layout
        collectionView.register(BookCollectionViewCell.nib(), forCellWithReuseIdentifier: K.bookCell)
        
        // Delegates
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}


//MARK: - Collection View Delegate

extension BookCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Set book and perform segue
        
        collectionView.deselectItem(at: indexPath, animated: true)
        chosenBookName = K.bookTitles[indexPath[1]]
        performSegue(withIdentifier: K.bookChosen, sender: self)
        
    }
    
    
    // segue override
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.bookChosen {
            let destinationVC = segue.destination as! ChosenBookViewController
            destinationVC.bookTitle = chosenBookName
        }
    }
    
    
}


//MARK: - Collection View Data Source

extension BookCollectionViewController: UICollectionViewDataSource {
    
    // Data source for the collection view
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return K.bookTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.bookCell, for: indexPath) as! BookCollectionViewCell
        cell.configure(with: UIImage(named: K.bookTitles[indexPath[1]])!)
        return cell
    }
    
    
}

extension BookCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    // Size books are displayed at
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 300)
    }
    
}


//MARK: - Audio Book Control

extension BookCollectionViewController {
    // Audio book navigation bar controls
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if SpeechService.shared.renderStopButton() {
            bookStopButton.image = UIImage(systemName: "play.slash")
        } else {
            bookStopButton.image = nil
        }
    }

    @IBAction func bookStopButtonPressed(_ sender: UIBarButtonItem) {
        SpeechService.shared.stopSpeeching()
        bookStopButton.image = nil
    }
}
