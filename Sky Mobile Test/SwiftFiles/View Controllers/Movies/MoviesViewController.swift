//
//  MoviesViewController.swift
//  Sky Mobile Test
//
//  Created by Vitor Augusto Araujo Silva on 30/10/20.
//

import UIKit
import Alamofire
import Kingfisher


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}



class MoviesViewController: UIViewController {
    var moviesToShow: [Movies] = []


    @IBOutlet weak var selectionFilmsLabel: UILabel!
    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var activityLoading: UIActivityIndicatorView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
        
    let cellIdentifier = "ItemCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityLoading.startAnimating()
        setupCollectionView()
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupMovieData()
        self.moviesCollectionView.reloadData()
        
        
        
    }

    private func setupCollectionView(){
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        
        let itemCellNib = UINib(nibName: "ItemCollectionViewCell", bundle: nil)
        
        moviesCollectionView.register(itemCellNib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    private func setupMovieData() {

        self.activityLoading.startAnimating()
        self.activityLoading.isHidden = false
            ManagerAPI.shared.getMovies { (movies) in
                self.activityLoading.stopAnimating()
                self.activityLoading.isHidden = true
                self.noResultLabel.isHidden = true

                if let movies = movies, movies.count > 0 {
                    self.moviesToShow = movies
                    self.moviesCollectionView.reloadData()
                } else {
                    self.noResultLabel.isHidden = false
                   self.noResultLabel.text! = "Sem resultados"
                }

            }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}

extension MoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesToShow.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ItemCollectionViewCell else {return UICollectionViewCell()}
        
        let movie = moviesToShow[indexPath.row]
        cell.movieTitle.text = movie.title
       
        
        cell.movieImage.kf.indicatorType = .activity
        cell.movieImage.kf.setImage(with: URL(string: "https://sky-exercise.herokuapp.com/api/Movies"), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
    
        cell.movieImage.contentMode = .scaleAspectFill
        
        let defaultLink = "https://sky-exercise.herokuapp.com/api/Movies"

        let completeLink = defaultLink + moviesToShow[indexPath.row].cover_url


        cell.movieImage.downloaded(from: completeLink)
      
        

        let url = URL(string: movie.cover_url)

        DispatchQueue.main.async {
            let data = try? Data(contentsOf: url!)
            guard let dataU = data else{

                return
            }
            cell.movieImage.image = UIImage(data: dataU)
        }
        
        return cell
    }
    

    
}

